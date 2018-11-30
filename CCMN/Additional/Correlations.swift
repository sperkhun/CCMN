//
//  Correlations.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/11/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import Foundation

class Correlations {
    
    var dwellTimeCorrelation : [(fiveThirtyMin: Int, thirtySixtyMin: Int, oneFiveHour: Int, fiveEightHour: Int, eightPlusHour: Int, daysQty: Int)] = Array(repeating: (0, 0, 0, 0, 0, 0), count: 7)
    
    var passersbyCorrelation : [(daysQty: Int, avQty: Int)] = Array(repeating: (0, 0), count: 7)
    var visitorsCorrelation : [(daysQty: Int, avQty: Int)] = Array(repeating: (0, 0), count: 7)
    var connectedCorrelation : [(daysQty: Int, avQty: Int)] = Array(repeating: (0, 0), count: 7)
    
    func validateTimePeriod() -> Int {
        switch MainData.timeStamp {
        case "Last 7 days", "Last 30 days", "This month", "Last month" :
            return 1
        case "Custom" :
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
    
    func clearArray(_ array : inout [(daysQty: Int, avQty: Int)])
    {
        let count = array.count
        for i in 0...count - 1 {
            array[i].0 = 0
            array[i].1 = 0
        }
    }
    
    func clearDwellTimeArray(_ array : inout [(fiveThirtyMin: Int, thirtySixtyMin: Int, oneFiveHour: Int, fiveEightHour: Int, eightPlusHour: Int, daysQty: Int)])
    {
        let count = array.count
        for i in 0...count - 1 {
            array[i].0 = 0
            array[i].1 = 0
            array[i].2 = 0
            array[i].3 = 0
            array[i].4 = 0
            array[i].5 = 0
        }
    }
    
    func buildCorrelations(type: String) {
    
        if (validateTimePeriod() == 1) {
            switch type {
            case "passersby" :
                clearArray(&passersbyCorrelation)
                dataAnalysis(rawData: MainData.passersby, &passersbyCorrelation)
            case "visitors" :
                clearArray(&visitorsCorrelation)
                dataAnalysis(rawData: MainData.visitors, &visitorsCorrelation)
            case "connected" :
                clearArray(&connectedCorrelation)
                dataAnalysis(rawData: MainData.connected, &connectedCorrelation)
            case "dwellTime" :
                clearDwellTimeArray(&dwellTimeCorrelation)
                dwellTimeDataAnalysis(rawData: MainData.dwellTime)
            default :
                return
            }
        }
        else {
            clearArray(&passersbyCorrelation)
            clearArray(&visitorsCorrelation)
            clearArray(&connectedCorrelation)
            clearDwellTimeArray(&dwellTimeCorrelation)
        }
    }
}
