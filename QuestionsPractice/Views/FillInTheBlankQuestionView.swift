//
//  FillInTheBlankQuestionView.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation
import SwiftUI

struct FillInTheBlankQuestionView: View {
    let question: BaseQuestion
    @Binding var selectedAnswer: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(question.questionText)
                    .font(.title3)
                    .bold()
                
                // 顯示填空題的文本框
                TextField("請填入答案", text: $selectedAnswer.bound)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
            }
            .padding()
        }
    }
}

extension Binding where Value == String? {
    var bound: Binding<String> {
        Binding<String>(
            get: {
                self.wrappedValue ?? ""
            },
            set: {
                self.wrappedValue = $0.isEmpty ? nil : $0
            }
        )
    }
}
