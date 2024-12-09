import Foundation

func main() {
    let filePath = "./Sources/data.txt"
    let rawData = loadFile(path: filePath)
    if rawData == nil {
        return
    }

    let parsedData = parseRawData(rawData: rawData!)
    solve(parsedData: parsedData)

}

func solve(parsedData: [(target: Int, data: [Int])]) {
    var count = 0

    for point in parsedData {
        let target = point.target
        let startNumber = Number(value: point.data[0])
        var startData = point.data
        startData.remove(at: 0)

        if checkExpr(numbers: startData, expr: startNumber, target: target) {
            count += target
        }
    }

    print(count)
}

func checkExpr(numbers: [Int], expr: Token, target: Int) -> Bool {
    if numbers.count == 0 {
        return expr.eval() == target
    }

    let concact = Number(value: concatNumbers(left: expr.eval(), right: numbers[0]))
    let add = Add(left: Number(value: expr.eval()), right: Number(value: numbers[0]))
    let multiply = Multiply(left: Number(value: expr.eval()), right: Number(value: numbers[0]))
    var numCopy = numbers
    numCopy.remove(at: 0)

    if checkExpr(numbers: numCopy, expr: add, target: target)
        || checkExpr(numbers: numCopy, expr: multiply, target: target)
        || checkExpr(numbers: numCopy, expr: concact, target: target)
    {
        return true
    } else {
        return false
    }
}

func concatNumbers(left: Int, right: Int) -> Int {
    return (left * multiplySize(number: right)) + right
}

func multiplySize(number: Int) -> Int {
    if number < 10 {
        return 10
    }
    if number < 100 {
        return 100
    }
    return 1000
}

func parseRawData(rawData: String) -> [(target: Int, data: [Int])] {
    let splitRawData = rawData.split(separator: "\n")

    let createGroupings = splitRawData.map {
        Substring in
        Substring.split(separator: ":").compactMap {
            Substring in
            Substring.split(separator: " ").map {
                Int($0)!
            }
        }
    }

    let parsedData = createGroupings.map {
        (target: $0[0][0], data: $0[1])
    }

    return parsedData
}

func loadFile(path: String) -> String? {
    do {
        return try String(contentsOfFile: path, encoding: .utf8)
    } catch {
        print(error)
        return nil
    }
}

main()
