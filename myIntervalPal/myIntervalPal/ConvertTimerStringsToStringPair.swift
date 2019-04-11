//
//  ConvertTimerStringsToStringPair.swift
//  myIntervalPal
//
//  Created by Alexhu on 2019/4/3.
//  Copyright © 2019 alexHu. All rights reserved.
//

import Foundation

public func convertTimerStringToStringPair(timerString: String) -> (String, String)
{
    let stringArray:[String] = timerString.components(separatedBy: ":")
    return (stringArray[0], stringArray[1])
}
