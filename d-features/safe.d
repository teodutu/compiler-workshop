import std.stdio;
import core.stdc.stdlib;

struct S
{
    int x;
};

void safe_func() @safe
{
    const int NUM_ELEMS = 10;
    S[] myStructs = new S[NUM_ELEMS];
    int i = 0;

    for (i = 0; i < NUM_ELEMS; ++i)
        myStructs[i].x = i;

    S last = myStructs[NUM_ELEMS];
    writeln("Value of last elem is ", last.x);
}

void unsafe_func() @trusted
{
    const int NUM_ELEMS = 10;
    S* myStructs = cast(S*) malloc(NUM_ELEMS * S.sizeof);
    int i = 0;

    for (i = 0; i < NUM_ELEMS; ++i)
        myStructs[i].x = i;

    S* last = myStructs + NUM_ELEMS;  // actually 11th element, out of bounds
    writeln("Value of last elem is ", last.x);
}

int main() @safe
{
    unsafe_func();
    // safe_func();

    return 0;
}
