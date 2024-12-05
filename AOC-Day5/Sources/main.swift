import Foundation

// ----------------------------------------------------------------------------------------------------------------

func main() {
    let location = "./Sources/data.txt"
    let rawData: String? = loadFile(path: location)
    if rawData == nil {
        return
    }

    // Part 1
    let data = createDataset(rawData: rawData!)
    let results = findPassingSequences(sequences: createSequences(parsedData: data))
    print(getMiddleNumbers(data: results.passing).reduce(0) { $0 + $1 })

    // Part 2
    var failings = results.failing
    failings = failings.map {
        var copy = $0
        copy.fixData()
        copy.checkConditions()
        return copy
    }

    let correctResults = findPassingSequences(sequences: failings)
    print(getMiddleNumbers(data: correctResults.passing).reduce(0) { $0 + $1 })
}

// ----------------------------------------------------------------------------------------------------------------
// Part 1
// ----------------------------------------------------------------------------------------------------------------

func getMiddleNumbers(data: [Sequence]) -> [Int] {
    return data.map { Sequence in
        let middleIdx = Int(floor(Double(Sequence.data.count) / 2))
        return Sequence.data[middleIdx]
    }
}

// ----------------------------------------------------------------------------------------------------------------

func findPassingSequences(sequences: [Sequence]) -> (passing: [Sequence], failing: [Sequence]) {
    let passing = sequences.filter { Sequence in
        Sequence.status == true
    }
    let failing = sequences.filter { Sequence in
        Sequence.status == false
    }

    return (passing, failing)
}

// ----------------------------------------------------------------------------------------------------------------
// Create Data
// ----------------------------------------------------------------------------------------------------------------

func createSequences(parsedData: (conditions: [[Int]], data: [[Int]])) -> [Sequence] {
    let conditions = parsedData.conditions.map { Array in
        Condition(before: Array[0], after: Array[1])
    }

    return parsedData.data.map { Array in
        Sequence(
            data: Array,
            conditions: conditions.filter { Array.contains($0.before) && Array.contains($0.after) })
    }
}

// ----------------------------------------------------------------------------------------------------------------

func createDataset(rawData: String) -> (conditions: [[Int]], data: [[Int]]) {
    let splitData = rawData.split(separator: "\n\n").map { Substring in
        Substring
    }

    let conditions = splitData[0].split(separator: "\n").compactMap { Substring in
        Substring.split(separator: "|").compactMap { Substring in
            Int(Substring.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    let data = splitData[1].split(separator: "\n").compactMap { Substring in
        Substring.split(separator: ",").compactMap { Substring in
            Int(Substring.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    return (conditions, data)
}

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

main()

// ----------------------------------------------------------------------------------------------------------------
