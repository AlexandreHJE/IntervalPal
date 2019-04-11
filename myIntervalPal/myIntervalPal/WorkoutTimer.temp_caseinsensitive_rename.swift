//
//  workoutTimer.swift
//  myIntervalPal
//
//  Created by Alexhu on 2019/3/27.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class WorkoutTimer: UIView {

    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblSec: UILabel!
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
    }
    

}
