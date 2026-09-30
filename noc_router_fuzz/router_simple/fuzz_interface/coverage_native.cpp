// Read only synthesizable DUT line/branch points from the current VCS test.
#include "protocol.h"
#include <covdb_user.h>
#include <algorithm>
#include <cerrno>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include <unistd.h>

static void fail(const char *message) {
    std::fprintf(stderr, "NoCFuzzer coverage error: %s\n", message);
    std::fflush(nullptr);
    _exit(70);
}

static covdbHandle metric(covdbHandle test, const char *name) {
    covdbHandle items = covdb_iterate(test, covdbMetrics), item, found = nullptr;
    while ((item = covdb_scan(items))) {
        if (!std::strcmp(covdb_get_str(item, covdbName), name)) {
            found = covdb_make_persistent_handle(item);
            break;
        }
    }
    covdb_release_handle(items);
    if (!found) fail("required Line or Branch metric missing");
    return found;
}

static covdbHandle find_dut(covdbHandle root) {
    covdbHandle items = covdb_iterate(root, covdbInstances), item, found = nullptr;
    while ((item = covdb_scan(items))) {
        const char *name = covdb_get_str(item, covdbName);
        if (!std::strcmp(name, "top_tb.dynamic_node") || !std::strcmp(name, "dynamic_node")) {
            found = covdb_make_persistent_handle(item);
            break;
        }
        found = find_dut(item);
        if (found) break;
    }
    covdb_release_handle(items);
    return found;
}

static void objects(covdbHandle parent, covdbHandle instance, covdbHandle test,
                    bool branch, std::vector<unsigned char> &map) {
    covdbHandle items = covdb_iterate(parent, covdbObjects), item;
    while ((item = covdb_scan(items))) {
        int64_t type = covdb_get(item, nullptr, nullptr, covdbType);
        if ((branch && type == covdbCross) || (!branch && type == covdbBlock)) {
            if (covdb_get(item, instance, test, covdbCoverable) > 0) {
                if (map.size() >= NOC_MAP_SIZE) fail("DUT coverage exceeds AFL map capacity");
                map.push_back(covdb_get(item, instance, test, covdbCovered) > 0 ? 1 : 0);
            }
        } else if (type == covdbContainer) {
            objects(item, instance, test, branch, map);
        }
    }
    covdb_release_handle(items);
}

static void instances(covdbHandle instance, covdbHandle test, bool branch,
                      std::vector<unsigned char> &map) {
    objects(instance, instance, test, branch, map);
    covdbHandle items = covdb_iterate(instance, covdbInstances), item;
    while ((item = covdb_scan(items))) instances(item, test, branch, map);
    covdb_release_handle(items);
}

static void send_all(int fd, const void *buffer, size_t size) {
    const auto *data = static_cast<const unsigned char *>(buffer);
    while (size) {
        ssize_t n = write(fd, data, size);
        if (n < 0 && errno == EINTR) continue;
        if (n <= 0) fail("feedback pipe closed");
        data += n;
        size -= static_cast<size_t>(n);
    }
}

extern "C" void nocfuzzer_fatal() {
    // Bypass VCS's crash handler so AFL observes a genuine SIGABRT wait status.
    std::fflush(nullptr);
    signal(SIGABRT, SIG_DFL);
    raise(SIGABRT);
    _exit(70);
}

extern "C" void nocfuzzer_feedback(int errors, int disabled) {
    const char *fd_string = std::getenv("NOCFUZZER_FEEDBACK_FD");
    if (!fd_string) fail("run simv through native-proxy");
    int fd = std::atoi(fd_string);
    covdbHandle design = covdb_load(covdbDesign, nullptr, "simv.vdb");
    if (!design) fail("cannot load current design database");
    covdbHandle test = covdb_load(covdbTest, design, "simv/nocfuzzer_case");
    if (!test) fail("current testcase coverage was not written");
    covdbHandle dut = find_dut(design);
    if (!dut) fail("top_tb.dynamic_node DUT instance missing");
    std::vector<unsigned char> map;
    uint32_t lines = 0;
    for (const char *name : {"Line", "Branch"}) {
        covdbHandle met = metric(test, name);
        covdbHandle qualified = covdb_get_qualified_handle(dut, met, covdbIdentity);
        if (!qualified) fail("cannot qualify DUT coverage instance");
        instances(qualified, test, name[0] == 'B', map);
        if (name[0] == 'L') lines = static_cast<uint32_t>(map.size());
        covdb_release_handle(qualified);
        covdb_release_handle(met);
    }
    covdb_release_handle(dut);
    covdb_unload(test);
    covdb_unload(design);
    uint32_t branches = static_cast<uint32_t>(map.size()) - lines;
    size_t hits = std::count(map.begin(), map.end(), 1);
    std::printf("NOCFUZZER_FEEDBACK line=%u branch=%u hit=%zu errors=%d\n", lines, branches, hits, errors);
    std::fflush(nullptr);
    if (!lines || !branches || !hits) fail("empty DUT line or branch coverage");
    noc_feedback feedback = {NOC_MAGIC, static_cast<uint32_t>(map.size()), lines, branches};
    if (disabled) feedback.length = feedback.lines = feedback.branches = 0;
    send_all(fd, &feedback, sizeof(feedback));
    if (!disabled) send_all(fd, map.data(), map.size());
    close(fd);
    if (errors) nocfuzzer_fatal();
}
