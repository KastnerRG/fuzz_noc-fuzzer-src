// AFL 2.x forkserver for one fresh VCS/UVM process per testcase.
#include "protocol.h"
#include <cerrno>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <string>
#include <vector>
#include <fcntl.h>
#include <sys/file.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <unistd.h>

static void fail(const char *message) {
    std::fprintf(stderr, "NoCFuzzer infrastructure error: %s (%s)\n", message, std::strerror(errno));
    std::exit(70);
}

static bool transfer(int fd, void *buffer, size_t length, bool writing) {
    auto *bytes = static_cast<unsigned char *>(buffer);
    while (length) {
        ssize_t n = writing ? write(fd, bytes, length) : read(fd, bytes, length);
        if (n < 0 && errno == EINTR) continue;
        if (n <= 0) return false;
        bytes += n;
        length -= static_cast<size_t>(n);
    }
    return true;
}

int main(int argc, char **argv) {
    if (argc < 2) { std::fprintf(stderr, "usage: native-proxy INPUT [SIMV_PLUSARGS...]\n"); return 64; }
    signal(SIGPIPE, SIG_IGN);
    struct rlimit no_core = {0, 0};
    setrlimit(RLIMIT_CORE, &no_core);
    // The database belongs to one serial forkserver; accidental sharing fails.
    int lock = open(".nocfuzzer.lock", O_CREAT | O_RDWR | O_CLOEXEC, 0600);
    if (lock < 0 || flock(lock, LOCK_EX | LOCK_NB)) fail("coverage directory is already in use");
    std::vector<unsigned char> local(NOC_MAP_SIZE, 0);
    unsigned char *map = local.data();
    if (const char *id = std::getenv("__AFL_SHM_ID")) {
        char *end = nullptr;
        long parsed = std::strtol(id, &end, 10);
        if (!*id || *end || parsed < 0) fail("invalid AFL shared memory id");
        void *shared = shmat(static_cast<int>(parsed), nullptr, 0);
        if (shared == reinterpret_cast<void *>(-1)) fail("cannot attach AFL feedback map");
        map = static_cast<unsigned char *>(shared);
    }
    uint32_t command = 0;
    const bool forkserver = transfer(NOC_FORKSRV_FD + 1, &command, sizeof(command), true);
    do {
        if (forkserver && !transfer(NOC_FORKSRV_FD, &command, sizeof(command), false)) break;
        std::memset(map, 0, NOC_MAP_SIZE);
        // Preserve compiled shape/design, remove every prior run's measurements.
        std::error_code error;
        std::filesystem::remove_all("simv.vdb/snps/coverage/db/testdata", error);
        if (error) { errno = error.value(); fail("cannot clear previous coverage"); }
        int channel[2];
        if (pipe(channel)) fail("cannot create feedback pipe");
        pid_t child = fork();
        if (child < 0) fail("cannot launch simulation");
        if (child == 0) {
            close(channel[0]);
            close(NOC_FORKSRV_FD);
            close(NOC_FORKSRV_FD + 1);
            prctl(PR_SET_PDEATHSIG, SIGKILL);
            if (getppid() == 1) _exit(70);
            std::string fd = std::to_string(channel[1]);
            setenv("NOCFUZZER_FEEDBACK_FD", fd.c_str(), 1);
            const char *log = std::getenv("NOCFUZZER_SIM_LOG");
            int log_fd = open(log ? log : "native-sim.log", O_CREAT | O_WRONLY | O_APPEND, 0600);
            if (log_fd < 0 || dup2(log_fd, STDOUT_FILENO) < 0 || dup2(log_fd, STDERR_FILENO) < 0) _exit(70);
            close(log_fd);
            std::string input = "+nocfuzzer_input=" + std::string(argv[1]);
            std::vector<char *> args = {const_cast<char *>("./simv"), const_cast<char *>("-cm"),
                const_cast<char *>("line+branch"), const_cast<char *>("-cm_name"),
                const_cast<char *>("nocfuzzer_case"), const_cast<char *>("+ntb_random_seed=1"), input.data()};
            for (int i = 2; i < argc; ++i) args.push_back(argv[i]);
            args.push_back(nullptr);
            execv(args[0], args.data());
            _exit(127);
        }
        close(channel[1]);
        uint32_t child_id = static_cast<uint32_t>(child);
        if (forkserver && !transfer(NOC_FORKSRV_FD + 1, &child_id, sizeof(child_id), true)) {
            kill(child, SIGKILL); fail("cannot report simulator pid to AFL");
        }
        noc_feedback feedback = {};
        bool complete = transfer(channel[0], &feedback, sizeof(feedback), false);
        const bool shape_ok = complete && feedback.magic == NOC_MAGIC && feedback.lines > 0 &&
            feedback.branches > 0 && feedback.length <= NOC_MAP_SIZE &&
            feedback.lines <= feedback.length && feedback.branches == feedback.length - feedback.lines;
        if (shape_ok) complete = transfer(channel[0], map, feedback.length, false);
        else complete = false;
        close(channel[0]);
        int status = 0;
        while (waitpid(child, &status, 0) < 0) if (errno != EINTR) fail("cannot wait for simulation");
        bool hit = false;
        if (complete) for (uint32_t i = 0; i < feedback.length; ++i) hit |= map[i] != 0;
        // Signals are genuine simulator crashes/timeouts, not invented wait codes.
        if (!WIFSIGNALED(status) && (!WIFEXITED(status) || WEXITSTATUS(status) != 0 || !complete || !hit))
            fail("simulation exited without complete, nonempty DUT line and branch feedback");
        if (const char *file = std::getenv("NOCFUZZER_MAP_FILE")) {
            int out = open(file, O_CREAT | O_WRONLY | O_TRUNC, 0600);
            if (out < 0 || !transfer(out, map, NOC_MAP_SIZE, true) || close(out)) fail("cannot save feedback map");
        }
        if (forkserver) {
            if (!transfer(NOC_FORKSRV_FD + 1, &status, sizeof(status), true)) fail("cannot report simulation status");
        } else {
            if (WIFSIGNALED(status)) { signal(WTERMSIG(status), SIG_DFL); raise(WTERMSIG(status)); }
            return WEXITSTATUS(status);
        }
    } while (forkserver);
    return 0;
}
