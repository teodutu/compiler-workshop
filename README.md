# Compiler-Workshop

Workshop on compilers featuring the DMD as frontend and LLVM as backend

## LLVM

[LLVM](https://llvm.org/) is one of the most popular compiler backends and the one used by the [`ldc` D compiler](https://github.com/ldc-developers/ldc).
Its most powerful feature and what makes LLVM so customisable is its **intermediate representation** called [LLVM IR](https://mcyoung.xyz/2023/08/01/llvm-ir/).
To install it, follow the instructions [here](https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm).
This may take a while and quite a bit of storage space, but it's well worth it.

This IR is a mid-point between the high-level AST created by the frontend and the low-level and machine-dependent assembly output by the compiler.
Its assembly-like structure allows for easy optimisations via **LLVM passes**.
These passes are functions that are compiled into libraries that can be loaded with the `opt` tool to modify existing LLVM IR.

Follow the code in the `llvm/` directory.
We'll work on [`sample.c`](llvm/sample.c).
The LLVM pass is [`FuncionPass.cpp`](llvm/FunctionPass.cpp).
It just prints the functions and instructions found and modifies all `add` instructions into `sub`.

1. Run `make build-pass` to build `build/libFunctionPass.so`.
This library contains the code in `FunctionPass.cpp`.

1. Run `make generate-llvmir` to generate the LLVM IR code corresponding to `sample.c`.
Inspect the code in `sample.ll`.

1. Run `make run-pass` to run the LLVM pass.
Notice the output then inspect the resulting file `sample_edited.ll`.

1. Run `make llvm-interpret` to interpret `sample_edited.ll` using LLVM's interpreter `lli`.

1. Run `make link-llvm` to generate the `sample_edited` executable from `sample_edited.ll`.
This uses `llc` to convert the LLVM IR code to Assembly and `clang` to assemeble and link it into an executable.

1. Run `make clean` to delete all resulting files and `make celean-pass` to remove the `build/` folder.
