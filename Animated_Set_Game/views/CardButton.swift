//
//  CardButton.swift
//  Task-3. Graphical Set Game
//
//  Created by Artem Musel on 8/24/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    
    enum SymbolShape {
        case squiggle, diamond, oval
    }
    
    enum SymbolColor {
        case green, red, purple
        
        func get() -> UIColor {
            switch self {
            case .red:
                return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            case .green:
                return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            case .purple:
                return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    
    enum SymbolShading {
        case solid, striped, outlined
    }
    
    var symbolAmount = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var symbolShape = SymbolShape.oval {
        didSet {
            setNeedsDisplay()
        }
    }
    var symbolColor = SymbolColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    var symbolShading = SymbolShading.solid {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let rectangles = getRectangles(amount: symbolAmount)
        let path = UIBezierPath()
        let drawFunc: (CGRect) -> UIBezierPath
        
        switch symbolShape {
        case .diamond:
            drawFunc = drawDiamond(inRect:)
        case .oval:
            drawFunc = drawOval(inRect:)
        case .squiggle:
            drawFunc = drawSquiggle(inRect:)
        }
        
        for rect in rectangles {
            path.append(drawFunc(rect))
        }
        
        path.lineWidth = 3
        symbolColor.get().setStroke()
        path.stroke()
        
        switch symbolShading {
        case .outlined:
            break
        case .solid:
            symbolColor.get().setFill()
            path.fill()
        case .striped:
            path.addClip()
            
            let stripedPath = UIBezierPath()
            stripedPath.move(to: CGPoint(x: 0, y: 0))
            stripedPath.lineWidth = 0.01 * bounds.width
            
            while stripedPath.currentPoint.x < bounds.width {
                stripedPath.move(to: CGPoint(x: stripedPath.currentPoint.x + 0.04*bounds.width, y: 0))
                stripedPath.addLine(to: CGPoint(x: stripedPath.currentPoint.x, y: bounds.height))
            }
            
            stripedPath.stroke()
        }
    }

    //divide bounds into (amount)rectangles with margins and spacing
    private func getRectangles(amount: Int) -> [CGRect] {
        var rectangles = [CGRect]()
        
        //verticalMargin*4 = topMargin + bottomMargin + 2*betweenShapes
        let rectHeight = (bounds.height - bounds.verticalMargin*4)/3
        let rectWidth = bounds.width - bounds.horizontalMargin*2
        
        //create all three rectangles
        for index in 0..<3 {
            rectangles.append(CGRect(x: bounds.horizontalMargin,
                                     y: CGFloat(index+1)*bounds.verticalMargin + CGFloat(index)*rectHeight,
                                     width: rectWidth,
                                     height: rectHeight))
        }
        
        //left the one in the middle
        if amount == 1 {
            rectangles.removeFirst()
            rectangles.removeLast()
        }
        //create two in the middle
        else if amount == 2 {
            rectangles.append(CGRect(x: bounds.horizontalMargin,
                                    y: rectangles[0].midY,
                                    width: rectWidth,
                                    height: rectHeight))
            rectangles.append(CGRect(x: bounds.horizontalMargin,
                                     y: rectangles[1].midY,
                                     width: rectWidth,
                                     height: rectHeight))
            rectangles.removeFirst(3)
        }
        
        return rectangles
    }
    
    private func drawOval(inRect rect: CGRect) -> UIBezierPath{
        return UIBezierPath(ovalIn: rect)
    }
    
    private func drawDiamond(inRect rect: CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
        
        return path
    }
    
    private func drawSquiggle(inRect rect: CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                      controlPoint1: CGPoint(x: rect.width/3, y: rect.minY),
                      controlPoint2: CGPoint(x: (rect.width/3)*2, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      controlPoint1: CGPoint(x: (rect.width/3)*2, y: rect.maxY),
                      controlPoint2: CGPoint(x: rect.width/3, y: rect.midY))
        
        return path
    }
    
}

extension CGRect {
    var horizontalMargin: CGFloat {
        return width * 0.05
    }
    
    var verticalMargin: CGFloat {
        return height * 0.05
    }
}
