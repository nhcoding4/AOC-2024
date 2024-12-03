protocol Token {
    func asString() -> String
    func eval() -> Double
}

// ----------------------------------------------------------------------------------------------------------------
/*
    Not needed - we could just use a double but I had no idea what question 2 would entail so I thought this would be easier
    to extend if needed (like adding in operators based upon some logic and not just numbers).
*/

struct Number: Token {
    let value: Double
    init(value: Double) {
        self.value = value
    }

    func asString() -> String {
        return String(value)
    }

    func eval() -> Double {
        return value
    }
}

// ----------------------------------------------------------------------------------------------------------------

struct Multiply: Token {
    let left: Token
    let right: Token

    init(left: Token, right: Token) {
        self.left = left
        self.right = right
    }

    func asString() -> String {
        return "Expr: (\(left.asString()) * \(right.asString()))"
    }

    func eval() -> Double {
        return self.left.eval() * self.right.eval()
    }
}

// ----------------------------------------------------------------------------------------------------------------
