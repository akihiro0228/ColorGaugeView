//
//  ViewController.swift
//  ColorGaugeView
//
//  Created by akihiro_0228 on 07/14/2015.
//  Copyright (c) 2015 akihiro_0228. All rights reserved.
//

import UIKit
import ColorGaugeView

class ViewController: UIViewController {
    @IBOutlet weak var colorGauge: ColorGaugeView!
    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIColor Array
        let barColors = [
            UIColor.blueColor(),
            UIColor.brownColor(),
            UIColor.yellowColor(),
            UIColor.cyanColor(),
            UIColor.magentaColor()
        ]

        // set gauge colors
        self.colorGauge.barColors = barColors

        // set gauge type
        self.colorGauge.type = ColorGaugeType.LeftToRight

        self.slider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    func sliderChanged(sender: UISlider) {
        self.colorGauge.gauge = self.slider.value
    }
}

