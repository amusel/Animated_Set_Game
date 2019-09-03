//
//  ViewController.swift
//  Animated_Set_Game
//
//  Created by Artem Musel on 8/30/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = SetGame()
    
    @IBOutlet weak var cardsDeckView: CardsDeckView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBOutlet weak var setsLabel: UILabel!
    
//    private lazy var animator = UIDynamicAnimator(referenceView: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.dealCards(amount: 12) // starting amount of cards
        updateCardsView()
    }
    
    func updateCardsView() {
        //add buttons if needed
        let buttonsDifference = game.cardsInGame.count - cardsDeckView.buttons.count
        if buttonsDifference > 0 {
            cardsDeckView.addCardsButtons(amount: buttonsDifference)
            for button in cardsDeckView.buttons {
                button.addTarget(self, action: #selector(selectCard(_:)), for: .touchUpInside)
            }
        }
        
        for index in 0..<game.cardsInGame.count {
            configureCardButtonAppearence(forButtonIndex: index)
        }
        
        if buttonsDifference > 0 {
            let startIndex = cardsDeckView.buttons.count - buttonsDifference
            animateDealing(forCardIndexes: Array(startIndex..<cardsDeckView.buttons.count))
        }
        
        if game.matchedCards.count == 3 {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.4,
                delay: 0,
                options: [],
                animations: {
                    for matchedCardIndex in self.game.matchedCards {
                        self.cardsDeckView.buttons[matchedCardIndex].alpha = 0
                    }
                    return
            },
                completion: { _ in
                    let matchedCards = self.game.matchedCards

                    if self.game.dealCards() {
                        matchedCards.forEach() {
                            self.configureCardButtonAppearence(forButtonIndex: $0)
                            self.cardsDeckView.buttons[$0].isBack = true
                        }
                        self.animateDealing(forCardIndexes: matchedCards)
                    }
                    else {
                        self.cardsDeckView.removeCardButtons(withIndexes: matchedCards)
                    }
                    self.updateCardsView()
            })
        }
        
        updateUIElements()
    }
    
    private func configureCardButtonAppearence(forButtonIndex index: Int) {
        let card = game.cardsInGame[index]
        let button = cardsDeckView.buttons[index]
        
        //set correct background color
        if game.selectedCards.contains(index) {
            if game.selectedCards.count == 3 {
                button.layer.backgroundColor = CardBackgroundColors.wrongMatch.get()
            }
            else {
                button.layer.backgroundColor = CardBackgroundColors.selected.get()
            }
        }
        else if game.matchedCards.contains(index) {
            button.layer.backgroundColor = CardBackgroundColors.correctMatch.get()
        }
        else {
            button.layer.backgroundColor = CardBackgroundColors.standard.get()
        }
        
        //setting cardButton`s symbol properties
        switch card.shape {
        case .squiggle:
            button.symbolShape = .squiggle
        case .diamond:
            button.symbolShape = .diamond
        case .oval:
            button.symbolShape = .oval
        }
        
        switch card.shading {
        case .solid:
            button.symbolShading = .solid
        case .striped:
            button.symbolShading = .striped
        case .outlined:
            button.symbolShading = .outlined
        }
        
        switch card.color {
        case .green:
            button.symbolColor = .green
        case .red:
            button.symbolColor = .red
        case .purple:
            button.symbolColor = .purple
        }
        
        button.symbolAmount = card.amount.rawValue
    }
    
    private func updateUIElements() {
        scoreLabel.text = "Score: \(game.score)"
        setsLabel.text = "\(game.sets)  " + (game.sets == 1 ? "Set" : "Sets")
        
        //update dealMoreButton status
        if game.cardsLeftInDeck == 0 {
            dealMoreButton.isEnabled = false
            dealMoreButton.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        }
        else {
            dealMoreButton.isEnabled = true
            dealMoreButton.setTitleColor(#colorLiteral(red: 1, green: 0.5745739937, blue: 0.001978197834, alpha: 1), for: .normal)
        }
    }
    
    private func animateDealing(forCardIndexes cardIndexes: [Int]) {
        for (index, cardIndex) in cardIndexes.enumerated() {
            let currentCardButton = cardsDeckView.buttons[cardIndex]
            
            //set starting position
            currentCardButton.frame = dealMoreButton.superview!.convert(dealMoreButton.frame, to: view)
            currentCardButton.frame = currentCardButton.frame.offsetBy(dx: -dealMoreButton.frame.width/2, dy: -dealMoreButton.frame.height/2)
            currentCardButton.frame.size.width = dealMoreButton.frame.width*1.5
            currentCardButton.frame.size.height = currentCardButton.frame.size.width * (8/5)
            
            currentCardButton.alpha = 1
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0 + 0.3*Double(index),
                options: [],
                animations:
                {
                    if let frame = self.cardsDeckView.grid[cardIndex] {
                        currentCardButton.frame = frame
                    }
            },
                completion: {_ in
                    UIView.transition(with: currentCardButton,
                                      duration: 0.3,
                                      options: [.transitionFlipFromLeft],
                                      animations: {currentCardButton.isBack = false})
                    
            })
        }
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        game.dealCards()
        updateCardsView()
    }
    
    @IBAction func dealCardsWithGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            game.dealCards()
            updateCardsView()
        }
    }
    
    @objc func selectCard(_ sender: CardButton) {
        if let index = cardsDeckView.buttons.firstIndex(of: sender), index < game.cardsInGame.count {
            game.selectCard(withIndex: index)
        }
        updateCardsView()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        game.dealCards(amount: 12)
        updateCardsView()
    }
}

enum CardBackgroundColors {
    case correctMatch
    case wrongMatch
    case selected
    case standard
    
    func get() -> CGColor {
        switch self {
        case .correctMatch:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .wrongMatch:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .selected:
            return #colorLiteral(red: 1, green: 0.5745739937, blue: 0.001978197834, alpha: 1)
        case .standard:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
