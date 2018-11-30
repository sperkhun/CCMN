//
//  SimpleLineChart.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/18/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Charts
import Foundation

class SimpleLineChart: LineChartView, ChartViewDelegate {
    
    func initLineChart() {
        self.chartDescription?.enabled = false
        self.animate(yAxisDuration: 2)
        
        let legend = self.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let  marker =  BalloonMarker(color: UIColor.black, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, insets: UIEdgeInsetsMake(2.0, 2.0, 10.0, 2.0), type: "none", totalY: 0)
        self.marker = marker
        self.drawMarkers = true
    }
    
    func createCharDataSet(type: String, rawData: [Int], color: UIColor) -> LineChartDataSet {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<rawData.count {
            let dataEntry1 = ChartDataEntry(x: Double(i), y: Double(rawData[i]))
            dataEntries.append(dataEntry1)
        }
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: type)
        let colors = [color]
        lineChartDataSet.colors = colors
        lineChartDataSet.circleColors = colors
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.circleRadius = 4
        return (lineChartDataSet)
    }
    
    func setGroupChart(type: [String], rawData: [[Int]], dataPoints: [String]) {
        self.initLineChart()
        var dataSetArray : [LineChartDataSet] = []
        var colors : [UIColor] = []
        if (type.count == 1) {
            colors = [UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0)]
        }
        else {
            colors = [UIColor(red:0.32, green:0.71, blue:0.60, alpha:1.0),
                      UIColor(red:0.49, green:0.18, blue:0.59, alpha:1.0),
                      UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0)]
        }
        if (type.count == rawData.count && rawData.count <= colors.count)
        {
            for i in 0...rawData.count - 1 {
                dataSetArray.append(createCharDataSet(type: type[i], rawData: rawData[i], color: colors[i]))
            }
        }
        let formatter = CustomLabelsXAxisValueFormatter()
        let xAxis = self.xAxis
        formatter.labels = Array(dataPoints)
        xAxis.valueFormatter = formatter
        xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        xAxis.labelRotationAngle = -60
        xAxis.labelPosition = .bottom
        let chartData = LineChartData(dataSets: dataSetArray)
        self.notifyDataSetChanged()
        self.data = chartData
    }
}
