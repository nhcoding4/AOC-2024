import Foundation

// ----------------------------------------------------------------------------------------------------------------

func main() {
    let dataPath = "./Sources/data.txt"
    let rawData = loadFile(path: dataPath)
    if rawData == nil {
        return
    }

    let lexer = Lexer(input: rawData!)

    var total: Double = 0
    for number in lexer.tokens {
        total += number.eval()
    }

    print(total)
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
