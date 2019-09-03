//
//  CardsDeckView.swift
//  Task-3. Graphical Set Game
//
//  Created by Artem Musel on 8/24/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import UIKit

class CardsDeckView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    private(set) var buttons = [CardButton]()
    private(set) lazy var grid = Grid(layout: .aspectRatio(5/8))
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        
        for (i, button) in buttons.enumerated() {
            if let frame = grid[i] {
                button.layer.cornerRadius = 10
                button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                button.layer.borderWidth = 1
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.2,
                    delay: 0,
                    options: [],
                    animations: {button.frame = frame})
            }
        }
    }
    
    func addCardsButtons(amount: Int = 3){
        for _ in 0..<amount {
            let newCardButton = CardButton()
            newCardButton.alpha = 0
            buttons.append(newCardButton)
            addSubview(newCardButton)
        }
        
        grid.cellCount += amount
        setNeedsLayout()
    }
    
    func removeCardButtons(withIndexes indexes: [Int]) {
        for index in indexes {
            buttons.remove(at: index)
        }

        grid.cellCount = buttons.count
        setNeedsLayout()
    }
    
}
