import UIKit
import SwiftUI

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        if hexSanitized.count == 6 {
            hexSanitized += "FF"
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = CGFloat((rgb >> 24) & 0xff) / 255.0
        let green = CGFloat((rgb >> 16) & 0xff) / 255.0
        let blue = CGFloat((rgb >> 8) & 0xff) / 255.0
        let alpha = CGFloat(rgb & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController: UIViewController, QuestionGameDelegate {
    @IBOutlet weak var flipsCount: UILabel!
    @IBOutlet var cards: [UIButton]!
    var waitingAlert: UIAlertController?
    var resultAlert: UIAlertController?

    
    let frontColor = UIColor(hex: "#E4EFE7")
    let backColor1 = UIColor(hex: "#7D9F6D") // 原 #99BC85 → 更沉穩的草綠
    let backColor2 = UIColor(hex: "#E6C6C1") // 原 #FADCD9 → 柔和豆沙粉
    let backColor3 = UIColor(hex: "#A89FCE") // 原 #D0BFFF → 銀紫、莫蘭迪紫調

    var game: QuestionGameController!
    var isFlipped: [Bool] = Array(repeating: false, count: 16)
    var isFlipAllCards: Bool = false

    
    func refreshQuestions() {
            reStartCards()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = QuestionGameController(delegate: self)
        cards = cards.sorted { $0.tag < $1.tag }
        for (index, button) in cards.enumerated() {
            button.tag = index
            setupCard(button: button, isFront: false, index: index)
        }
        
        view.backgroundColor = UIColor(hex: "#DDE1E4")
    }

    func reStartCards() {
        for (index, button) in cards.enumerated() {
            button.tag = index
            setupCard(button: button, isFront: false, index: index)
        }
       
        isFlipAllCards = false
    }

    func setupCard(button: UIButton, isFront: Bool, index: Int) {
        guard let card = game.chooseCard(at: index) else { return }
        let title = isFront ? card.cardTitle : ""

        let group: Int
        if index < 5 {
            group = 0
        } else if index < 9 {
            group = 1
        } else {
            group = 2
        }

        let color: UIColor = {
            if isFront {
                return frontColor
            } else {
                switch group {
                case 0: return backColor1
                case 1: return backColor2
                default: return backColor3
                }
            }
        }()

        let fontSize: CGFloat = 30
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize)
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = color
        button.alpha = 1.0
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        let index = sender.tag
        if game.touchCard(at: index) {
            flipCard(button: sender, isFront: game.chooseCard(at: index)!.isFaceUp, index: index)

        }
    }

    func flipCard(button: UIButton, isFront: Bool, index: Int) {
        guard let card = game.chooseCard(at: index) else { return }
        let cardTitle = isFront ? card.cardTitle : ""
        let group: Int
        if index < 5 {
            group = 0
        } else if index < 9 {
            group = 1
        } else {
            group = 2
        }

        let cardColor: UIColor = {
            if isFront {
                return frontColor
            } else {
                switch group {
                case 0: return backColor1
                case 1: return backColor2
                default: return backColor3
                }
            }
        }()


        let fontSize: CGFloat = 30
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize)
        ]
        let attributedTitle = NSAttributedString(string: cardTitle, attributes: attributes)

        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromRight, animations: {
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.backgroundColor = cardColor
        }, completion: nil)
    }

    @IBAction func resetButton(_ sender: Any) {
        game.restartGame()
    }

    @IBAction func filpAllCards(_ sender: Any) {
        game.flipAllCards()
        for index in cards.indices {
            flipCard(button: cards[index], isFront: true, index: index)
            cards[index].alpha = 1
        }
        if isFlipAllCards {
            game.restartGame()
            return
        } else {
            isFlipAllCards = true
        }
    }
    
    @IBAction func generateQuestionTapped(_ sender: UIButton) {
        // 使用選擇的卡片資料創建 QuestionInfo
        guard let selectedCardInfo = game.getSelectedCardInfo() else {
            print("請選擇正確的題目資訊")
            return
        }

        let questionInfo = QuestionInfo(subject: selectedCardInfo.subject,
                                         difficulty: selectedCardInfo.difficulty,
                                         question_type: selectedCardInfo.type)

        waitingAlert = UIAlertController(title: "請稍候", message: "正在生成題目，請稍候...", preferredStyle: .alert)
                self.present(waitingAlert!, animated: true, completion: nil)
                
                // 假設 API 請求
                QuestionAPI.shared.generateQuestion(info: questionInfo) { [weak self] result in
                    DispatchQueue.main.async {
                        // 2. 當接收到回應後，先關閉等待提示框
                        self?.waitingAlert?.dismiss(animated: true, completion: {
                            // 3. 顯示成功或失敗的提示框
                            switch result {
                            case .success(let question):
                                self?.navigateToNextPage(with: question)
                            case .failure(let error):
                                self?.resultAlert = UIAlertController(title: "錯誤", message: "發生錯誤：\(error.localizedDescription)", preferredStyle: .alert)
                                if let resultAlert = self?.resultAlert {
                                    self?.present(resultAlert, animated: true, completion: nil)
                                    
                                    // 4. 設定 1 秒後自動消失
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        resultAlert.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                            
                            
                        })
                    }
                }
    }


    func navigateToNextPage(with question: any QuestionProtocol) {
        //print("Navigating to next page with question: \(question)")
        let questionControlView = QuestionControlView(question: question)
        let hostingController = UIHostingController(rootView: questionControlView)
        navigationController?.pushViewController(hostingController, animated: true)
    }


}
