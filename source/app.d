@safe:

import std.stdio;
import ast;
import obj;
import parser;
import scanner;

void main()
{
    auto scan = new Scanner("2 + 1 + 1");
    auto tokens = scan.scanTokens();
    foreach (token; tokens)
    {
        writeln(token);
    }
    auto ast = new Parser(tokens).parse();
    writeln(ast.toString());
}
