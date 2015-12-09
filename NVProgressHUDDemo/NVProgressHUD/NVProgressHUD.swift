//
//  NVProgressHUD.swift
//  NVProgressHUDDemo
//
//  Created by liang on 15/12/5.
//  Copyright © 2015年 liang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

public enum NVProgressHUDAnimation {
    
    case Fade
    case ZoomIn
    case ZoomOut
    
}

@objc public protocol NVProgressHUDDelegate {
    func hudDidHidden(hud: NVProgressHUD)
}

public class NVProgressHUD: UIView {

    public var labelText: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
            self.setNeedsLayout() // layout
            self.setNeedsDisplay() // drawRect
        }
    }
    
    public var labelFont: UIFont! {
        get {
            return self.label.font
        }
        set {
            self.label.font = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var labelColor: UIColor! {
        get {
            return self.label.textColor
        }
        set {
            self.label.textColor = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var detailsLabelText: String? {
        get {
            return self.detailsLabel.text
        }
        set {
            self.detailsLabel.text = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var detailsLabelFont: UIFont! {
        get {
            return self.detailsLabel.font
        }
        set {
            self.detailsLabel.font = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var detailsLabelColor: UIColor! {
        get {
            return self.detailsLabel.textColor
        }
        set {
            self.detailsLabel.textColor = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }

    public weak var delegate: NVProgressHUDDelegate?
    
    public var animationType = NVProgressHUDAnimation.Fade
    public var margin = 20.0
    public var cornerRadius = 8.0
    public var color: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    public var dimBackground: Bool = false
    public var square: Bool = false
    public var removeFromSuperViewOnHide: Bool = false
    public static let SubjectType = "NVProgressHUD"
    
    private var indicatorView: NVActivityIndicatorView
    private var label: UILabel
    private var detailsLabel: UILabel
    private var size = CGSizeZero
    private var indicatorType: NVActivityIndicatorType = NVActivityIndicatorType.BallSpinFadeLoader
    private var completionHandler: (() -> Void)? = nil
    
    private let kPadding: CGFloat = 10.0
    private let kLabelFontSize: CGFloat = 16.0
    private let kDetailsLabelFontSize: CGFloat = 12.0
    private let kIndicatorSize: CGSize = CGSize(width: 40, height: 40)
    
    // MARK: - Init
    
    /**
    Create a progress HUD with specified frame and type
    
    - parameter frame: view's frame
    - parameter type: animation type, value of NVActivityIndicatorType enum.
    
    - returns: The progress HUD
    */
    init(frame: CGRect, type: NVActivityIndicatorType = NVActivityIndicatorType.BallSpinFadeLoader) {
        indicatorView = NVActivityIndicatorView(frame: frame, type: type)
        label = UILabel(frame: frame)
        detailsLabel = UILabel(frame: frame)
        self.indicatorType = type
        super.init(frame: frame)
        
        indicatorView.frame = CGRectMake(0, 0, kIndicatorSize.width, kIndicatorSize.height)
        
        self.alpha = 0.0
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(indicatorView)
        self.addSubview(label)
        self.addSubview(detailsLabel)
        
        setupLabels()
    }

    required public init?(coder aDecoder: NSCoder) {
        indicatorView = NVActivityIndicatorView(frame: CGRectZero)
        label = UILabel(frame: CGRectZero)
        detailsLabel = UILabel(frame: CGRectZero)
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI setup
    
    private func setupLabels() {
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(kLabelFontSize)
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        
        detailsLabel.textColor = UIColor.whiteColor()
        detailsLabel.font = UIFont.boldSystemFontOfSize(kDetailsLabelFontSize)
        detailsLabel.backgroundColor = UIColor.clearColor()
        detailsLabel.textAlignment = NSTextAlignment.Center
        detailsLabel.numberOfLines = 0
    }
    
    // MARK: - Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let parent = self.superview {
            self.frame = parent.bounds
        }
        let bounds = self.bounds
        
        // HUD size
        let maxWidth = CGRectGetWidth(bounds) - 4 * CGFloat(margin)
        var totalSize = CGSizeZero
        
        // Indicator size
        var indicatorSize = indicatorView.bounds.size
        indicatorSize.width = min(indicatorSize.width, maxWidth)
        totalSize.width = max(indicatorSize.width, totalSize.width)
        totalSize.height += indicatorSize.height
        
        // Label size
        var labelSize = CGSizeZero
        if let text = label.text where text.isEmpty == false {
            labelSize = (text as NSString).sizeWithAttributes([NSFontAttributeName: label.font])
            labelSize.width = min(labelSize.width, maxWidth)
            totalSize.width = max(labelSize.width, totalSize.width)
        }
        totalSize.height += labelSize.height
        if labelSize.height > 0 && indicatorSize.height > 0 {
            totalSize.height += kPadding
        }
        
        // DetailsLabel size
        let remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * CGFloat(margin)
        let maxSize = CGSizeMake(maxWidth, remainingHeight)
        var detailsLabelSize = CGSizeZero
        if let text = detailsLabel.text where text.isEmpty == false {
            detailsLabelSize = (text as NSString).boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: detailsLabel.font], context: nil).size
        }
        totalSize.width = max(detailsLabelSize.width, totalSize.width)
        totalSize.height += detailsLabelSize.height
        if detailsLabelSize.height > 0 && (indicatorSize.height > 0 || labelSize.height > 0){
            totalSize.height += kPadding
        }
        
        totalSize.width += CGFloat(margin) * 2
        totalSize.height += CGFloat(margin) * 2
        
        // Indicator Position
        var xPosition = round(CGRectGetMidX(self.frame) - indicatorSize.width / 2)
        var yPosition = round(CGRectGetMidY(self.frame) - totalSize.height / 2 + CGFloat(margin))
        indicatorView.frame = CGRectMake(xPosition, yPosition, indicatorSize.width, indicatorSize.height)
        yPosition += indicatorSize.height + kPadding
        
        // Label Position
        xPosition = round(CGRectGetMidX(self.frame) - labelSize.width / 2)
        label.frame = CGRectMake(xPosition, yPosition, labelSize.width, labelSize.height)
        yPosition += round(label.bounds.height) + kPadding
        
        // DetailsLabel Position
        xPosition = round(CGRectGetMidX(self.frame) - detailsLabelSize.width / 2)
        detailsLabel.frame = CGRectMake(xPosition, yPosition, detailsLabelSize.width, detailsLabelSize.height)
        
        if square {
            let maxLength = max(totalSize.width, totalSize.height)
            if maxLength <= maxWidth {
                totalSize.width = maxLength
            }
            if maxLength <= CGRectGetHeight(bounds) - CGFloat(margin) * 2 {
                totalSize.height = maxLength
            }
        }
        
        size = totalSize
    }
    
    override public func drawRect(rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        
        if dimBackground {
            
            let gradLocations = [CGFloat(0.0), CGFloat(1.0)]
            let gradColors = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.75)]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, 2)
            
            let gradCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            let gradRadius = min(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
            
            // draw gradient background
            CGContextDrawRadialGradient(context, gradient, center, 0, gradCenter, gradRadius, CGGradientDrawingOptions.DrawsAfterEndLocation)
        }
        
        let roundedRect = CGRectMake(CGRectGetMidX(self.frame)-size.width/2, CGRectGetMidY(self.frame)-size.height/2, size.width, size.height)
        let radius = CGFloat(cornerRadius)
        
        // draw hud
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(roundedRect) + radius, CGRectGetMinY(roundedRect))
        CGContextAddArc(context, CGRectGetMaxX(roundedRect) - radius, CGRectGetMinY(roundedRect) + radius, radius, CGFloat(3 * M_PI_2), 0, 0)
        CGContextAddArc(context, CGRectGetMaxX(roundedRect) - radius, CGRectGetMaxY(roundedRect) - radius, radius, 0, CGFloat(M_PI_2), 0)
        CGContextAddArc(context, CGRectGetMinX(roundedRect) + radius, CGRectGetMaxY(roundedRect) - radius, radius, CGFloat(M_PI_2), CGFloat(M_PI), 0)
        CGContextAddArc(context, CGRectGetMinX(roundedRect) + radius, CGRectGetMinY(roundedRect) + radius, radius, CGFloat(M_PI), 3 * CGFloat(M_PI_2), 0)
        CGContextClosePath(context)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillPath(context)
        
    }
    
    // MARK: - show & hide
    
    public func show(animated: Bool) {
        // TODO: Make sure run in mainThread
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        
        if animated {
            if animationType == NVProgressHUDAnimation.ZoomIn {
                self.transform = CGAffineTransformMakeScale(0.5, 0.5)
            } else if animationType == NVProgressHUDAnimation.ZoomOut {
                self.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }
            UIView .animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 1.0
                self.transform = CGAffineTransformIdentity
            })
            
        } else {
            
            self.alpha = 1.0
        }
        
        indicatorView.startAnimation()
    }
    
    public func show(animated: Bool, executingBlock: dispatch_block_t, completionHandler: (() -> Void)? = nil) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.completionHandler = completionHandler
        
        dispatch_async(queue) { () -> Void in
            executingBlock()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hide(animated)
            })
        }
        
        show(animated)
    }
    
    public func hide(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0.0
                if self.animationType == NVProgressHUDAnimation.ZoomIn {
                    self.transform = CGAffineTransformMakeScale(1.5, 1.5)
                } else if self.animationType == NVProgressHUDAnimation.ZoomOut {
                    self.transform = CGAffineTransformMakeScale(0.5, 0.5)
                }
            }, completion: { (finished) -> Void in
                self.done()
            })
        } else {
            self.alpha = 0.0
            done()
        }
    }
    
    public func hide(animated: Bool, afterDelay: NSTimeInterval) {
    
        self.performSelector("hideDelayed:", withObject: NSNumber(bool: animated) , afterDelay: afterDelay)
    }
    
    @objc private func hideDelayed(animated: NSNumber) {
        self.hide(animated.boolValue)
    }
    
    private func done() {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        
        self.indicatorView.stopAnimation()
        
        if removeFromSuperViewOnHide {
            self.removeFromSuperview()
        }
        
        if let completionHandler = completionHandler {
            completionHandler()
            self.completionHandler = nil
        }
        
        self.delegate?.hudDidHidden(self)
    }
    
}

extension UIView {
    
    func showHUD(animated: Bool) -> NVProgressHUD {
        let hud = NVProgressHUD(frame: self.frame)
        self.addSubview(hud)
        hud.removeFromSuperViewOnHide = true
        hud.show(animated)
        return hud
    }
    
    func hideHUD(animated: Bool) -> Bool {
        for view in self.subviews.reverse() {
            let aMirror = Mirror(reflecting: view)
            if String(aMirror.subjectType) == NVProgressHUD.SubjectType {
                (view as! NVProgressHUD).hide(animated)
                return true
            }
        }
        return false
    }
}
