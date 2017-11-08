//
//  BalloonMarker.swift
//  woodpecker
//
//  Created by QiWL on 2017/9/27.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

import Foundation
import Charts


open class BalloonMarker: MarkerImage
{
    open var color: UIColor?
    open var borderColor: UIColor?
    open var textColor: UIColor?
    open var lineColor: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()
    open var isInt:Bool = false
    open var lineColors:NSArray = NSArray()
    
    fileprivate var labelns: NSString?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [String : AnyObject]()
    
    public init(textColor:UIColor, font: UIFont, insets: UIEdgeInsets )
    {
        super.init()
        
        self.textColor = textColor
        self.font = font
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init()
        
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        if labelns == nil
        {
            return
        }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        if let color = color
        {
            context.beginPath()
            let bezierPath = UIBezierPath()
            bezierPath.lineWidth = 0.5
            bezierPath.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x + rect.size.width,y: rect.origin.y))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x + rect.size.width,y: rect.origin.y + rect.size.height - arrowSize.height))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,y: rect.origin.y + rect.size.height - arrowSize.height))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0,y: rect.origin.y + rect.size.height))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,y: rect.origin.y + rect.size.height - arrowSize.height))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x,y: rect.origin.y + rect.size.height - arrowSize.height))
            bezierPath.addLine(to: CGPoint(x: rect.origin.x,y: rect.origin.y))
            bezierPath.close()
            color.setFill()
            bezierPath.fill()
            lineColor?.setStroke()
            bezierPath.stroke()
        }
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        labelns?.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if highlight.dataSetIndex < lineColors.count - 1  {
            lineColor = lineColors[highlight.dataSetIndex] as? UIColor
            _drawAttributes[NSForegroundColorAttributeName] = lineColor
            self.textColor = lineColor;
        }else{
            lineColor = self.borderColor
            _drawAttributes[NSForegroundColorAttributeName] = self.textColor
        }
        
        if isInt && ((Double(Int(entry.y)) == entry.y)){
            setLabel(String(entry.y))
        }else{
            setLabel(String(entry.y))
        }
    }
    
    open func setLabel(_ label: String)
    {
        labelns = label as NSString
        
        _drawAttributes.removeAll()
        _drawAttributes[NSFontAttributeName] = self.font
        _drawAttributes[NSParagraphStyleAttributeName] = _paragraphStyle
        _drawAttributes[NSForegroundColorAttributeName] = self.textColor
        
        _labelSize = labelns?.size(attributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
