import Foundation

// --------------------------------------------------------------------------------------------------------------------

func main() {
    // Part 1
    let filePath = "./Sources/data.txt"
    let fileData: String? = loadFile(file: filePath)
    if fileData == nil {
        return
    }

    var (evenSide, oddSide) = splitData(fileData: fileData!)
    evenSide.sort()
    oddSide.sort()

    let distance = findAbs(leftArray: evenSide, rightArray: oddSide)
    print("Distance between points = \(distance)")

    // Part 2
    let score = buildScore(leftArray: evenSide, rightArray: oddSide)
    print("Similarity score = \(score)")
}

main()

// --------------------------------------------------------------------------------------------------------------------
// Part 1
// --------------------------------------------------------------------------------------------------------------------

func loadFile(file: String) -> String? {
    do {
        return try String(contentsOfFile: file, encoding: .utf8)
    } catch {
        print(error)
        return nil
    }
}

func splitData(fileData: String) -> ([Int], [Int]) {
    let data = fileData.split(whereSeparator: { $0 == " " || $0 == "\n" })

    // Even index into one array, odd index into another.
    var lhs: [Int] = []
    var rhs: [Int] = []

    for (idx, number) in data.enumerated() {
        if let convertedNumber = Int(number) {
            if idx % 2 == 0 {
                lhs.append(convertedNumber)
            } else {
                rhs.append(convertedNumber)
            }
        }
    }

    return (lhs, rhs)
}

func findAbs(leftArray: [Int], rightArray: [Int]) -> Int {
    var total = 0

    for i in 0..<leftArray.count {
        total += abs((rightArray[i] - leftArray[i]))
    }

    return total
}

// --------------------------------------------------------------------------------------------------------------------
// Part 2
// --------------------------------------------------------------------------------------------------------------------

func increaseIdx(workingNumber: Int, workingIdx: Int, workingArray: [Int]) -> Int {
    var i = workingIdx

    while workingNumber > workingArray[i] && !(i >= workingArray.count - 1) {
        i += 1
    }

    return i
}

func buildScore(leftIdx: Int = 0, rightIdx: Int = 0, leftArray: [Int], rightArray: [Int]) -> Int {
    if leftIdx >= leftArray.count - 1 {
        return 0
    }

    var j = rightIdx
    var score = 0

    while leftArray[leftIdx] == rightArray[j] {
        score += 1
        j += 1
    }

    let subTotal = (leftArray[leftIdx] * score)

    let newI = increaseIdx(
        workingNumber: rightArray[j], workingIdx: leftIdx, workingArray: leftArray)
    let newJ = increaseIdx(workingNumber: leftArray[newI], workingIdx: j, workingArray: rightArray)

    return subTotal
        + buildScore(leftIdx: newI, rightIdx: newJ, leftArray: leftArray, rightArray: rightArray)
}

// --------------------------------------------------------------------------------------------------------------------
