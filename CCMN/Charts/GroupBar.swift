//
//  GroupBar.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/12/18.
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
//        print(index)
        if index >= 0 && index < count {
            return self.labels[index]
        }
        return ""
    }
}

class GroupBar: BarChartView, ChartViewDelegate {
    
//    let hours = ["12-1", "1-2", "2-3", "3-4", "4-5", "5-6", "6-7", "7-8", "8-9", "9-10", "10-11", "11-12", "12-1", "1-2", "2-3", "3-4", "4-5", "5-6", "6-7", "7-8", "8-9", "9-10", "10-11", "11-12"]
    var curArr: [String] = []
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .white
        self.chartDescription?.enabled = false
        self.delegate = self
        
        //legend
        let legend = self.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;

        // Y - Axis Setup
        let yaxis = self.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0

        self.rightAxis.enabled = false

        // X - Axis Setup
        let xaxis = self.xAxis
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.granularityEnabled = true
        xaxis.enabled = true
        xaxis.forceLabelsEnabled = true

    }
    
    func drawChart() {
        curArr = MainData.proximityX
        var passerby: [BarChartDataEntry] = []
        var visitors: [BarChartDataEntry] = []
        var connected: [BarChartDataEntry] = []
        let max = MainData.proximityX.count
        for i in 0..<MainData.passersby.count {
            let dataEntry = BarChartDataEntry(x: Double(MainData.passersby[i].hour), y: Double(MainData.passersby[i].qty))
            passerby.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(MainData.visitors[i].hour), y: Double(MainData.visitors[i].qty))
            visitors.append(dataEntry1)
            let dataEntry2 = BarChartDataEntry(x: Double(MainData.connected[i].hour), y: Double(MainData.connected[i].qty))
            connected.append(dataEntry2)
        }
        let pasDataSet = BarChartDataSet(values: passerby, label: "Passerby")
        let visDataSet = BarChartDataSet(values: visitors, label: "Visitors")
        let conDataSet = BarChartDataSet(values: connected, label: "Connected")
        let dataSet = [pasDataSet, visDataSet, conDataSet]
        pasDataSet.colors = [UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0)]
        visDataSet.colors = [UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0)]
        conDataSet.colors = [UIColor(red:0.49, green:0.18, blue:0.59, alpha:1.0)]
        pasDataSet.drawValuesEnabled = false
        visDataSet.drawValuesEnabled = false
        conDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSets: dataSet)
        let groupSpace = 0.15
        let barSpace = 0.1
        let barWidth = 0.25
        chartData.barWidth = barWidth
        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        let formatter = CustomLabelsXAxisValueFormatter()//custom value formatter
        let xAxis = self.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = gg * Double(max)
        xAxis.granularity = self.xAxis.axisMaximum / Double(max)
        formatter.labels = Array(curArr.prefix(max))
        xAxis.valueFormatter = formatter
        xAxis.labelCount = max
        xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        xAxis.labelRotationAngle = -60
        self.notifyDataSetChanged()
        self.data = chartData
        self.drawMarkers = true
        self.animate(yAxisDuration: 1.0, easingOption: .linear)
        let  marker =  BalloonMarker(color: UIColor.black, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.white, insets: UIEdgeInsetsMake(2.0, 2.0, 10.0, 2.0))
        self.marker = marker
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.marker?.refreshContent(entry: entry, highlight: highlight)
    }

    
}
