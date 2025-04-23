import SwiftUI

// MARK: - 閱讀題組主畫面，使用 Int 作為子題 index
struct ReadingQuestionView: View {
    let question: ReadingQuestion
    @Binding var selectedAnswers: [Int: String] // 每個子題一個欄位

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("閱讀題組")
                    .font(.headline)

                Text(question.passage)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                ForEach(question.questions.indices, id: \.self) { index in
                    SubQuestionView(
                        subQuestion: question.questions[index],
                        selected: selectedAnswers[index] ?? "",
                        onSelect: { selected in
                            selectedAnswers[index] = selected
                        }
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - 子題畫面
struct SubQuestionView: View {
    let subQuestion: SubQuestion
    let selected: String
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(subQuestion.question)
                .font(.subheadline)

            ForEach(subQuestion.options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Button(action: {
                    onSelect(key)
                }) {
                    HStack {
                        Image(systemName: selected == key ? "largecircle.fill.circle" : "circle")
                        Text("\(key). \(value)")
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
    }
}
