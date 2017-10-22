@safe:

import std.array;
import std.conv;
import std.string;
import scanner;
import obj;

abstract class Node
{
    abstract override string toString() const;
}

abstract class Expr : Node
{
}

class Literal : Expr
{
    Obj value;

    this(Obj value)
    {
        this.value = value;
    }

    override string toString() const {
        return value.toString();
    }
}

class Binop : Expr
{
    TokenType op;
    Expr lhs, rhs;

    this(TokenType op, Expr lhs, Expr rhs)
    {
        this.op = op;
        this.lhs = lhs;
        this.rhs = rhs;
    }
    
    override string toString() const {
        auto app = appender!string();
        app ~= "Binop(op = ";
        app ~= to!string(op);
        app ~= ", lhs = ";
        app ~= to!string(lhs);
        app ~= ", rhs = ";
        app ~= to!string(rhs);
        app ~= ")";
        return app.data;
    }
}
