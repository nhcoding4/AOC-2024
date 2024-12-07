enum Direction {
    case up
    case down
    case left
    case right

    func directionData() -> Vector2 {
        switch self {
        case .up:
            return Vector2(x: 0, y: -1)
        case .down:
            return Vector2(x: 0, y: 1)
        case .left:
            return Vector2(x: -1, y: 0)
        case .right:
            return Vector2(x: 1, y: 0)
        }
    }
}

struct Vector2 {
    let x: Int
    let y: Int
    var direction: Direction = Direction.up

    func add(other: Vector2) -> Vector2 {
        return Vector2(x: x + other.x, y: y + other.y)
    }

    mutating func rotate() {
        switch direction {
        case .up:
            direction = Direction.right
        case .right:
            direction = Direction.down
        case .down:
            direction = Direction.left
        case .left:
            direction = Direction.up
        }
    }
}

struct Solver {
    let mapData: [[String]]

    mutating func findStart() -> Vector2? {
        for (y, row) in mapData.enumerated() {
            for (x, cell) in row.enumerated() {
                if cell == "^" {
                    return Vector2(x: x, y: y)
                }
            }
        }

        return nil
    }

    mutating func solve() -> [Vector2]? {
        var position = findStart()
        if position == nil {
            print("Unable to find start")
            return nil
        }

        var moves: [Vector2] = []

        while isValidMove(position: position!) {
            moves.append(position!)

            if let peekToken = getNextToken(position: position!) {
                if peekToken == "#" {
                    position?.rotate()
                } else {
                    var newPos = position!.add(other: position!.direction.directionData())
                    newPos.direction = position!.direction
                    position = newPos
                }
            } else {
                break
            }
        }

        return moves
    }

    mutating func getNextToken(position: Vector2) -> String? {
        let nextPosition = position.add(other: position.direction.directionData())
        if (nextPosition.x >= 0 && nextPosition.x < mapData[0].count)
            && (nextPosition.y >= 0
                && nextPosition.y < mapData.count)
        {
            return mapData[nextPosition.y][nextPosition.x]
        }

        return nil
    }

    func isValidMove(position: Vector2) -> Bool {
        let nextPosition = position.add(other: position.direction.directionData())

        return (nextPosition.x >= 0 && nextPosition.x < mapData[0].count)
            && (nextPosition.y >= 0 && nextPosition.y <= mapData.count)
    }
}