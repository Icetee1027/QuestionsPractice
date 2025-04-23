//
//  Card.swift
//  cardcame
//
//  Created by MyMac on 2025/3/18.
//

import Foundation
struct Card{
    var isFaceUp = false
    var isMatched = false
    var cardTitle:String
    init(title: String){
        cardTitle = title
    }
}
