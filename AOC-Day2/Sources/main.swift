import Foundation

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? { return self }
}

// --------------------------------------------------------------------------------------------------------------------

func main() {
    // Part 1
    let dataPath = "./Sources/data.txt"
    let data: String? = loadFile(filePath: dataPath)
    if data == nil {
        return
    }

    let dataSet = parseData(file: data!)
    if dataSet == nil {
        return
    }

    let valid = dataSet!.filter { Array in
        checkSaftey(readings: Array) == true
    }
    print("Valid without backchecking: \(valid.count)")

    // Part 2
    let remaining = dataSet!.filter { Array in
        checkSaftey(readings: Array) == false
    }

    let validWithSaftey = remaining.filter { Array in
        checkWithSaftey(data: Array) == true
    }
    print("Valid with backchecking: \(valid.count + validWithSaftey.count)")
}

// --------------------------------------------------------------------------------------------------------------------
// Part 1
// --------------------------------------------------------------------------------------------------------------------

func loadFile(filePath: String) -> String? {
    do {
        return try String(contentsOfFile: filePath, encoding: .utf8)
    } catch {
        print(error)
        return nil
    }
}

func parseData(file: String) -> [[Int]]? {
    let rawLines = file.split(whereSeparator: { $0 == "\n" })
    var parsedDataset: [[Int]] = []

    do {
        for line in rawLines {
            let rawArray = line.split(whereSeparator: { $0 == " " })

            let parsedLine = try rawArray.map { String in
                if let parsedDataPoint = Int(String) {
                    return parsedDataPoint
                } else {
                    throw "Unable to parse number"
                }
            }
            parsedDataset.append(parsedLine)
        }

        return parsedDataset

    } catch {
        print(error)
        return nil
    }
}

func checkSaftey(readings: [Int]) -> Bool {
    if readings[0] > readings[1] {
        return checkDecreasing(data: readings)
    } else if readings[0] < readings[1] {
        return checkIncreasing(data: readings)
    } else {
        return false
    }
}

func checkIncreasing(data: [Int]) -> Bool {
    var previous: Int?

    for point in data {
        if let previous {
            if point < previous {
                return false
            }

            let difference = point - previous
            if difference == 0 || difference > 3 {
                return false
            }
        }
        previous = point
    }
    return true
}

func checkDecreasing(data: [Int]) -> Bool {
    var previous: Int?

    for point in data {
        if let previous {
            if point > previous {
                return false
            }
            let difference = previous - point

            if difference == 0 || difference > 3 {
                return false
            }
        }
        previous = point
    }
    return true
}

// --------------------------------------------------------------------------------------------------------------------
// Part 2
// --------------------------------------------------------------------------------------------------------------------

func checkWithSaftey(data: [Int]) -> Bool {
    for i in 0..<data.count {
        var toCheck = data
        toCheck.remove(at: i)

        if checkIncreasing(data: toCheck) || checkDecreasing(data: toCheck) {
            return true
        }

    }
    return false
}

// --------------------------------------------------------------------------------------------------------------------

main()
