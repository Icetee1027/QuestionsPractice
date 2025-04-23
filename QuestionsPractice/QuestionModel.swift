//
//  QuestionModel.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//
import Foundation

import Foundation

enum QuestionType: String, Codable {
    case singleChoice = "單選題"
    case multipleChoice = "多選題"
    case trueFalse = "是非題"
    case fillInTheBlank = "填空題"
    case shortAnswer = "簡答題"
    case matching = "配對題"
    case reading = "閱讀題組"
}

enum Difficulty: String, Codable {
    case easy = "簡單"
    case medium = "普通"
    case hard = "困難"
    case veryhard = "極難"
}


