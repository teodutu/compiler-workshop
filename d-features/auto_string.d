import std.stdio;
import std.traits;
import std.conv;

template AutoToString(T)
{
    string toString() const
    {
        string result = T.stringof ~ " { ";

        static foreach (i, field; FieldNameTuple!T) {
            result ~= field ~ ": " ~ to!string(__traits(getMember, this, field));
            static if (i < FieldNameTuple!T.length - 1)
                result ~= ", ";
        }

        return result ~ " }";
    }
}

struct Item
{
    int damage;
    string name;
}

struct User
{
    int id;
    string name;
    bool isActive;
    int[] arr;

    mixin AutoToString!User;
}

void main()
{
    pragma(msg, FieldNameTuple!User);


    User user = User(42, "Alice", true, [2, 6]);
    writeln(user.toString());  // Automatically generated toString() method
}
