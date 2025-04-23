//
//  TrueFalseQuestionView.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation
import SwiftUI

struct TrueFalseQuestionView: View {
    let question: BaseQuestion
    @Binding var selectedAnswer: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(question.questionText)
                    .font(.title3)
                    .bold()
                
                
                ForEach(["T": "正確", "F": "錯誤"].sorted(by: { $0.key < $1.key }), id: \.key) { key, label in
                    
                    Button(action: {
                        selectedAnswer = key
                    }) {
                        HStack {
                            Image(systemName: selectedAnswer == key ? "largecircle.fill.circle" : "circle")
                            Text(label)
                        }
                        .foregroundColor(.primary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
        
    }
}
