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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.dealCards(amount: 12) // starting amount of cards
        updateCardsView()
    }
    
    func updateCardsView() {
        //manage the amount of buttons to be equal to cards in game amount
        let buttonsDifference = game.cardsInGame.count - cardsDeckView.buttons.count
        if buttonsDifference > 0 {
            cardsDeckView.addCardsButtons(amount: buttonsDifference)
            for button in cardsDeckView.buttons {
                button.addTarget(self, action: #selector(selectCard(_:)), for: .touchUpInside)
            }
        }
        else if buttonsDifference < 0{
            cardsDeckView.removeCardButtons(amount: -buttonsDifference)
        }
        
        for index in 0..<game.cardsInGame.count {
            let currentCard = game.cardsInGame[index]
            let currentCardButton = cardsDeckView.buttons[index]
            
            //set correct background color
            if game.selectedCards.contains(currentCard) {
                if game.selectedCards.count == 3 {
                    currentCardButton.layer.backgroundColor = CardBackgroundColors.wrongMatch.get()
                }
                else {
                    currentCardButton.layer.backgroundColor = CardBackgroundColors.selected.get()
                }
            }
            else if game.matchedCards.contains(currentCard) {
                currentCardButton.layer.backgroundColor = CardBackgroundColors.correctMatch.get()
            }
            else {
                currentCardButton.layer.backgroundColor = CardBackgroundColors.standard.get()
            }
            
            //setting cardButton`s symbol properties
            switch currentCard.shape {
            case .squiggle:
                currentCardButton.symbolShape = .squiggle
            case .diamond:
                currentCardButton.symbolShape = .diamond
            case .oval:
                currentCardButton.symbolShape = .oval
            }
            
            switch currentCard.shading {
            case .solid:
                currentCardButton.symbolShading = .solid
            case .striped:
                currentCardButton.symbolShading = .striped
            case .outlined:
                currentCardButton.symbolShading = .outlined
            }
            
            switch currentCard.color {
            case .green:
                currentCardButton.symbolColor = .green
            case .red:
                currentCardButton.symbolColor = .red
            case .purple:
                currentCardButton.symbolColor = .purple
            }
            
            currentCardButton.symbolAmount = currentCard.amount.rawValue
            
        }
        
        scoreLabel.text = "Score: \(game.score)"
        
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
    
    @IBOutlet weak var dealMoreButton: UIButton!
    @IBAction func dealMore(_ sender: UIButton) {
        game.dealCards()
        updateCardsView()
    }
    
    @IBAction func dealCards(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            game.dealCards()
            updateCardsView()
        }
    }
    
    @IBAction func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            game.cardsInGame.shuffle()
            updateCardsView()
        }
    }
    
    @objc func selectCard(_ sender: CardButton) {
        if let index = cardsDeckView.buttons.firstIndex(of: sender), index < game.cardsInGame.count {
            game.selectCard(withIndex: index)
            
            // deal cards if there are matched cards
            if game.matchedCards.count == 3 && game.selectedCards.count > 0 {
                game.dealCards()
            }
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
