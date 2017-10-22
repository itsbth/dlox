@safe:

import std.conv;

enum ObjType
{
    NIL,
    STRING,
    NUMBER,
    BOOL,
}

class WrongObjectTypeException : Exception
{
    this(string msg) pure
    {
        super(msg);
    }
}

union _value
{
    string s;
    double d;
    bool b;
};

class Obj
{
    ObjType type = ObjType.NIL;
    _value value;

    this() pure
    {

    }

    this(double d) pure
    {
        this = d;
    }

    this(string s) pure
    {
        this = s;
    }

    void opAssign(double d) pure
    {
        type = ObjType.NUMBER;
        value.d = d;
    }

    void opAssign(string s) @trusted pure
    {
        type = ObjType.STRING;
        value.s = s;
    }

    Obj opAdd(Obj b) pure const
    {
        if (isa(ObjType.NUMBER) && b.isa(ObjType.NUMBER))
            return new Obj(asDouble + b.asDouble);
        throw new WrongObjectTypeException("unable to add");
    }

    Obj opAdd(double b) pure const
    {
        if (isa(ObjType.NUMBER))
            return new Obj(asDouble + b);
        throw new WrongObjectTypeException("unable to add");
    }

    string asString() @trusted pure const
    {
        if (type != ObjType.STRING)
            throw new WrongObjectTypeException("wrong type");
        return value.s;
    }

    double asDouble() pure const
    {
        if (type != ObjType.NUMBER)
            throw new WrongObjectTypeException("wrong type");
        return value.d;
    }

    bool isa(ObjType t) pure const
    {
        return type == t;
    }

    override string toString() const
    {
        switch (type)
        {
        case ObjType.NIL:
            return "nil";
        case ObjType.NUMBER:
            return text(value.d);
        case ObjType.STRING:
            return asString();
        default:
            return "???";
        }
    }
}
