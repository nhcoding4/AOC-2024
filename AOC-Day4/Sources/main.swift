import Foundation

// ----------------------------------------------------------------------------------------------------------------

// Part 1 offsets

let LEFTOFFSETS = [[-1, 0], [-2, 0], [-3, 0]]
let RIGHTOFFSETS = [[1, 0], [2, 0], [3, 0]]
let DOWNOFFSETS = [[0, 1], [0, 2], [0, 3]]
let UPOFFSETS = [[0, -1], [0, -2], [0, -3]]
let DIAGONALUPLEFT = [[-1, -1], [-2, -2], [-3, -3]]
let DIAGONALUPRIGHT = [[1, -1], [2, -2], [3, -3]]
let DIAGONALDOWNLEFT = [[-1, 1], [-2, 2], [-3, 3]]
let DIAGONALDOWNRIGHT = [[1, 1], [2, 2], [3, 3]]

// ----------------------------------------------------------------------------------------------------------------

func main() {
    let rawDataPath = "./Sources/data.txt"
    let rawData = loadFile(path: rawDataPath)
    if rawData == nil {
        return
    }

    let wordGrid = splitData(rawData: rawData!)
    part1(wordGrid: wordGrid)
    part2(wordGrid: wordGrid)
}

// ----------------------------------------------------------------------------------------------------------------

func part1(wordGrid: [[String]]) {
    var found = 0

    for (y, row) in wordGrid.enumerated() {
        for (x, letter) in row.enumerated() {
            if letter != "X" {
                continue
            }
            found += checkDirections(wordGrid: wordGrid, x: x, y: y)
        }
    }

    print("Found XMAS \(found) times in the dataset.")
}

// ----------------------------------------------------------------------------------------------------------------

func part2(wordGrid: [[String]]) {
    var found = 0

    for (y, row) in wordGrid.enumerated() {
        for (x, letter) in row.enumerated() {
            if letter == "A" && checkValidBase(dataSet: wordGrid, x: x, y: y) {
                if checkValidLetters(dataSet: wordGrid, x: x, y: y) {
                    found += 1
                }
            }
        }
    }
    print("Found MAS in an X pattern \(found) times in the dataset.")
}

// ----------------------------------------------------------------------------------------------------------------
// Find data
// ----------------------------------------------------------------------------------------------------------------

func checkDirections(wordGrid: [[String]], x: Int, y: Int) -> Int {
    var found = 0
    // Check left from base
    if x - 3 >= 0 {
        if checkForXmas(data: wordGrid, startingX: x, startingY: y, offsets: LEFTOFFSETS) {
            found += 1
        }
    }
    // Check right from base
    if x + 3 < wordGrid[y].count {
        if checkForXmas(data: wordGrid, startingX: x, startingY: y, offsets: RIGHTOFFSETS) {
            found += 1
        }
    }
    // Check up from base
    if y - 3 >= 0 {
        if checkForXmas(data: wordGrid, startingX: x, startingY: y, offsets: UPOFFSETS) {
            found += 1
        }
    }
    // Check down from base
    if y + 3 < wordGrid.count {
        if checkForXmas(data: wordGrid, startingX: x, startingY: y, offsets: DOWNOFFSETS) {
            found += 1
        }
    }
    // Check diagonal-left up
    if x - 3 >= 0 && y - 3 >= 0 {
        if checkForXmas(data: wordGrid, startingX: x, startingY: y, offsets: DIAGONALUPLEFT) {
            found += 1
        }
    }
    // Check diagonal-right up
    if x + 3 < wordGrid[y].count && y - 3 >= 0 {
        if checkForXmas(
            data: wordGrid, startingX: x, startingY: y, offsets: DIAGONALUPRIGHT)
        {
            found += 1
        }
    }
    // Check diagonal-left down
    if x - 3 >= 0 && y + 3 < wordGrid.count {
        if checkForXmas(
            data: wordGrid, startingX: x, startingY: y, offsets: DIAGONALDOWNLEFT)
        {
            found += 1
        }
    }
    // Check diagonal-right down
    if x + 3 < wordGrid[y].count && y + 3 < wordGrid.count {
        if checkForXmas(
            data: wordGrid, startingX: x, startingY: y, offsets: DIAGONALDOWNRIGHT)
        {
            found += 1
        }
    }

    return found
}

// ----------------------------------------------------------------------------------------------------------------

func checkForXmas(data: [[String]], startingX: Int, startingY: Int, offsets: [[Int]]) -> Bool {
    for (i, offset) in offsets.enumerated() {
        let x = startingX + offset[0]
        let y = startingY + offset[1]
        let letter = data[y][x]

        if !checkCorrectLetter(index: i, letter: letter) {
            return false
        }
    }

    return true
}

// ----------------------------------------------------------------------------------------------------------------

func checkCorrectLetter(index: Int, letter: String) -> Bool {
    switch index {
    case 0:
        if letter == "M" {
            return true
        }
    case 1:
        if letter == "A" {
            return true
        }
    case 2:
        if letter == "S" {
            return true
        }
    default:
        ()
    }

    return false
}

// ----------------------------------------------------------------------------------------------------------------
// Dataset Creation
// ----------------------------------------------------------------------------------------------------------------

func loadFile(path: String) -> String? {
    do {
        return try String(contentsOfFile: path, encoding: .utf8)
    } catch {
        print(error)
        return nil
    }
}

// ----------------------------------------------------------------------------------------------------------------

func splitData(rawData: String) -> [[String]] {
    return rawData.split(separator: "\n").map { Substring in
        Substring.map { Character in
            return String(Character)
        }
    }
}

// ----------------------------------------------------------------------------------------------------------------
// Part 2
// ----------------------------------------------------------------------------------------------------------------

func checkValidBase(dataSet: [[String]], x: Int, y: Int) -> Bool {
    if y - 1 < 0 || y + 1 >= dataSet.count {
        return false
    }
    if x - 1 < 0 || x + 1 >= dataSet[y].count {
        return false
    }

    return true
}

// ----------------------------------------------------------------------------------------------------------------

func checkValidLetters(dataSet: [[String]], x: Int, y: Int) -> Bool {
    if y - 1 < 0 || y + 1 >= dataSet.count {
        return false
    }
    if x - 1 < 0 || x + 1 >= dataSet[y].count {
        return false
    }

    let topLeft = dataSet[y - 1][x - 1]
    let bottomRight = dataSet[y + 1][x + 1]
    if !checkLetterValidity(letterA: topLeft, letterB: bottomRight) {
        return false
    }

    let topRight = dataSet[y - 1][x + 1]
    let bottomLeft = dataSet[y + 1][x - 1]
    if !checkLetterValidity(letterA: topRight, letterB: bottomLeft) {
        return false
    }

    return true
}

// ----------------------------------------------------------------------------------------------------------------

func checkLetterValidity(letterA: String, letterB: String) -> Bool {
    switch letterA {
    case "M", "S":
        if letterA == "M" && letterB == "S" {
            return true
        }
        if letterA == "S" && letterB == "M" {
            return true
        }
    default:
        ()
    }

    return false
}

// ----------------------------------------------------------------------------------------------------------------

main()

// ----------------------------------------------------------------------------------------------------------------
