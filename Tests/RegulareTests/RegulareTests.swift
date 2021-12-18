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
                let expected: Array<Lexer.Token> = [
                    Lexer.Token.createToken(input: "H"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "e"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "l"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "l"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "o"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "("),
                    Lexer.Token.createToken(input: "W"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "o"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "r"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "l"),
                    Lexer.Token.createConcatToken(),
                    Lexer.Token.createToken(input: "d"),
                    Lexer.Token.createToken(input: ")"),
                    Lexer.Token.createToken(input: "*"),
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
    }
