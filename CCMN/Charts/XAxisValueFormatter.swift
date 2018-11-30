//
//  XAxisValueFormatter.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/21/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Charts

class CustomLabelsXAxisValueFormatter : NSObject, IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.labels.count
        guard let axis = axis, count > 0 else {
            return ""
        }
        let factor = axis.axisMaximum / Double(count)
        let index = Int((value / factor).rounded())
        if index >= 0 && index < count {
            return self.labels[index]
        }
        return ""
    }
}
