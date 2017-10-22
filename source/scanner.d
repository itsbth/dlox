@safe:

import std.stdio;

enum TokenType
{
    // Single-character tokens.
    LEFT_PAREN,
    RIGHT_PAREN,
    LEFT_BRACE,
    RIGHT_BRACE,
    COMMA,
    DOT,
    MINUS,
    PLUS,
    SEMICOLON,
    SLASH,
    STAR,

    // One or two character tokens.
    BANG,
    BANG_EQUAL,
    EQUAL,
    EQUAL_EQUAL,
    GREATER,
    GREATER_EQUAL,
    LESS,
    LESS_EQUAL,

    // Literals.
    IDENTIFIER,
    STRING,
    NUMBER,

    // Keywords.
    AND,
    CLASS,
    ELSE,
    FALSE,
    FUN,
    FOR,
    IF,
    NIL,
    OR,
    PRINT,
    RETURN,
    SUPER,
    THIS,
    TRUE,
    VAR,
    WHILE,

    EOF
}

struct Token
{
    TokenType type;
    string lexeme;
}

bool isDigit(char c)
{
    return c >= '0' && c <= '9';
}

bool isAlpha(char c)
{
    return c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z';
}

bool isAlphaNum(char c)
{
    return isDigit(c) || isAlpha(c);
}

class Scanner
{
    static immutable TokenType[string] keywords;

    string source;
    Token[] tokens;
    int start, current, emitted;
    int line;

    static this()
    {
        keywords = ["and" : TokenType.AND, "class" : TokenType.CLASS, "else"
            : TokenType.ELSE, "false" : TokenType.FALSE, "for" : TokenType.FOR,
            "fun" : TokenType.FUN, "if" : TokenType.IF, "nil" : TokenType.NIL,
            "or" : TokenType.OR, "print" : TokenType.PRINT, "return" : TokenType.RETURN,
            "super" : TokenType.SUPER, "this" : TokenType.THIS, "true"
            : TokenType.TRUE, "var" : TokenType.VAR, "while" : TokenType.WHILE,];
    }

    this(string source)
    {
        this.source = source;
        this.tokens.length = 8;
    }

    Token[] scanTokens()
    {
        while (!isAtEnd())
        {
            start = current;
            scanToken();
        }
        return tokens[0 .. emitted];
    }

private:
    void scanToken()
    {
        char c = advance();
        switch (c)
        {
        case '(':
            addToken(TokenType.LEFT_PAREN);
            break;
        case ')':
            addToken(TokenType.RIGHT_PAREN);
            break;
        case '{':
            addToken(TokenType.LEFT_BRACE);
            break;
        case '}':
            addToken(TokenType.RIGHT_BRACE);
            break;
        case ',':
            addToken(TokenType.COMMA);
            break;
        case '.':
            addToken(TokenType.DOT);
            break;
        case '-':
            addToken(TokenType.MINUS);
            break;
        case '+':
            addToken(TokenType.PLUS);
            break;
        case ';':
            addToken(TokenType.SEMICOLON);
            break;
        case '*':
            addToken(TokenType.STAR);
            break;
        case '!':
            addToken(match('=') ? TokenType.BANG_EQUAL : TokenType.BANG);
            break;
        case '=':
            addToken(match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
            break;
        case '<':
            addToken(match('=') ? TokenType.LESS_EQUAL : TokenType.LESS);
            break;
        case '>':
            addToken(match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
            break;
        case '/':
            if (match('/'))
            {
                // A comment goes until the end of the line.
                while (peek() != '\n' && !isAtEnd())
                    advance();
            }
            else
            {
                addToken(TokenType.SLASH);
            }
            break;
        case ' ', '\t', '\r':
            // Ignore whitespace.
            break;

        case '\n':
            line++;
            break;
        case '"':
            string_();
            break;
        default:
            if (isDigit(c))
                number();
            else if (isAlpha(c))
                identifier();
            break;
        }
    }

    void string_()
    {
        while (peek() != '"' && !isAtEnd())
        {
            if (peek() == '\n')
                line++;
            advance();
        }

        // Unterminated string.
        if (isAtEnd())
            return;

        // The closing ".
        advance();

        // Trim the surrounding quotes.
        addToken(TokenType.STRING);
    }

    void number()
    {
        while (isDigit(peek()))
            advance();
        if (peek() == '.' && isDigit(peekNext()))
            while (isDigit(peek()))
                advance();
        addToken(TokenType.NUMBER);
    }

    void identifier()
    {
        while (isAlphaNum(peek()))
            advance();
        auto what = source[start .. current];
        if (what in keywords)
            addToken(keywords[what]);
        else
            addToken(TokenType.IDENTIFIER);
    }

    void addToken(TokenType type)
    {
        if (emitted == tokens.length)
            tokens.length *= 2;
        tokens[emitted++] = Token(type, source[start .. current]);
    }

    char advance()
    {
        if (isAtEnd())
        {
            return '\0';
        }
        return source[current++];
    }

    bool match(char c)
    {
        if (isAtEnd())
            return false;
        if (peek() != c)
            return false;
        current++;
        return true;
    }

    char peek()
    {
        if (isAtEnd())
            return '\0';
        return source[current];
    }

    char peekNext()
    {
        if (current + 1 >= source.length)
            return '\0';
        return source[current + 1];
    }

    bool isAtEnd()
    {
        return current >= source.length;
    }
}
