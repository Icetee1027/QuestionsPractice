//
//  UIHostingViewController.swift
//  cardcame
//
//  Created by MyMac on 2025/4/22.
//

import Foundation
import UIKit
import SwiftUI

class UIHostingViewController: UIViewController {
    var question: (any QuestionProtocol)?  // ✅ 改成真正的題目協議型別

    override func viewDidLoad() {
        super.viewDidLoad()

        // 這裡取得傳遞來的題目資料
        guard let question = question else { return }

        // 建立 SwiftUI 視圖並傳遞資料
        let questionControlView = QuestionControlView(question: question)
        let hostingController = UIHostingController(rootView: questionControlView)

        // 將 SwiftUI 視圖嵌入到當前視圖控制器中
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
