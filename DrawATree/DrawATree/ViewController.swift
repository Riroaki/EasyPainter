//
//  ViewController.swift
//  DrawATree
//
//  Created by Leaf on 2018/5/19.
//  Copyright © 2018年 Leaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var leafSwitch: UISwitch!
    @IBOutlet weak var symmSwitch: UISwitch!
    
    //the radius of the circle you can draw in
    var radius: CGFloat = 200
    
    //the size of screen
    var width: CGFloat = 0, height: CGFloat = 0
    
    //draw variables
    var lastPoint = CGPoint.zero
    var isDrawing = false
    var swiped = false
    var context: CGContext!
    let colors: [CGColor] = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)]
    
    //symmetric index
    var symmOn = true
    var n = 5
    
    //brush settings
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var shadowOn = true
    
    //leaf settings
    var leafSize: CGFloat = 20
    var leap = 10
    var count = 0
    var num = 0
    var drawLeaf = true
    var drawLeft = true
    
    //prepare to draw
    override func viewDidLoad() {
        width = view.frame.size.width
        height = view.frame.size.height
    }
    
    //rotate the point
    func rotatePoint(point: CGPoint, n: Int) -> CGPoint {
        let x = point.x - width/2, y = point.y - height/2
        let theta = .pi*2.0/Double(n)
        let s = CGFloat(sin(theta)), c = CGFloat(cos(theta))
        return CGPoint(x: x*c+y*s+width/2, y: y*c-x*s+height/2)
    }
    
    //draw a line
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) -> CGPath {
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        //draw a leaf
        if drawLeaf {
            if count == leap {
                context.addPath(drawLeaf(atPoint: fromPoint, directPoint: toPoint))
            }
        }
        return path
    }
    
    //draw a leaf
    func drawLeaf(atPoint: CGPoint, directPoint: CGPoint) -> CGPath {
        let path = CGMutablePath(), centerPoint1: CGPoint!, centerPoint2: CGPoint!, theta: CGFloat
        if atPoint.x != directPoint.x {
            theta = atan((directPoint.y-atPoint.y)/(directPoint.x-atPoint.x))
        } else if atPoint.y > directPoint.y {
            theta = -.pi/2
        } else {
            theta = .pi/2
        }
        
        centerPoint1 = CGPoint(x: atPoint.x + leafSize * cos(theta), y: atPoint.y + leafSize * sin(theta))
        
        //draw left leaf
        if drawLeft {
            centerPoint2 = CGPoint(x: atPoint.x - leafSize * cos(.pi/3 - theta), y: atPoint.y + leafSize * sin(.pi/3 - theta))
            path.addArc(center: centerPoint1, radius: leafSize, startAngle: theta + .pi, endAngle: theta + .pi/3*2, clockwise: true)
            path.addArc(center: centerPoint2, radius: leafSize, startAngle: theta - .pi/3, endAngle: theta, clockwise: false)

        } else {
            
            //draw right leaf
            centerPoint2 = CGPoint(x: atPoint.x - leafSize * cos(theta + .pi/3), y: atPoint.y - leafSize * sin(theta + .pi/3))
            path.addArc(center: centerPoint1, radius: leafSize, startAngle: theta - .pi, endAngle: theta - .pi/3*2, clockwise: false)
            path.addArc(center: centerPoint2, radius: leafSize, startAngle: theta + .pi/3, endAngle: theta, clockwise: true)
        }
        
        return path
    }
    
    //leafSwitch
    @IBAction func turnOnLeaf() {
        if leafSwitch.isOn {
            drawLeaf = true
        } else {
            drawLeaf = false
        }
    }
    
    //symmSwitch
    @IBAction func turnOnSymm() {
        if symmSwitch.isOn {
            symmOn = true
        } else {
            symmOn = false
        }
    }
    
    //prepare to draw
    func prepareToDraw() {
        
        //draw preparations
        UIGraphicsBeginImageContext(view.frame.size)
        context = UIGraphicsGetCurrentContext()!
        tempImage.image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        //brush settings
        context.setStrokeColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        context.setLineWidth(brushWidth)
        context.setLineCap(CGLineCap.round)
    }
    
    //start drawing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
            if isDrawing == false {
                if symmOn {
                    let x = lastPoint.x - width/2, y = lastPoint.y - height/2
                    if x*x + y*y <= radius*radius {
                        isDrawing = true
                        prepareToDraw()
                    }
                } else {
                    isDrawing = true
                    prepareToDraw()
                }
            }
        }
    }
    
    //continue drawing
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDrawing {
            return
        }
        swiped = true
        if let touch = touches.first {
            
            //adjust the point if needed
            var currentPoint = touch.location(in: self.view)
            
            //restrict the drawing area if draw symmetrically
            if symmOn {
                let x = currentPoint.x - width/2, y = currentPoint.y - height/2
                let r = sqrt(x*x+y*y)
                if r*r >= radius*radius {
                    currentPoint.x = width/2 + x*radius/r
                    currentPoint.y = height/2 + y*radius/r
                }
                
                //draw symmetrically
                for _ in 1...n {
                    context.addPath(drawLine(fromPoint: lastPoint, toPoint: currentPoint))
                    lastPoint = rotatePoint(point: lastPoint, n: n)
                    currentPoint = rotatePoint(point: currentPoint, n: n)
                }
                lastPoint.x = width - lastPoint.x
                currentPoint.x = width - currentPoint.x
                for _ in 1...n {
                    context.addPath(drawLine(fromPoint: lastPoint, toPoint: currentPoint))
                    lastPoint = rotatePoint(point: lastPoint, n: n)
                    currentPoint = rotatePoint(point: currentPoint, n: n)
                }
                lastPoint.x = width - lastPoint.x
                currentPoint.x = width - currentPoint.x
            } else {
                //draw without symmetric condition
                context.addPath(drawLine(fromPoint: lastPoint, toPoint: currentPoint))
            }
            lastPoint = currentPoint
            
            //draw a leaf: condition needs to be changed every pixel you draw
            if count == leap {
                drawLeft = !drawLeft
                count = 0
                num += 1
                num %= 5
                context.setStrokeColor(colors[num])
            }
            if drawLeaf {
                count += 1
            }
        }
        context.strokePath()
        
        tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImage.alpha = opacity*0.9
    }
    
    //draw ends
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDrawing {
            return
        }
        if !swiped {
            context.addPath(drawLine(fromPoint: lastPoint, toPoint: lastPoint))
            context.strokePath()
            tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImage.alpha = opacity*0.9
        }
        
        //copy the image from temp image view to the main view
        mainImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        tempImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImage.image = nil
        isDrawing = false
    }

    //reset the image
    @IBAction func clear(sender: AnyObject) {
        mainImage.image = nil
    }

}

