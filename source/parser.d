@safe:

import scanner;
import ast;
import obj;

class Parser
{
    Token[] tokens;
    int position;

    this(Token[] tokens)
    {
        this.tokens = tokens;
    }

    Expr parse()
    {
        return equality();
    }

    Expr equality()
    {
        auto lhs = comparison();
        while (match(TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL))
        {
            auto op = prev();
            auto rhs = comparison();
            lhs = new Binop(op.type, lhs, rhs);
        }
        return lhs;
    }

    Expr comparison()
    {
        auto lhs = addition();
        while (match(TokenType.GREATER, TokenType.GREATER_EQUAL,
                TokenType.LESS, TokenType.LESS_EQUAL))
        {
            auto op = prev();
            auto rhs = addition();
            lhs = new Binop(op.type, lhs, rhs);
        }
        return lhs;
    }

    Expr addition()
    {
        auto lhs = multiplication();
        while (match(TokenType.PLUS, TokenType.MINUS))
        {
            auto op = prev();
            auto rhs = multiplication();
            lhs = new Binop(op.type, lhs, rhs);
        }
        return lhs;
    }

    Expr multiplication()
    {
        auto lhs = unary();

        return lhs;
    }

    Expr unary()
    {
        auto rhs = primary();

        return rhs;
    }

    Expr primary()
    {
        switch (peek().type)
        {
        case TokenType.NUMBER:
            return new Literal(new Obj(advance().lexeme));
        default:
            return null;
        }
    }

    bool match(TokenType[] types...)
    {
        foreach (type; types)
        {
            if (check(type))
            {
                advance();
                return true;
            }
        }
        return false;
    }

    bool check(TokenType type) const pure
    {
        if (isAtEnd())
            return false;
        return peek().type == type;
    }

    Token prev() const pure
    {
        return tokens[position - 1];
    }

    Token peek() const pure
    {
        return tokens[position];
    }

    Token advance()
    {
        return tokens[position++];
    }

    bool isAtEnd() const pure
    {
        return position >= tokens.length;
    }
}
