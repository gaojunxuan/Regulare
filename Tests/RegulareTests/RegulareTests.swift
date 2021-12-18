    import XCTest
    @testable import Regulare

    final class RegulareTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(Regulare().text, "Hello, World!")
        }
        
        func testLexer() {
            let lexer = Lexer("Hello(World)*")
            do {
                try lexer.tokenize()
                let expected: Array<Token> = [
                    Token.createToken(input: "H"),
                    Token.createConcatToken(),
                    Token.createToken(input: "e"),
                    Token.createConcatToken(),
                    Token.createToken(input: "l"),
                    Token.createConcatToken(),
                    Token.createToken(input: "l"),
                    Token.createConcatToken(),
                    Token.createToken(input: "o"),
                    Token.createConcatToken(),
                    Token.createToken(input: "("),
                    Token.createToken(input: "W"),
                    Token.createConcatToken(),
                    Token.createToken(input: "o"),
                    Token.createConcatToken(),
                    Token.createToken(input: "r"),
                    Token.createConcatToken(),
                    Token.createToken(input: "l"),
                    Token.createConcatToken(),
                    Token.createToken(input: "d"),
                    Token.createToken(input: ")"),
                    Token.createToken(input: "*"),
                ]
                XCTAssertEqual(lexer.tokens, expected)
            } catch {
                XCTFail()
            }
        }
        
        func testLexerUnpairedParentheses() {
            let lexer = Lexer("(()")
            let lexer2 = Lexer(")((")
            do {
                XCTAssertThrowsError(try lexer.tokenize()) { error in
                    let casted = error as? RegExSyntaxError
                    XCTAssertEqual(casted?.message, "Syntax error at 2")
                }
                XCTAssertThrowsError(try lexer2.tokenize()) { error in
                    let casted = error as? RegExSyntaxError
                    XCTAssertEqual(casted?.message, "Syntax error at 0")
                }
            }
        }
        
        func testParser() {
            let lexer = Lexer("Hello(World)*")
            do {
                try lexer.tokenize()
                let parser = Parser(lexer.tokens)
                let ast = try parser.parse()
                var prettyPrinted = ""
                ast.astPrettyPrint(strIn: &prettyPrinted, prefix: "", childrenPrefix: "")
                print(prettyPrinted)
            } catch {
                XCTFail()
            }
        }
    }
