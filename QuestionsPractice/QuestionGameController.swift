import Foundation
import UIKit

protocol QuestionGameDelegate: AnyObject {
    func refreshQuestions()
}

class QuestionGameController {
    weak var delegate: QuestionGameDelegate?
    var questionCards: [Card] = []
    var subjects: [String] = ["國文", "英文", "數學", "自然", "社會"]
    var difficulties: [String] = ["簡單", "普通", "困難", "極難"]
    var questionTypes: [String] = ["單選題", "多選題", "填空題", "配對題", "簡答題", "閱讀題", "是非題"]

    init(delegate: QuestionGameDelegate) {
        self.delegate = delegate
        setupInitialCards()
    }

    private func setupInitialCards() {
        let selectedSubjects = Array(subjects.shuffled().prefix(5))
        let selectedDifficulties = Array(difficulties.shuffled().prefix(4))
        let selectedTypes = Array(questionTypes.shuffled().prefix(7))
        
        let cards = selectedSubjects + selectedDifficulties + selectedTypes
        questionCards = cards.map { Card(title: $0) }
    }

    func flipAllCards() {
        for index in questionCards.indices {
            questionCards[index].isFaceUp = true
            questionCards[index].isMatched = true
        }
    }

    func flipCard(at index: Int) -> Bool {
        guard index < questionCards.count else { return false }

        if index == indexOfOneAndOnlyFaceUpCard {
            questionCards[index].isFaceUp = false
            return true
        }

        if questionCards[index].isFaceUp {
            questionCards[index].isFaceUp = false
            return true
        }

        questionCards[index].isFaceUp = true
        return true
    }
    func touchCard(at index: Int) -> Bool {
        guard index >= 0 && index < questionCards.count else { return false }
        if questionCards[index].isFaceUp == true{
            questionCards[index].isFaceUp = false
            return true
        }
        
        let groupRange: Range<Int>
        switch index {
        case 0...4:
            groupRange = 0..<5
        case 5...8:
            groupRange = 5..<9
        case 9...15:
            groupRange = 9..<16
        default:
            return false
        }

        for i in groupRange {
            if i != index && questionCards[i].isFaceUp {
                return false
            }
        }

        questionCards[index].isFaceUp = true
        return true
    }

    func restartCard(at index: Int) {
        guard index >= 0 && index < questionCards.count else { return }

        let currentTitle = questionCards[index].cardTitle
        var newTitle: String

        if index < 5 {
            repeat {
                newTitle = subjects.randomElement()!
            } while newTitle == currentTitle
        } else if index < 9 {
            repeat {
                newTitle = difficulties.randomElement()!
            } while newTitle == currentTitle
        } else {
            repeat {
                newTitle = questionTypes.randomElement()!
            } while newTitle == currentTitle
        }

        questionCards[index].cardTitle = newTitle
        questionCards[index].isFaceUp = true
        questionCards[index].isMatched = false
    }

    func chooseCard(at index: Int) -> Card? {
        guard index >= 0 && index < questionCards.count else {
            print("Index out of bounds")
            return nil
        }
        return questionCards[index]
    }

    func restartGame() {
        setupInitialCards()
        for index in questionCards.indices {
            questionCards[index].isFaceUp = false
            questionCards[index].isMatched = false
        }
        delegate?.refreshQuestions()
    }

    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in questionCards.indices where questionCards[index].isFaceUp && !questionCards[index].isMatched {
                if foundIndex == nil {
                    foundIndex = index
                } else {
                    return nil
                }
            }
            return foundIndex
        }
        set {
            for i in questionCards.indices where !questionCards[i].isMatched {
                questionCards[i].isFaceUp = (i == newValue)
            }
        }
    }
    func getSelectedCardInfo() -> (subject: String, difficulty: String, type: String)? {
        let subjectCards = questionCards.prefix(5).filter { $0.isFaceUp }
        let difficultyCards = questionCards[5..<9].filter { $0.isFaceUp }
        let typeCards = questionCards.suffix(from: 9).filter { $0.isFaceUp }

        guard subjectCards.count == 1,
              difficultyCards.count == 1,
              typeCards.count == 1,
              let subject = subjectCards.first?.cardTitle,
              let difficulty = difficultyCards.first?.cardTitle,
              let rawType = typeCards.first?.cardTitle else {
            return nil
        }

        let type = (rawType == "閱讀題") ? "閱讀題組" : rawType

        return (subject, difficulty, type)
    }


}


