#ifndef NOCFUZZER_PROTOCOL_H
#define NOCFUZZER_PROTOCOL_H
#include <stdint.h>
#define NOC_MAP_SIZE 65536u
#define NOC_MAGIC 0x4e4f4346u
#define NOC_FORKSRV_FD 198
struct noc_feedback {
    uint32_t magic;
    uint32_t length;
    uint32_t lines;
    uint32_t branches;
};
#endif
