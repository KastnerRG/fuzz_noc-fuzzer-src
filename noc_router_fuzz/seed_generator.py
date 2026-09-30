import random

# for i in range(5):
#     seed_path = 'afl_seeds/random.seed.len40.' + str(i)
#     with open(seed_path, 'wb') as f:
#         for i in range(40):
#             b = random.randint(0,255)
#             f.write(bytes([b]))

for i in range(10):
    seed_path = 'afl_seeds/random.seed.len100.' + str(i)
    with open(seed_path, 'wb') as f:
        for i in range(40):
            b = random.randint(0,255)
            f.write(bytes([b]))

# for i in range(5):
#     seed_path = 'afl_seeds/random.seed.len300.' + str(i)
#     with open(seed_path, 'wb') as f:
#         for i in range(300):
#             b = random.randint(0,255)
#             f.write(bytes([b]))



