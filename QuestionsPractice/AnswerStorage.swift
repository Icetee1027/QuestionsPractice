//
//  AnswerStorage.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation

struct UserAnswer: Codable, Identifiable {
    let id: UUID
    let questionID: UUID
    let questionType: QuestionType
    let subject: String
    let difficulty: Difficulty
    let questionContent: String
    let userAnswer: [String]
    let isCorrect: Bool
    let aiFeedback: String?
}

class AnswerStorage: ObservableObject {
    @Published var answers: [UserAnswer] = []

    func saveAnswer(_ answer: UserAnswer) {
        answers.append(answer)
    }
}

