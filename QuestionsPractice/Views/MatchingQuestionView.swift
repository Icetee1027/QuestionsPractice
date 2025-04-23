import SwiftUI

struct MatchingQuestionView: View {
    let question: MatchingQuestion
    @Binding var selectedPairs: [String: String]
    @State private var currentLeftSelection: String? = nil
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                // 問題文字
                Text(question.questionText)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 16)
                
                // 上方項目
                Text("選擇上方項目:")
                    .font(.headline)
                
                ForEach(question.pairs.keys.sorted(), id: \.self) { left in
                    // 檢查此項目是否已經配對
                    let isAlreadyPaired = selectedPairs[left] != nil
                    
                    OptionButton(
                        text: left,
                        isSelected: currentLeftSelection == left,
                        isPaired: isAlreadyPaired,
                        pairedWith: isAlreadyPaired ? selectedPairs[left] : nil,
                        action: {
                            // 如果已配對，點擊則取消配對
                            if isAlreadyPaired {
                                selectedPairs.removeValue(forKey: left)
                            } else {
                                // 否則設為當前選擇
                                currentLeftSelection = left
                            }
                        },
                        color: .blue
                    )
                }
                
                // 下方項目
                Text("選擇配對的下方項目:")
                    .font(.headline)
                    .padding(.top, 20)
                
                ForEach(question.pairs.values.sorted(), id: \.self) { right in
                    let pairedLeft = getPairedLeft(for: right)
                    
                    OptionButton(
                        text: right,
                        isPaired: pairedLeft != nil,
                        pairedWith: pairedLeft,
                        action: {
                            if let left = currentLeftSelection {
                                // 處理重新選擇的情況：如果此右側項目已經有配對，先移除舊配對
                                if let oldLeft = pairedLeft {
                                    selectedPairs.removeValue(forKey: oldLeft)
                                }
                                
                                // 如果當前選擇的左側項目已經有配對，也先移除
                                if selectedPairs[left] != nil {
                                    selectedPairs.removeValue(forKey: left)
                                }
                                
                                // 建立新配對
                                selectedPairs[left] = right
                                currentLeftSelection = nil
                            }
                        },
                        color: .green
                    )
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.2), value: selectedPairs)
            .animation(.easeInOut(duration: 0.2), value: currentLeftSelection)
        }
    }
    
    // 輔助函數 - 獲取與右側項目配對的左側項目
    private func getPairedLeft(for right: String) -> String? {
        return selectedPairs.first(where: { $0.value == right })?.key
    }
}

// 選項按鈕視圖
struct OptionButton: View {
    let text: String
    var isSelected: Bool = false
    var isPaired: Bool = false
    var pairedWith: String? = nil
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(text)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(color)
                    }
                }
                
                // 如果已配對，顯示配對信息
                if isPaired, let paired = pairedWith {
                    HStack {
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(color)
                        
                        Text("已配對: \(paired)")
                            .font(.caption)
                            .foregroundColor(color)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isPaired ? color : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // 根據狀態確定背景顏色
    private var backgroundColor: Color {
        if isSelected {
            return color.opacity(0.2)
        } else if isPaired {
            return color.opacity(0.1)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
}
