import std.json;
import std.stdio;
import std.string;
import std.meta;
import std.conv;
import std.algorithm;

struct Bar
{
    void bar() { writeln("bar!"); }
}

struct Foo
{
    Bar[] bars;

    void foo() { writeln("foo!"); }
}

void tryCallBar(T)(T x)  // Template function
{
    static if (__traits(compiles, x.bar()))  // Evaluated at compile time
    {
        // Only this code is generated if the condition is true
        x.bar();
    } else
    {
        // Only this code is generated if the condition is false
        x.foo();
    }
}

void main()
{
    Foo f = Foo([Bar(), Bar(), Bar()]);  // 3 Bar's

    tryCallBar(f);  // This will call foo()

    static if (__traits(hasMember, typeof(f), "bars")
            && __traits(compiles, f.bars[0].bar()))
        foreach (b; f.bars)
            tryCallBar(b);  // These will call bar() 3 times
}
