//
//  Correlations.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/11/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Foundation

class Correlations {
    
    var dwellTimeCorrelation : [(fiveThirtyMin: Int, thirtySixtyMin: Int, oneFiveHour: Int, fiveEightHour: Int, eightPlusHour: Int, daysQty: Int)] = [(0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 0, 0), (0, 0, 0, 0, 0, 0)]
    
    var passersbyCorrelation : [(daysQty: Int, avQty: Int)] = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]
    var visitorsCorrelation : [(daysQty: Int, avQty: Int)] = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]
    var connectedCorrelation : [(daysQty: Int, avQty: Int)] = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]
    
    func validateTimePeriod() -> Int {
        switch MainData.timeStamp {
        case "lastweek", "last30", "thismonth", "lastmonth" :
            return 1
        case "daily" :
            if (Calendar.current.dateComponents([Calendar.Component.day], from: MainData.startDay, to: MainData.endDay).day! >= 7){
                return 1
            }
        default:
            return 0
        }
        return 0
    }
    
    func dataAnalysis(rawData: [(date: String, hour: Int, qty: Int)], _ array : inout [(daysQty: Int, avQty: Int)]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var count = rawData.count
        var weekDay : Int = 0
        var itterDate : Date?
        for i in 0...count - 1 {
            itterDate = dateFormatter.date(from: rawData[i].date)
            weekDay = Calendar.current.component(.weekday, from:  itterDate!)
            array[weekDay - 1].avQty += rawData[i].qty
            array[weekDay - 1].daysQty += 1
        }
        count = array.count
        for i in 0...count - 1 {
            array[i].avQty /= array[i].daysQty
        }
    }
    
    func dwellTimeDataAnalysis(rawData: [(String, Int, Int, Int, Int, Int, Int)]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var count = rawData.count
        var weekDay : Int = 0
        for i in 0...count - 1 {
            let itterDate = dateFormatter.date(from: rawData[i].0)
            weekDay = Calendar.current.component(.weekday, from:  itterDate!)
            dwellTimeCorrelation[weekDay - 1].0 += rawData[i].2
            dwellTimeCorrelation[weekDay - 1].1 += rawData[i].3
            dwellTimeCorrelation[weekDay - 1].2 += rawData[i].4
            dwellTimeCorrelation[weekDay - 1].3 += rawData[i].5
            dwellTimeCorrelation[weekDay - 1].4 += rawData[i].6
            dwellTimeCorrelation[weekDay - 1].5 += 1
        }
        count = dwellTimeCorrelation.count
        for i in 0...count - 1 {
            dwellTimeCorrelation[i].0 /= dwellTimeCorrelation[weekDay - 1].5
            dwellTimeCorrelation[i].1 /= dwellTimeCorrelation[weekDay - 1].5
            dwellTimeCorrelation[i].2 /= dwellTimeCorrelation[weekDay - 1].5
            dwellTimeCorrelation[i].3 /= dwellTimeCorrelation[weekDay - 1].5
            dwellTimeCorrelation[i].4 /= dwellTimeCorrelation[weekDay - 1].5
        }
    }
    
    func buildCorrelations(type: String) {
        if (validateTimePeriod() == 1) {
            switch type {
            case "passersby" :
                dataAnalysis(rawData: MainData.passersby, &passersbyCorrelation)
            case "visitors" :
                dataAnalysis(rawData: MainData.visitors, &visitorsCorrelation)
            case "connected" :
                dataAnalysis(rawData: MainData.connected, &connectedCorrelation)
            case "dwellTime" :
                dwellTimeDataAnalysis(rawData: MainData.dwellTime)
            default :
                return
            }
        }
    }
}

//var count = connectedCorrelation.count
//print("-----------------------")
//for i in 0...count - 1
//{
//    print(connectedCorrelation[i].0)
//    print(connectedCorrelation[i].1)
//    print(connectedCorrelation[i].2)
//}
//print("-----------------------")
//}

