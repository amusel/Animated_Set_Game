//
//  SetGame.swift
//  Task-2. Set Game
//
//  Created by Artem Musel on 8/19/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import Foundation

struct SetGame {
    private var deck = [SetCard]()
    var cardsInGame = [SetCard]()
    var selectedCards = [Int]()
    var matchedCards = [Int]()
    
    private(set) var score = 0
    private(set) var sets = 0
    var cardsLeftInDeck: Int { return deck.count }
    
    init()
    {
        // create deck of 81 cards
        for amount in Amount.allCases {
            for color in Colors.allCases {
                for shape in Shapes.allCases {
                    for shading in Shading.allCases {
                        deck.append(SetCard(amount: amount, color: color, shape: shape, shading: shading))
                    }
                }
            }
        }
        deck.shuffle()
        deck.removeLast(60)
    }
    
    @discardableResult mutating func dealCards(amount: Int = 3) -> Bool {
        if deck.count < 3 {
            matchedCards.forEach { cardIndex in
                cardsInGame.remove(at: cardIndex)
            }
            matchedCards.removeAll()
            return false
        }
        
        //replace matched cards
        if matchedCards.count == 3 {
            matchedCards.forEach { cardIndex in
                cardsInGame[cardIndex] = deck.removeFirst()
            }
            matchedCards.removeAll()
        }
        //or append new
        else {
            cardsInGame += Array(deck.prefix(upTo: amount))
            deck.removeFirst(amount)
        }
        
        return true
    }
    
    mutating func selectCard(withIndex index: Int) {
        let selectedCard = index
        //igonore selection of matched card
        if matchedCards.contains(selectedCard) {
            return
        }
        
        //deselect
        if selectedCards.contains(selectedCard) {
            selectedCards = selectedCards.filter { $0 != selectedCard}
        }
        //select
        else {
            selectedCards.append(selectedCard)
        }
        
        if selectedCards.count == 3 {
            if matchSelected() {
                matchedCards = selectedCards.sorted(by: {$0>$1})
                selectedCards.removeAll()
                score += 2
                sets += 1
            }
            else {
                score -= 3
            }
        }
        
        //remove selection from wrong selected cards
        if selectedCards.count > 3 {
            selectedCards.removeFirst(3)
        }
        
    }
    
    func matchSelected() -> Bool {
        return true
        let first = cardsInGame[selectedCards[0]]
        let second = cardsInGame[selectedCards[1]]
        let third = cardsInGame[selectedCards[2]]
        
        let amountFeatures = Set([first.amount, second.amount, third.amount])
        let colorsFeatures = Set([first.color, second.color, third.color])
        let shapesFeatures = Set([first.shape, second.shape, third.shape])
        let shadingsFeatures = Set([first.shading, second.shading, third.shading])
        
        //every feature must be equal or different for all three cards
        return (amountFeatures.count == 1 || amountFeatures.count == 3) &&
            (colorsFeatures.count == 1 || colorsFeatures.count == 3) &&
            (shapesFeatures.count == 1 || shapesFeatures.count == 3) &&
            (shadingsFeatures.count == 1 || shadingsFeatures.count == 3)
    }
}
