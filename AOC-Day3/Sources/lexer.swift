import Foundation

struct Lexer {
    let input: String
    var ch: Character?
    var current = 0
    var peek = 0
    var tokens: [Token] = []

    init(input: String) {
        self.input = input
        readChar()
        parseInput()
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Token creation.
    // ----------------------------------------------------------------------------------------------------------------

    mutating func parseInput() {
        while ch != nil {
            switch ch {
            case "m":
                if isValidIdent() {
                    parseNumber()
                } else {
                    readChar()
                }
            case "d":
                if isDontBlock() {
                    readUntilDo()
                } else {
                    readChar()
                }
            default:
                readChar()
            }
        }
    }

    mutating func parseNumber() {
        for _ in 0..<4 {
            readChar()
        }

        let number = consumeNumber()
        if number == nil {
            return
        }

        if ch == "," {
            readChar()
        } else {
            return
        }

        let number2 = consumeNumber()
        if number2 == nil {
            return
        }

        if ch == ")" {
            let numberToken = Number(value: Double(number!)!)
            let numberToken2 = Number(value: Double(number2!)!)
            tokens.append(Multiply(left: numberToken, right: numberToken2))
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Find idents
    // ----------------------------------------------------------------------------------------------------------------

    func isValidIdent() -> Bool {
        return peekChar(amount: 1) == "u"
            && peekChar(amount: 2) == "l" && peekChar(amount: 3) == "("
    }

    func isDontBlock() -> Bool {
        return peekChar(amount: 1) == "o" && peekChar(amount: 2) == "n"
            && peekChar(amount: 3) == "'" && peekChar(amount: 4) == "t"
            && peekChar(amount: 5) == "(" && peekChar(amount: 6) == ")"
    }

    func isDoBlock() -> Bool {
        return ch == "d" && peekChar(amount: 1) == "o" && peekChar(amount: 2) == "("
            && peekChar(amount: 3) == ")"
    }

    func isDigit() -> Bool {
        if ch == nil {
            return false
        }

        switch ch {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".":
            return true
        default:
            return false
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Advance and read characters
    // ----------------------------------------------------------------------------------------------------------------

    mutating func consumeNumber() -> String? {
        let start = input.index(input.startIndex, offsetBy: current)

        while isDigit() {
            readChar()
        }

        let end = input.index(input.startIndex, offsetBy: current - 1)
        if end < start {
            return nil
        }

        return String(input[start...end])
    }

    func peekChar(amount: Int) -> Character? {
        let offset = amount + current
        if offset >= input.count {
            return nil
        }

        let idx = input.index(input.startIndex, offsetBy: offset)
        return input[idx]
    }

    mutating func readUntilDo() {
        while ch != nil {
            if isDoBlock() {
                return
            }
            readChar()
        }
    }

    mutating func readChar() {
        if peek >= input.count {
            ch = nil
        } else {
            current = peek
            peek += 1
            let idx = input.index(input.startIndex, offsetBy: current)
            ch = input[idx]
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
}
