//
//  String_Ext.swift
//  myIntervalPal
//
//  Created by Alexhu on 2019/4/3.
//  Copyright © 2019 alexHu. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func isNotEmpty() -> Bool {
        return count > 0
    }
    
    static func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if minutes > 0 {
            return  self.init(format:"%02i:%02i", minutes, seconds)
        } else {
            return  self.init(format:"00:%02i", seconds)
        }
    }
    
}
