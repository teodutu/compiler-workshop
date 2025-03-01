import std.json;
import std.stdio;
import std.string;
import std.algorithm;

immutable string jsonConfig = q"({
    "appName": "CTFE Demo",
    "version": 1,
    "enableLogging": true
})";

struct S { int x; }

JSONValue parseJSONStringConfig(string config)
{
    assert(config.canFind("version") && config.canFind("appName"));
    return parseJSON(config);
}

int parseJSONStringConfig(int x)
{
    return x + 2;
}

void main()
{
    immutable JSONValue parsedConfig = parseJSONStringConfig(jsonConfig);

    pragma(msg, "App Name: ", parsedConfig["appName"].str);
    pragma(msg, "Version: ", parsedConfig["version"].integer);
    pragma(msg, "Logging Enabled: ", parsedConfig["enableLogging"].boolean);
}
