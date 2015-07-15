//
//  ColorGaugeView.swift
//  Pods
//
//  Created by akihiro on 2015/07/14.
//
//

import UIKit

public enum ColorGaugeType {
    case LeftToRight
    case RightToLeft
    case BottomToTop
    case TopToBottom
}

@IBDesignable
public class ColorGaugeView : UIView {

    // subviews
    private let gaugeView    : UIView = UIView(frame: CGRectZero)
    private let gaugeBarView : UIView = UIView(frame: CGRectZero)
    private let restBarView  : UIView = UIView(frame: CGRectZero)

    // gauge range
    private let gaugeMin : Float  = 0
    private var gaugeMax : Float  = 0

    // gauge type
    public var type : ColorGaugeType = .LeftToRight {
        didSet {
            self.layoutBars(CGFloat(self.gauge - Float(Int(self.gauge))))
        }
    }

    // gauge value
    public var gauge : Float = 0 {
        didSet {
            if gauge <= gaugeMin { gauge = gaugeMin }
            if gauge >= gaugeMax { gauge = gaugeMax }
            self.updateGauge()
        }
    }

    // gauge bar colors
    public var barColors : [UIColor] = [] {
        didSet {
            self.gaugeMax = Float(barColors.count)
        }
    }

    // gauge background color
    @IBInspectable
    public var defaultColor: UIColor = UIColor.clearColor() {
        didSet {
            self.gaugeView.backgroundColor = defaultColor
        }
    }

    // gauge border color
    @IBInspectable
    public var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            self.gaugeView.layer.borderColor = borderColor.CGColor
        }
    }

    // gauge border width
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            self.gaugeView.layer.borderWidth = borderWidth
        }
    }

    // gauge border radius
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.gaugeView.layer.cornerRadius = cornerRadius
        }
    }

    // show only IB
    override public func prepareForInterfaceBuilder() {
        self.gaugeView.frame.size = self.frame.size
        self.addSubview(self.gaugeView)

        self.gaugeView.layer.borderColor  = borderColor.CGColor
        self.gaugeView.layer.borderWidth  = borderWidth
        self.gaugeView.layer.cornerRadius = cornerRadius
    }

    // initialize
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        self.gaugeView.frame = self.bounds
        self.gaugeView.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.gaugeView.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        self.gaugeView.clipsToBounds = true

        self.addSubview(self.gaugeView)
        self.gaugeView.addSubview(self.gaugeBarView)
        self.gaugeView.addSubview(self.restBarView)
    }

    private func updateGauge() {
        let restIndex = Int(self.gauge)
        let progress  = CGFloat(self.gauge - Float(restIndex))

        if restIndex != 0 { self.restBarView.backgroundColor  = self.barColors[restIndex - 1] }
        if progress  != 0 { self.gaugeBarView.backgroundColor = self.barColors[restIndex]     }

        self.layoutBars(progress)

        if restIndex == 0 { self.restBarView.frame = CGRectZero }
    }

    private func layoutBars(progress: CGFloat) {
        switch self.type {
        case .LeftToRight: self.layoutLeftToRight(progress)
        case .RightToLeft: self.layoutRightToLeft(progress)
        case .BottomToTop: self.layoutBottomToTop(progress)
        case .TopToBottom: self.layoutTopToBottom(progress)
        }
    }

    // layout bar methods
    private func layoutLeftToRight(progress: CGFloat) {
        self.gaugeBarView.frame = CGRectMake(0, 0, self.frame.size.width * progress, self.frame.size.height)
        self.restBarView.frame = CGRectMake(self.gaugeBarView.frame.size.width, 0, self.frame.size.width - self.gaugeBarView.frame.size.width, self.frame.size.height)
    }

    private func layoutRightToLeft(progress: CGFloat) {
        self.restBarView.frame = CGRectMake(0, 0, self.frame.size.width * (1 - progress), self.frame.size.height)
        self.gaugeBarView.frame = CGRectMake(self.restBarView.frame.size.width, 0, self.frame.size.width - self.restBarView.frame.size.width, self.frame.size.height)
    }

    private func layoutTopToBottom(progress: CGFloat) {
        self.gaugeBarView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * progress)
        self.restBarView.frame = CGRectMake(0, self.gaugeBarView.frame.size.height, self.frame.size.width, self.frame.size.height - self.gaugeBarView.frame.size.height)
    }

    private func layoutBottomToTop(progress: CGFloat) {
        self.restBarView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * (1 - progress))
        self.gaugeBarView.frame = CGRectMake(0, self.restBarView.frame.size.height, self.frame.size.width, self.frame.size.height - self.restBarView.frame.size.height)
    }
}