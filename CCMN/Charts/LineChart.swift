//
//  LineChart.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/12/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Charts

class LineChart: CombinedChartView, ChartViewDelegate {
    
    var curArr: [String] = []
    let colors = [UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0),
        UIColor(red:0.73, green:0.15, blue:0.39, alpha:1.0),
        UIColor(red:0.49, green:0.18, blue:0.59, alpha:1.0),
        UIColor(red:0.37, green:0.81, blue:0.93, alpha:1.0),
        UIColor(red:0.32, green:0.71, blue:0.60, alpha:1.0)]
    let shapes = [ScatterChartDataSet.Shape.circle, ScatterChartDataSet.Shape.triangle, ScatterChartDataSet.Shape.square, ScatterChartDataSet.Shape.x, ScatterChartDataSet.Shape.cross]
    
    var dwellTime = [(date: String, hour: Int, fiveThirtyMin: Int, thirtySixtyMin: Int, oneFiveHour: Int, fiveEightHour: Int, eightPlusHour: Int)]()
    var repeatVisitors = [(date: String, hour: Int, daily: Int, weekly: Int, occas: Int, firstTime: Int, yesterday: Int)]()
    
    var charts = Array(repeating: [ChartDataEntry](), count: 5)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = .white
        self.chartDescription?.textColor = UIColor.clear
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
    
    func drawChartFill() {
        
        curArr = MainData.dwellX
        var five: [ChartDataEntry] = []
        var thirty: [ChartDataEntry] = []
        var one: [ChartDataEntry] = []
        var fiveH: [ChartDataEntry] = []
        var eight: [ChartDataEntry] = []
        let max = MainData.dwellX.count

        
        for i in 0..<MainData.dwellTime.count {
            let x = Double(i) + 0.5
            let dataEntry = ChartDataEntry(x: x, y: Double(MainData.dwellTime[i].fiveThirtyMin))
            five.append(dataEntry)
            let dataEntry1 = ChartDataEntry(x: x, y: Double(MainData.dwellTime[i].thirtySixtyMin))
            thirty.append(dataEntry1)
            let dataEntry2 = ChartDataEntry(x: x, y: Double(MainData.dwellTime[i].oneFiveHour))
            one.append(dataEntry2)
            let dataEntry3 = ChartDataEntry(x: x, y: Double(MainData.dwellTime[i].fiveEightHour))
            fiveH.append(dataEntry3)
            let dataEntry4 = ChartDataEntry(x: x, y: Double(MainData.dwellTime[i].eightPlusHour))
            eight.append(dataEntry4)
        }
//        let ft = ScatterChartDataSet(
        let ftDataSet = ScatterChartDataSet(values: five, label: "5-30 mins")
        let tsDataSet = ScatterChartDataSet(values: thirty, label: "30-60 mins")
        let ofDataSet = ScatterChartDataSet(values: one, label: "1-5 hours")
        let feDataSet = ScatterChartDataSet(values: fiveH, label: "5-8 hours")
        let epDataSet = ScatterChartDataSet(values: eight, label: "8+ hours")
        let ftLDataSet = LineChartDataSet(values: five, label: nil)
        let tsLDataSet = LineChartDataSet(values: thirty, label: nil)
        let ofLDataSet = LineChartDataSet(values: one, label: nil)
        let feLDataSet = LineChartDataSet(values: fiveH, label: nil)
        let epLDataSet = LineChartDataSet(values: eight, label: nil)
        let scatterSet = [ftDataSet, tsDataSet, ofDataSet, feDataSet, epDataSet]
        let lineSet = [ftLDataSet, tsLDataSet, ofLDataSet, feLDataSet, epLDataSet]
        
        for i in 0..<lineSet.count {
            lineSet[i].fillColor = colors[i]
            lineSet[i].colors = [.gray]
            lineSet[i].drawCirclesEnabled = false
            lineSet[i].drawFilledEnabled = true
            lineSet[i].drawValuesEnabled = false
            lineSet[i].form = .none
        }
        for i in 0..<scatterSet.count {
            scatterSet[i].colors = [colors[i]]
            scatterSet[i].setScatterShape(shapes[i])
//            scatterSet[i].
            scatterSet[i].drawValuesEnabled = false
            scatterSet[i].scatterShapeSize = 8
        }
        let chartData = CombinedChartData()
        chartData.lineData = LineChartData(dataSets: lineSet)
        chartData.scatterData = ScatterChartData(dataSets: scatterSet)
        
        let formatter = CustomLabelsXAxisValueFormatter()//custom value formatter
        let xAxis = self.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = Double(max)
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
    
    func drawChart() {
        
        curArr = MainData.repeatX
        var daily: [ChartDataEntry] = []
        var weekly: [ChartDataEntry] = []
        var occasional: [ChartDataEntry] = []
        var first: [ChartDataEntry] = []
        var yesterday: [ChartDataEntry] = []
        let max = MainData.repeatX.count
        
        
        for i in 0..<MainData.repeatVisitors.count {
            let x = Double(i) + 0.5
            let dataEntry = ChartDataEntry(x: x, y: Double(MainData.repeatVisitors[i].daily))
            daily.append(dataEntry)
            let dataEntry1 = ChartDataEntry(x: x, y: Double(MainData.repeatVisitors[i].weekly))
            weekly.append(dataEntry1)
            let dataEntry2 = ChartDataEntry(x: x, y: Double(MainData.repeatVisitors[i].occas))
            occasional.append(dataEntry2)
            let dataEntry3 = ChartDataEntry(x: x, y: Double(MainData.repeatVisitors[i].firstTime))
            first.append(dataEntry3)
            let dataEntry4 = ChartDataEntry(x: x, y: Double(MainData.repeatVisitors[i].yesterday))
            yesterday.append(dataEntry4)
        }
        //        let ft = ScatterChartDataSet(
        let dDataSet = ScatterChartDataSet(values: daily, label: "Daily")
        let wDataSet = ScatterChartDataSet(values: weekly, label: "Weekly")
        let oDataSet = ScatterChartDataSet(values: occasional, label: "Occasional")
        let fDataSet = ScatterChartDataSet(values: first, label: "First Time")
        let yDataSet = ScatterChartDataSet(values: yesterday, label: "Yesterday")
        let dLDataSet = LineChartDataSet(values: daily, label: nil)
        let wLDataSet = LineChartDataSet(values: weekly, label: nil)
        let oLDataSet = LineChartDataSet(values: occasional, label: nil)
        let fLDataSet = LineChartDataSet(values: first, label: nil)
        let yLDataSet = LineChartDataSet(values: yesterday, label: nil)
        let scatterSet = [dDataSet, wDataSet, oDataSet, fDataSet, yDataSet]
        let lineSet = [dLDataSet, wLDataSet, oLDataSet, fLDataSet, yLDataSet]
        
        for i in 0..<lineSet.count {
            lineSet[i].fillColor = colors[i]
            lineSet[i].colors = [colors[i]]
            lineSet[i].drawCirclesEnabled = false
            lineSet[i].drawValuesEnabled = false
            lineSet[i].form = .none
            lineSet[i].lineWidth = 1.5
        }
        for i in 0..<scatterSet.count {
            scatterSet[i].colors = [colors[i]]
            scatterSet[i].setScatterShape(shapes[i])
            scatterSet[i].drawValuesEnabled = false
            scatterSet[i].form = .line
            scatterSet[i].scatterShapeSize = 5
        }
        
        let chartData = CombinedChartData()
        chartData.lineData = LineChartData(dataSets: lineSet)
        chartData.scatterData = ScatterChartData(dataSets: scatterSet)
        
        let formatter = CustomLabelsXAxisValueFormatter()//custom value formatter
        let xAxis = self.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = Double(max)
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
