# Compiler-Workshop

Workshop on compilers featuring the DMD as frontend and LLVM as backend

## DLang

[D](https://dlang.org/) is a general-purpose systems-level programming language that excels at metaprogramming and design-by-introspection (basically querying the compiler at compile-time and generating different code based on these queries).
On top of these, D also provides a memory-safety mechanism which is less compiler-heavy but also less rigorous than that of Rust.

To install it, run this command (don't forget to run the `source` command printed by the install script to activate the compiler):

```bash
curl -fsS https://dlang.org/install.sh | bash -s dmd
```

We'll display some of D's features highlighted above.
Enter the `d-features` folder.

### [`ctfe.d`](d-features/ctfe.d)

This file shows that D is capable of running functions at compile-time provided their inputs are known to the compiler.
This feature is called **Compile-Time Function Execution (CTFE)**.

Run `make ctfe`.
Notice that simply compiling the code prints the strings in the `main()` function.
This is possible because both `jsonConfig` and `parsedConfig` are `immutable` which makes them known at compile time because their value cannot change.

### `__traits()`

This is in my opinion the bread and butter of D's strong metaprogramming.
`__traits()` is a construction that interrogates the compiler at compile-time.
It asks the compiler for various information that can then be used to customise the generated code.

This feature works well in conjunction with `static if` statements which use the syntax of regular `if`s but are evaluated at **compile-time**.
Similarly, `staic foreach` statements are `foreach` statements that unrolled and their code is generated rather than run at compile-time.
By far one of the coolest `__traits()` is `__traits(compiles, /* Some D code */)` which is `true` if the D code compiles and is often used like this:

```D
static if (__traits(compiles, /* Some D code */))
    /* The same D code */
```

I.e. if some code compiles, use it.

Follow the code in [`d-features/traits_compiles.d`](d-features/traits_compiles.d).
Run it and figure out how it works.

### `mixin`

You can also encounter `__traits()` in [`d-features/auto_string.d`](d-features/auto_string.d).
In this snippet we use design-by-introspection to automatically generate the `toString()` method for any `struct` / `class`.
To generate and insert code at compile-time we use the `mixin` keyword.
Go through the code mentioned above and notice how `mixin` works with the template `AutoToString` which in turn uses `__traits(getMember)` to access the members of a generic `struct` or `class`.

### [`safe.d`](d-features/safe.d)

Safety is enforeced in D mostly at the function level by using the `@safe` keyword.
This is a [rather complex mechanism](https://dlang.org/spec/memory-safe-d.html). that works mostly by forbidding certain memory-related actions such as pointer arithmetic.

Inspect the code in `d-features/safe.d`.
Compile it with `make safe` and run it with `./safe`.
Notice that it incorrectly prints the 11th element of the array.

**Task:** Change `unsafe_func()` from `@trusted` to `@safe` and make the code compile without changing its functionality (it must still print the 11th element of the array).
We dare you, we double dare you!
You have a partial solution in the `safe_func()` function, but that function produces an error at runtime.
Why?

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
