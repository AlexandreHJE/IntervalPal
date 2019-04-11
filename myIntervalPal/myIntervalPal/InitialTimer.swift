//
//  InitialTimer.swift
//  myIntervalPal
//
//  Created by 胡仁恩 on 2019/4/10.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class InitialTimer: UIView {

    @IBOutlet var container: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        print("override init(frame: CGRect)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let initialTimer_xib = UINib(nibName: "initialTimer", bundle: nil)
        let initialTimer = initialTimer_xib.instantiate(withOwner: self, options: nil)
        let initialTimerBlock = initialTimer[0] as! UIView
        self.addSubview(initialTimerBlock)
        container.frame = self.bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
