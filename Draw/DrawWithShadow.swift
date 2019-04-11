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
    var path = CGMutablePath()
    var width = 4
    
//    @IBOutlet weak var forceLabel: UILabel!
    
    func setStroke(context: CGContext?) {
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(CGFloat(width))
        context?.setFillColor(UIColor.blue.cgColor)
        context?.setLineCap(CGLineCap.round)
        context?.setLineJoin(CGLineJoin.round)
        let size = CGSize(width: width, height: width)
        context?.setShadow(offset: size, blur: 0.8, color: UIColor.gray.cgColor)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        setStroke(context: context)
        context?.addPath(path)
        context?.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches {
            let p: UITouch = touch as! UITouch
            path.move(to: CGPoint(x: p.location(in: self).x, y: p.location(in: self).y))
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let p: UITouch = touch as! UITouch
            path.addLine(to: CGPoint(x: p.location(in: self).x, y: p.location(in: self).y))
//            forceLabel.text = String(Float(p.force))
//            print("\(p.force)")
            setNeedsDisplay()
        }
    }
}
    

