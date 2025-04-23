import SwiftUI

struct QuestionControlView: View {
    let question: any QuestionProtocol

    @State private var selectedAnswer: String? = nil
    @State private var selectedAnswers: Set<String> = []
    @State private var selectedPairs: [String: String] = [:]
    @State private var readingAnswers: [Int: String] = [:]

    @State private var isAnswered = false
    @State private var isCorrect = false
    @State private var correctAnswer: String? = nil
    @State private var explanation: String? = nil
    @State private var showExplanation = false
    @State private var showExplanationSheet = false
    @State private var userJudgedCorrectly: Bool? = nil // 用來追蹤用戶是否判斷正確


    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("科目：\(question.subject)")
            Text("難度：\(question.difficulty.rawValue)")
            Text("題型：\(question.questionType.rawValue)")
                .font(.headline)

            QuestionViewFactory.makeView(
                for: question,
                selectedAnswer: $selectedAnswer,
                selectedAnswers: $selectedAnswers,
                selectedPairs: $selectedPairs,
                readingAnswers: $readingAnswers
            )

            Button(action: handleSubmit) {
                Text("提交答案")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 16)

            if isAnswered {
                Divider().padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    if [.fillInTheBlank, .shortAnswer].contains(question.questionType) {
                                Text("請自行判斷是否作答正確")
                                    .foregroundColor(.orange)

                                HStack {
                                    // 正確的選擇按鈕
                                    Button(action: {
                                        // 每次點擊時重新設定 userJudgedCorrectly 的值
                                        userJudgedCorrectly = true
                                        isCorrect = true
                                    }) {
                                        Text("✅ 我答對了")
                                            .padding()
                                            .background(userJudgedCorrectly == true ? Color.green : Color.green.opacity(0.5))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }

                                    // 錯誤的選擇按鈕
                                    Button(action: {
                                        // 每次點擊時重新設定 userJudgedCorrectly 的值
                                        userJudgedCorrectly = false
                                        isCorrect = false
                                    }) {
                                        Text("❌ 我答錯了")
                                            .padding()
                                            .background(userJudgedCorrectly == false ? Color.red : Color.red.opacity(0.5))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                    else{
                        Text(isCorrect ? "✅ 答對了！" : "❌ 答錯了")
                            .font(.title3)
                            .foregroundColor(isCorrect ? .green : .red)
                    }

                   

                    if let correctAnswer = correctAnswer, !correctAnswer.isEmpty {
                        Text("正確答案：\n\(correctAnswer)")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    Button(action: {
                        showExplanationSheet = true
                    }) {
                        HStack {
                            Text("顯示詳解")
                            Image(systemName: "doc.text.magnifyingglass")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showExplanationSheet) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("詳解")
                                .font(.title2)
                                .bold()

                            ScrollView {
                                Text(explanation ?? "無詳解")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                            }

                            Button("關閉") {
                                showExplanationSheet = false
                            }
                            .padding(.top)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.blue)

                        }
                        .padding()
                        .presentationDetents([.medium, .large]) // iOS 16+ 可調高度
                    }


                   
                }
            }

            
        }
        .padding()
    }

    private var shouldJudgeAutomatically: Bool {
        switch question.questionType {
        case .singleChoice, .multipleChoice, .trueFalse, .matching, .reading:
            return true
        case .fillInTheBlank, .shortAnswer:
            return false
        }
    }

    private var userComposedAnswer: String? {
        switch question.questionType {
        case .fillInTheBlank, .shortAnswer:
            return selectedAnswer
        default:
            return nil
        }
    }

    private func handleSubmit() {
        isAnswered = true

        switch question.questionType {
        case .singleChoice, .trueFalse:
            // 單選題和是非題的正確答案是陣列的第一個元素
            if let userAnswer = selectedAnswer,
               let correctAnswer = question.correct_answer?.first {
                isCorrect = userAnswer == correctAnswer
                self.correctAnswer = correctAnswer
            }

        case .multipleChoice:
            // 多選題正確答案是陣列，使用 Set 來比較順序無關的選項
            if let correctAnswers = question.correct_answer {
                isCorrect = Set(selectedAnswers) == Set(correctAnswers)
                self.correctAnswer = correctAnswers.sorted().joined(separator: ", ")
            }

        case .matching:
            // 配對題假設正確答案是兩個陣列（左邊三個，右邊三個）
            if let correctAnswers = question.correct_answer, correctAnswers.count % 2 == 0 {
                let half = correctAnswers.count / 2
                let leftAnswers = Array(correctAnswers.prefix(half))
                let rightAnswers = Array(correctAnswers.suffix(half))
                
                // Debug: print the left and right answer arrays
                print("Left Answers: \(leftAnswers)")
                print("Right Answers: \(rightAnswers)")
                
                // Create correct answers dictionary
                let correctDict = Dictionary(uniqueKeysWithValues: zip(leftAnswers, rightAnswers))
                
                // Debug: print the correct dictionary
                print("Correct Dictionary: \(correctDict)")
                
                // Convert dictionary elements to sorted arrays of tuples
                let sortedCorrectPairs = correctDict.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
                let sortedSelectedPairs = selectedPairs.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
                
                // Debug: print the sorted correct pairs and selected pairs
                print("Sorted Correct Pairs: \(sortedCorrectPairs)")
                print("Sorted Selected Pairs: \(sortedSelectedPairs)")
                
                // Manually compare the sorted arrays
                isCorrect = sortedCorrectPairs.count == sortedSelectedPairs.count &&
                    zip(sortedCorrectPairs, sortedSelectedPairs).allSatisfy { pair in
                        pair.0.0 == pair.1.0 && pair.0.1 == pair.1.1
                    }
                
                // Debug: print the result of the comparison
                print("Is Correct: \(isCorrect)")
                
                // Format correct answer as A → 1, B → 2 ...
                let pairedAnswerText = zip(leftAnswers, rightAnswers)
                    .map { "\($0) → \($1)" }
                    .joined(separator: ", ")
                
                // Debug: print the paired answer text
                print("Paired Answer Text: \(pairedAnswerText)")
                
                self.correctAnswer = pairedAnswerText
            }






        case .reading:
            if let correctAnswers = question.correct_answer {
                // 假設 readingAnswers 是 [Int: String]，key 是題號（從 0 開始）
                let userAnswers = (0..<correctAnswers.count).compactMap { readingAnswers[$0] }

                isCorrect = userAnswers == correctAnswers
                self.correctAnswer = correctAnswers.enumerated().map { "第\($0.offset + 1)題：\($0.element)" }.joined(separator: "\n")
            }


        case .fillInTheBlank, .shortAnswer:
            // 填空題和簡答題讓使用者自行判斷正確與否
            if let correctAnswers = question.correct_answer {
                self.correctAnswer = correctAnswers.joined(separator: "\n")
            }


        }

        // 顯示詳解
        explanation = question.explanation
    }

}
