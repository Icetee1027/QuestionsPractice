//
//  Question.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation

/// 題目協議，所有題型都必須實作這些基本欄位
protocol QuestionProtocol: Identifiable, Codable {
    var id: UUID { get }              // 題目唯一識別碼
    var subject: String { get }       // 所屬科目
    var difficulty: Difficulty { get } // 難度等級
    var questionType: QuestionType { get } // 題型
    var explanation : String {get}
    var correct_answer : [String]? {get}
}

struct BaseQuestion: QuestionProtocol {
    let id: UUID
    let subject: String
    let difficulty: Difficulty
    let questionType: QuestionType
    let questionText: String
    let options: [String: String]?      // null 也能接
    let correct_answer: [String]?       // null 也能接
    let explanation : String
    
    enum CodingKeys: String, CodingKey {
        case id, subject, difficulty,explanation
        case questionType = "question_type"
        case questionText = "question"
        case options
        case correct_answer
    }
}

