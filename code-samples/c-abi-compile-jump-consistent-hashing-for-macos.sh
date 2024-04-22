clang -fPIC -Wall -Wextra -O3 -g -MM jch.c >jch.d
clang -fPIC -Wall -Wextra -O3 -g  -c -o jch.o jch.c
clang -shared -lm -o libjch.dylib jch.o