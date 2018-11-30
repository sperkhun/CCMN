//
//  PieChart.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/13/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Foundation
import Charts

class PieChart: PieChartView {
    
    func initPieChart() {
        self.chartDescription?.enabled = false
        self.usePercentValuesEnabled = true
        self.drawEntryLabelsEnabled = false
        self.animate(yAxisDuration: 2)
        let legend = self.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
    }
    
    func setChart(type: String, rawData: [Int]) {
        
        var totalYValue: Double = 0
        var dataEntries: [ChartDataEntry] = []
        var dataPoints : [String]
       
        self.centerText = type + "\ndistribution"
        switch type {
        case "Proximity" :
            dataPoints = ["visitors", "passerby"]
            self.centerText = ""
            self.holeRadiusPercent = 0
            self.transparentCircleRadiusPercent = 0
        case "ProximityGen" :
            dataPoints = ["connected", "probing"]
            self.transparentCircleRadiusPercent = 0.615
            self.transparentCircleColor = UIColor.white
            self.backgroundColor = .white
            self.centerText = ""
        case "DwellTime" :
            dataPoints = ["5-30 mins", "30-60 mins", "1-5 hours", "5-8 hours", "8+ hours"]
            self.backgroundColor = .white
            self.transparentCircleRadiusPercent = 0
        case "RepeatVisitors" :
            dataPoints = ["daily", "weekly", "occasional", "firstTime"]
            self.backgroundColor = .white
            self.transparentCircleRadiusPercent = 0
        default :
            dataPoints = ["daily", "weekly", "occasional", "firstTime"]
        }
        self.initPieChart()
        
        for i in 0..<rawData.count {
            let dataEntry1 = PieChartDataEntry(value: Double(rawData[i]), label: dataPoints[i])
            totalYValue += Double(rawData[i])
            dataEntries.append(dataEntry1)
        }
        let  marker =  BalloonMarker(color: UIColor.black, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, insets: UIEdgeInsetsMake(2.0, 2.0, 10.0, 2.0), type: "pie", totalY: totalYValue)
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.sliceSpace = 1
        let colors : [UIColor]
        switch type {
        case "ProximityGen" :
            colors = [UIColor(red:0.86, green:0.25, blue:0.52, alpha:1.0),
                      UIColor(red:1.0, green:0.74, blue:0.31, alpha:1.0)]
            pieChartDataSet.drawValuesEnabled = true
        case "Proximity":
            pieChartDataSet.drawValuesEnabled = true
            colors = [UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0),
                      UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0)]
        default :
            self.marker = marker
            colors = [UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0),
                      UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0),
                      UIColor(red:0.49, green:0.18, blue:0.59, alpha:1.0),
                      UIColor(red:0.37, green:0.81, blue:0.93, alpha:1.0),
                      UIColor(red:0.32, green:0.71, blue:0.60, alpha:1.0)]
        }
        pieChartDataSet.colors = colors
        pieChartDataSet.selectionShift = 0
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.data = pieChartData
    }
}
