grammar SpecialK;

// Parser
compilationUnit
    : PRINT StringLiteral
    ;

// LEXER

// Keywords
PRINT : 'print';

#include "java/lexer/literals.i4"
#include "java/lexer/whitespace.i4"
#include "java/lexer/comments.i4"
