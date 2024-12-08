import Foundation

func main() {
    let dataPath = "./Sources/data.txt"
    let rawData = loadData(dataPath: dataPath)
    if rawData == nil {
        return
    }

    let floorMap = parseData(rawData: rawData!)
    // Part 1
    // let route = solver.solve()
    // printMap(floorMap: floorMap, route: route!)

    // Part 2
    var solver = Solver(mapData: floorMap)
    solver.part2Solver()

}

func printMap(floorMap: [[String]], route: [Vector2]) {
    var base = floorMap

    for point in route {
        base[point.y][point.x] = "X"
    }

    base.forEach {
        print($0)
    }

    print(Array(base.joined()).filter { $0 == "X" }.count)
}

func loadData(dataPath: String) -> String? {
    do {
        return try String(contentsOfFile: dataPath, encoding: .utf8)
    } catch {
        print(error)
        return nil
    }
}

func parseData(rawData: String) -> [[String]] {
    let splitData = rawData.split(separator: "\n")

    return splitData.map { Substring in
        Substring.compactMap { Character in
            return String(Character)
        }
    }
}

main()
