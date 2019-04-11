//
//  ViewController.swift
//  Draw
//
//  Created by Leaf on 2018/4/23.
//  Copyright © 2018年 Leaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

class Board: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        }
    
    var pos = CGPoint(x: 100, y: 100)
    var size: CGFloat = 200.0
    var move: Bool = false
    var delta = CGPoint(x: 0, y: 0)
    var path = CGMutablePath()
    
    func setStroke(context: CGContext?) {
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(4)
        context?.setFillColor(UIColor.blue.cgColor)
        context?.setLineCap(CGLineCap.round)
        context?.setLineJoin(CGLineJoin.round)
        let size = CGSize(width: 4, height: 4)
        context?.setShadow(offset: size, blur: 0.8, color: UIColor.gray.cgColor)
    }
    
    func drawSquare(at: CGPoint, size: Int) -> CGPath {
        
        let path = CGMutablePath()
        let x: Int = Int(at.x)
        let y: Int = Int(at.y)
        path.move(to: at)
        path.addLine(to: CGPoint(x: x+size, y: y))
        path.addLine(to: CGPoint(x: x+size, y: y+size))
        path.addLine(to: CGPoint(x: x, y: y+size))
        path.addLine(to: at)
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        let initPath = drawSquare(at: pos, size: Int(size))
        setStroke(context: context)
        context?.addPath(initPath)
        context?.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches {
            let p: UITouch = touch as! UITouch
            let x = p.location(in: self).x
            let y = p.location(in: self).y
            if x <= (pos.x + size) && x >= pos.x && y <= (pos.y + size) && y >= pos.y {
                move = true
                delta.x = x - pos.x
                delta.y = y - pos.y
            }
            else {
                move = false
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let p: UITouch = touch as! UITouch
            let x = p.location(in: self).x
            let y = p.location(in: self).y
            if move == true {
                pos.x = x - delta.x
                pos.y = y - delta.y
                path = drawSquare(at: pos, size: Int(size)) as! CGMutablePath
                setNeedsDisplay()
            }
        }
    }
    
}
