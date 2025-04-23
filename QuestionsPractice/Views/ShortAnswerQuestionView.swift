//
//  ShortAnswerQuestionView.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation
import SwiftUI

struct ShortAnswerQuestionView: View {
    let question: BaseQuestion
    @Binding var userAnswer: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(question.questionText)
                    .font(.title3)
                    .bold()
                
                TextEditor(text: Binding(
                    get: { userAnswer ?? "" },
                    set: { userAnswer = $0.isEmpty ? nil : $0 }
                ))
                .frame(height: 150)
                .border(Color.gray.opacity(0.5), width: 1)
                .cornerRadius(8)
                .padding(.vertical, 4)
            }
            .padding()
        }
    }
}

