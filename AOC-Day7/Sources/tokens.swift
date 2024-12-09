protocol Token {
    func eval() -> Int
}

struct Add: Token {
    let left: Token
    let right: Token

    func eval() -> Int {
        return (left.eval()) + right.eval()
    }
}

struct Multiply: Token {
    let left: Token
    let right: Token

    func eval() -> Int {
        return (left.eval()) * right.eval()
    }
}

struct Number: Token {
    let value: Int

    func eval() -> Int {
        return value
    }
}
