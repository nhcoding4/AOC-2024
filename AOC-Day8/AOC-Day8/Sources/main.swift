import Foundation

func main() {
    let filePath = "./Sources/data.txt"
    let rawData = loadData(path: filePath)
    if rawData == nil {
        return
    }

    let grid = createGrid(sortedData: parseData(rawData: rawData!))
    var solver = Solver(grid: grid)
    // solver.solveP1()
    // print(solver.findPlacements())

    solver.solveP2()
    solver.printGrid()
    print(solver.findPlacements())
}

func loadData(path: String) -> String? {
    do {
        return try String(contentsOfFile: path, encoding: .utf8)
    } catch {
        print(error)
        return nil
    }
}

func parseData(rawData: String) -> [[String]] {
    let splitData = rawData.split(separator: "\n")
    return splitData.map { Substring in
        Substring.compactMap { Character in
            String(Character)
        }
    }
}

func createGrid(sortedData: [[String]]) -> [[Cell]] {
    var grid: [[Cell]] = []

    for (y, row) in sortedData.enumerated() {
        var newRow: [Cell] = []
        for (x, token) in row.enumerated() {
            newRow.append(Cell(placement: Vector2(x: x, y: y), symbol: token))
        }
        grid.append(newRow)
    }

    return grid
}

main()
