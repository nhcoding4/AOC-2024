struct Vector2 {
    let x: Int
    let y: Int
}

struct Cell {
    let placement: Vector2
    var symbol: String
    var pairedWith: [Vector2] = []
}

struct Solver {
    var grid: [[Cell]]
    var tokenTypes: Set<String> = []
    let rows: Int
    let columns: Int

    init(grid: [[Cell]]) {
        self.grid = grid
        self.rows = grid.count
        self.columns = grid[0].count
        self.tokenTypes = findTokenTypes()
        buildAssociations()
    }

    mutating func solveP1() {
        let relationships = getCellsWithAssociations()

        relationships.forEach { Cell in
            Cell.pairedWith.forEach { Vector2 in
                makePlacements(a: Cell.placement, b: Vector2)
            }
        }
    }

    mutating func makePlacements(a: Vector2, b: Vector2) {
        let xOffset = a.x + ((b.x - a.x) * 2)
        let yOffset = a.y + ((b.y - a.y) * 2)

        if (xOffset >= 0 && xOffset < columns) && (yOffset >= 0 && yOffset < rows) {
            grid[yOffset][xOffset].symbol = "#"
        }
    }

    mutating func solveP2() {
        let relationships = getCellsWithAssociations()

        relationships.forEach { Cell in
            Cell.pairedWith.forEach { Vector2 in
                makePlacementsP2(a: Cell.placement, b: Vector2)
            }
        }
    }

    mutating func makePlacementsP2(a: Vector2, b: Vector2) {
        var currentXa = a.x
        var currentYa = a.y
        var currentXb = b.x
        var currentYb = b.y

        let xChange = b.x - a.x
        let yChange = b.y - a.y

        repeat {
            if currentXa < 0 || currentXa >= columns {
                break
            }

            if currentYa < 0 || currentYa >= rows {
                break
            }

            grid[currentYa][currentXa].symbol = "#"

            currentXa = currentXb
            currentYa = currentYb

            currentXb += xChange
            currentYb += yChange

        } while true

    }

    func findPlacements() -> Int {
        return grid.flatMap { $0 }.filter { $0.symbol == "#" }.count
    }

    mutating func buildAssociations() {
        for token in tokenTypes {
            let filteredGrid = grid.flatMap {
                $0.filter {
                    $0.symbol == token
                }
            }

            let grouping = filteredGrid.map { $0.placement }

            filteredGrid.forEach { Cell in
                let relationships = grouping.filter {
                    $0.x != Cell.placement.x && $0.y != Cell.placement.y
                }
                grid[Cell.placement.y][Cell.placement.x].pairedWith = relationships
            }
        }
    }

    func getCellsWithAssociations() -> [Cell] {
        return grid.flatMap {
            $0.filter { $0.pairedWith.count != 0 }
        }
    }

    mutating func findTokenTypes() -> Set<String> {
        let filteredDots = grid.map {
            $0.map {
                $0.symbol.filter { $0 != "." }
            }
        }.flatMap { $0 }

        var uniqueSymbols: Set<String> = []
        filteredDots.forEach { String in
            if String != "" {
                uniqueSymbols.insert(String)
            }
        }

        return uniqueSymbols
    }

    func printGrid() {
        for row in grid {
            for cell in row {
                print(cell.symbol, terminator: " ")
            }
            print()
        }
    }
}
