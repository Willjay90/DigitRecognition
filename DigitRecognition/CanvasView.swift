//
//  CanvasView.swift
//  HandWritingRecognition
//
//  Created by Wei Chieh Tseng on 05/12/2017.
//

import UIKit

class CanvasView: UIView {
    
    var lineColor: UIColor!
    var lineWidth: CGFloat!
    
    var path: UIBezierPath!
    var touchPoint: CGPoint!
    var startPoint: CGPoint!
    
    override func layoutSubviews() {
        setupDefaultSettings()
    }
    
    // control touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            startPoint = touch.location(in: self)
            path = UIBezierPath()
            path.move(to: startPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchPoint = touch.location(in: self)
        }
        
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        
        drawShapeLayer()
    }
    
    // clear path on layer
    func clearCanvas() {
        guard let path = path else { return }
        path.removeAllPoints()
        layer.sublayers = nil
        setNeedsDisplay()
    }
    
    // draw shape on layer
    private func drawShapeLayer() {
        guard let path = path else { return }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(shapeLayer)
        setNeedsDisplay()
    }
    
    private func setupDefaultSettings() {
        lineColor = .white
        lineWidth = 10
        
        clipsToBounds = true
        isMultipleTouchEnabled = false
    }
    
}


