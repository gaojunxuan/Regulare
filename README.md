# Regulare

A regular expression engine built for learning formal language and automata theory. It allows for conversion between different representations of a regular language with APIs for visualization. The project was inspired by JFLAP, an interactive education app designed for undergraduate theory of computation. This library will also be extended to support different "flavors" of regular expression.

## Code Structure
This library is roughly organized in a way similar to a basic compiler. It takes the input regular expression, tokenizes it into a list of labeled tokens. The tokens is then parsed into a abstract syntax tree, which is used to create a finite state automaton (FSA) for string matching. 

### Lexer
The lexer performs lexicographic analysis and converts a plain string input to a list of tokens. The tokens that are supported include: character, operator, delimiters, quantifiers. Different from a conventional lexer, our lexer also checks for unpaired delimiters (as opposed to check them in the parse). The lexer implicitly inserts concatenation operators between characters (or capturing groups). This implicit insertion of operators partly rely on the assumption that the delimiters are well formatted.

### Parser
The parser parses a list of labeled tokens into an abstract syntax tree. An AST is a tree-like structure defined recursively. `ASTNode` protocol is the foundation of all types of `ASTNode`s.
