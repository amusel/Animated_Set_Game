//
//  SetCard.swift
//  Task-2. Set Game
//
//  Created by Artem Musel on 8/19/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import Foundation

struct SetCard: Equatable {
    let amount: Amount
    let color: Colors
    let shape: Shapes
    let shading: Shading
}

enum Amount: Int, CaseIterable {
    case one = 1, two, three
}

enum Colors: CaseIterable {
    case green, red, purple
}

enum Shapes:  CaseIterable {
    case squiggle, diamond, oval
}

enum Shading:  CaseIterable {
    case solid, striped, outlined
}
