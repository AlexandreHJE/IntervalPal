//
//  ConvertStringToTimeInterval.swift
//  myIntervalPal
//
//  Created by Alexhu on 2019/4/3.
//  Copyright © 2019 alexHu. All rights reserved.
//

import Foundation

public func convertTimeInterval(minText: String, secText: String) -> TimeInterval
{
    let timeInterval = Double(Int(minText)! * 60) + Double(Int(secText)!)
    return timeInterval
}
