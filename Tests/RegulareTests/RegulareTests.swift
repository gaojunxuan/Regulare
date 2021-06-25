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
            let lexer = RegEx.Lexer("    1111010  test")
            let token = lexer.readToken()
            let token2 = lexer.readToken()
            debugPrint(token)
            XCTAssertEqual(token, RegEx.Token(tag: .num, value: "1111010"))
            XCTAssertEqual(token2, RegEx.Token(tag: .str, value: "test"))
        }
    }
