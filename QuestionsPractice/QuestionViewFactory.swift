import Foundation
import SwiftUI

struct QuestionViewFactory {
    static func makeView(
        for question: any QuestionProtocol,
        selectedAnswer: Binding<String?>? = nil,
        selectedAnswers: Binding<Set<String>>? = nil,
        selectedPairs: Binding<[String: String]>? = nil,
        readingAnswers: Binding<[Int: String]>? = nil
    ) -> AnyView {
        switch question.questionType {
        case .singleChoice:
            return AnyView(
                SingleChoiceQuestionView(
                    question: question as! BaseQuestion,
                    selectedAnswer: selectedAnswer ?? .constant(nil)
                )
            )

        case .multipleChoice:
            return AnyView(
                MultipleChoiceQuestionView(
                    question: question as! BaseQuestion,
                    selectedAnswers: selectedAnswers ?? .constant([])
                )
            )

        case .trueFalse:
            return AnyView(
                TrueFalseQuestionView(
                    question: question as! BaseQuestion,
                    selectedAnswer: selectedAnswer ?? .constant(nil)
                )
            )

        case .fillInTheBlank:
            return AnyView(
                FillInTheBlankQuestionView(
                    question: question as! BaseQuestion,
                    selectedAnswer: selectedAnswer ?? .constant(nil)
                )
            )

        case .shortAnswer:
            return AnyView(
                ShortAnswerQuestionView(
                    question: question as! BaseQuestion,
                    userAnswer: selectedAnswer ?? .constant(nil)
                )
            )

        case .matching:
            return AnyView(
                MatchingQuestionView(
                    question: question as! MatchingQuestion,
                    selectedPairs: selectedPairs ?? .constant([:])
                )
            )

        case .reading:
            return AnyView(
                ReadingQuestionView(
                    question: question as! ReadingQuestion,
                    selectedAnswers: readingAnswers ?? .constant([:])
                )
            )

        }
    }
}
