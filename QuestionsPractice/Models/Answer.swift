//
//  Answer.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation

/// 儲存使用者作答記錄與結果，支援後續分析與學習回饋
struct Answer: Codable, Identifiable {
    let id: UUID                      // 答案唯一識別碼
    let questionID: UUID             // 對應的題目 ID
    let questionType: QuestionType   // 題型
    let subject: String              // 科目
    let difficulty: Difficulty       // 難度
    let questionContent: String      // 題目原始文字
    let userAnswer: [String]         // 使用者作答
    let isCorrect: Bool              // 是否正確
    let aiFeedback: String?          // 若錯誤，AI 提供的參考修正建議
}

