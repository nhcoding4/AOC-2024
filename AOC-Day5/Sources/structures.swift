// ----------------------------------------------------------------------------------------------------------------

struct Condition {
    let before: Int
    let after: Int

    init(before: Int, after: Int) {
        self.before = before
        self.after = after
    }
}

// ----------------------------------------------------------------------------------------------------------------

struct Sequence {
    public var data: [Int]
    var conditions: [Condition]
    var status: Bool?

    init(data: [Int], conditions: [Condition]) {
        self.data = data
        self.conditions = conditions
        checkConditions()
    }

    // ----------------------------------------------------------------------------------------------------------------

    mutating func checkConditions() {
        for condition in conditions {
            let idx = data.firstIndex(of: condition.before)!

            for idx in 0..<idx {
                if data[idx] == condition.after {
                    status = false
                    return
                }
            }
        }
        status = true
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Part 2 Functions
    // ----------------------------------------------------------------------------------------------------------------

    mutating func fixData() {
        // Base case
        let relevantRules = findFailingRules()
        if relevantRules.count == 0 {
            return
        }

        for rule in relevantRules {
            let beforeIdx = data.firstIndex(of: rule.before)!
            let afterIdx = data.firstIndex(of: rule.after)!
            if beforeIdx < afterIdx {
                continue
            }

            let afterData = data[afterIdx]
            data.remove(at: afterIdx)

            if beforeIdx + 1 < data.count {
                data.insert(afterData, at: beforeIdx + 1)
            } else {
                data.append(afterData)
            }
        }

        fixData()
    }

    // ----------------------------------------------------------------------------------------------------------------

    mutating func findFailingRules() -> [Condition] {
        return conditions.filter {
            data.firstIndex(of: $0.after)! < data.firstIndex(of: $0.before)!
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
}
