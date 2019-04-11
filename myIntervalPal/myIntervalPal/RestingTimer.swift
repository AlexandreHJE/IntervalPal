//
//  RestingTimer.swift
//  myIntervalPal
//
//  Created by Alexhu on 2019/3/27.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class RestingTimer: UIView {

    @IBOutlet var container: UIView!
    @IBOutlet weak var lblMinSec: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect){
        super.init(frame: frame)
        print("override init(frame: CGRect)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let restingTimer_xib = UINib(nibName: "restingTimer", bundle: nil)
        let restingTimer = restingTimer_xib.instantiate(withOwner: self, options: nil)
        let restingTimerBlock = restingTimer[0] as! UIView
        self.addSubview(restingTimerBlock)
        container.frame = self.bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
