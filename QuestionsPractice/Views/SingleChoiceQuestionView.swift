import SwiftUI

struct SingleChoiceQuestionView: View {
    let question: BaseQuestion
    @Binding var selectedAnswer: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(question.questionText)
                    .font(.title3)
                    .bold()
                
                // 使用 if let 解開 options
                if let options = question.options {
                    // 將解開的 options 排序
                    ForEach(options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Button(action: {
                            selectedAnswer = key
                        }) {
                            HStack {
                                Image(systemName: selectedAnswer == key ? "largecircle.fill.circle" : "circle")
                                Text("\(key). \(value)")
                            }
                            .foregroundColor(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    Text("沒有選項")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
}
