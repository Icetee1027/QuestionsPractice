import SwiftUI

struct MultipleChoiceQuestionView: View {
    let question: BaseQuestion
    @Binding var selectedAnswers: Set<String>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(question.questionText)
                    .font(.title3)
                    .bold()
                
                // 解開 options，如果是 nil 則不顯示選項
                if let options = question.options {
                    ForEach(options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Button(action: {
                            // 當用戶選擇或取消選擇選項時更新 selectedAnswers
                            if selectedAnswers.contains(key) {
                                selectedAnswers.remove(key)
                            } else {
                                selectedAnswers.insert(key)
                            }
                        }) {
                            HStack {
                                // 根據選擇的狀態更新方框的顯示
                                Image(systemName: selectedAnswers.contains(key) ? "checkmark.square" : "square")
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
