//
//  ReadingQuestion.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation

/// 閱讀題組題型，一篇文章搭配多個子題

struct ReadingQuestion: QuestionProtocol, Codable {
    let id: UUID
    let subject: String
    let difficulty: Difficulty
    let questionType: QuestionType
    let passage: String
    let questions: [SubQuestion]
    let explanation : String
    let correct_answer: [String]?
    
    enum CodingKeys: String, CodingKey {
        case explanation,correct_answer
        case id
        case subject
        case difficulty
        case questionType = "question_type"
        case passage
        case questions
    }
}

struct SubQuestion: Codable {
    let question: String
    let options: [String: String]
}


struct MatchingQuestion: QuestionProtocol {
    let id: UUID
    let subject: String
    let difficulty: Difficulty
    let questionType: QuestionType  // 新增 question_type
    let questionText: String
    let pairs: [String: String]  // 配對題的左側項目與右側項目
    var correct_answer: [String]?
    let explanation: String

    enum CodingKeys: String, CodingKey {
        case id, subject, difficulty
        case questionType = "question_type"  // 從 JSON 中的 "question_type" 對應
        case questionText = "question"
        case pairs
        case correct_answer
        case explanation
    }
}



