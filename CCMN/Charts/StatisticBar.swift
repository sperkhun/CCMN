//
//  StatisticBar.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/14/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Charts

class StatisticBar: BarChartView, ChartViewDelegate {

    func initStatisticBar() {
        self.animate(yAxisDuration: 2)
        self.chartDescription?.enabled = false
        self.rightAxis.enabled = false
    }
    
    func setChart(type: String, rawData: [(Int, Int)], dataPoints: [String]) {
    
        var dataEntries: [ChartDataEntry] = []
        self.initStatisticBar()
        for i in 0..<rawData.count {
            let dataEntry = BarChartDataEntry(x: Double(i) + 0.5, y: Double(rawData[i].1))
            dataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "")
        let colors : [UIColor]
        switch type {
        case "passersby" :
            colors = [UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0)]
        case "visitors" :
            colors = [UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0)]
        case "connected" :
            colors = [UIColor(red:0.49, green:0.18, blue:0.59, alpha:1.0)]
        default :
            colors = [UIColor(red:0.32, green:0.71, blue:0.60, alpha:1.0)]
        }
        barChartDataSet.colors = colors
        barChartDataSet.drawValuesEnabled = false
        let barChartData = BarChartData(dataSet: barChartDataSet)
        let xAxis = self.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 7
        let formatter = CustomLabelsXAxisValueFormatter()
        formatter.labels = Array(dataPoints)
        xAxis.valueFormatter = formatter
        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        xAxis.labelPosition = .bottom
        xAxis.centerAxisLabelsEnabled = true
        let  marker =  BalloonMarker(color: UIColor.black, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, insets: UIEdgeInsetsMake(2.0, 2.0, 10.0, 2.0), type: "none", totalY: 0)
        self.marker = marker
        self.notifyDataSetChanged()
        let legend = self.legend
        legend.enabled = false
        self.data = barChartData
    }
    
    func setGroupChart(rawData: [(Int, Int, Int, Int, Int, Int)]) {
    
        var fiveThirtyMin: [BarChartDataEntry] = []
        var thirtySixtyMin: [BarChartDataEntry] = []
        var oneFiveHour: [BarChartDataEntry] = []
        var fiveEightHour: [BarChartDataEntry] = []
        var eightPlusHour: [BarChartDataEntry] = []
        
        self.initStatisticBar()
        let max = rawData.count
        for i in 0..<rawData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(rawData[i].0))
            fiveThirtyMin.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i), y: Double(rawData[i].1))
            thirtySixtyMin.append(dataEntry1)
            let dataEntry2 = BarChartDataEntry(x: Double(i), y: Double(rawData[i].2))
            oneFiveHour.append(dataEntry2)
            let dataEntry3 = BarChartDataEntry(x: Double(i), y: Double(rawData[i].3))
            fiveEightHour.append(dataEntry3)
            let dataEntry4 = BarChartDataEntry(x: Double(i), y: Double(rawData[i].4))
            eightPlusHour.append(dataEntry4)
        }
        let dataSet1 = BarChartDataSet(values: fiveThirtyMin, label: "5-30 mins")
        let dataSet2 = BarChartDataSet(values: thirtySixtyMin, label: "30-60 mins")
        let dataSet3 = BarChartDataSet(values: oneFiveHour, label: "1-5 hours")
        let dataSet4 = BarChartDataSet(values: fiveEightHour, label: "5-8 hours")
        let dataSet5 = BarChartDataSet(values: eightPlusHour, label: "8+ hours")

        let dataSet = [dataSet1, dataSet2, dataSet3, dataSet4, dataSet5]
        dataSet1.colors = [UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0)]
        dataSet2.colors = [UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0)]
        dataSet3.colors = [UIColor(red:0.49, green:0.18, blue:0.59, alpha:1.0)]
        dataSet4.colors = [UIColor(red:0.37, green:0.81, blue:0.93, alpha:1.0)]
        dataSet5.colors = [UIColor(red:0.32, green:0.71, blue:0.60, alpha:1.0)]
        
        dataSet1.drawValuesEnabled = false
        dataSet2.drawValuesEnabled = false
        dataSet3.drawValuesEnabled = false
        dataSet4.drawValuesEnabled = false
        dataSet5.drawValuesEnabled = false
        let chartData = BarChartData(dataSets: dataSet)
        let groupSpace = 0.15
        let barSpace = 0.1
        let barWidth = 0.25
        chartData.barWidth = barWidth
        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)

        let formatter = CustomLabelsXAxisValueFormatter()
        formatter.labels = Array(MainData.dataPoints)
        let xAxis = self.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = gg * Double(max)
        xAxis.granularity = self.xAxis.axisMaximum / Double(max)
        xAxis.valueFormatter = formatter
        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        xAxis.labelPosition = .bottom
        xAxis.centerAxisLabelsEnabled = true
        let  marker =  BalloonMarker(color: UIColor.black, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, insets: UIEdgeInsetsMake(2.0, 2.0, 10.0, 2.0), type: "none", totalY: 0)
        self.marker = marker
        self.notifyDataSetChanged()
        self.data = chartData
    }
}
