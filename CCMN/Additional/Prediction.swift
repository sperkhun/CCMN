//
//  Prediction.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/16/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import MachineLearningKit
import Upsurge

class Prediction {
    
    var trainingData : [Float] = []
    var trainingDataDayOfWeek : [Float] = []
    var outputData : [Float] = []
    var polynomialModel : PolynomialLinearRegression = PolynomialLinearRegression()
    var rss : Float = 0
    var weights : Matrix<Float>!
    
    func convertDateToFloat(date: Date) -> Float{
        let timeInterval = date.timeIntervalSince1970
        return (Float(timeInterval))
    }
    
    func getWeekDay(date: Date) -> Float{
        return(Float(Calendar.current.component(.weekday, from:  date)))
    }
    
    func convertStrToDate(strDate: String, dateFormatter: DateFormatter) -> Date {
        return(dateFormatter.date(from: strDate)!)
    }
    
    func buildModel(_ rawData: inout [(date: String, hour: Int, qty: Int)], completion: @escaping (Bool) -> Void)
    {
        let count = rawData.count
        var date : Date = Date()
        for i in 0...count - 1 {
            date = convertStrToDate(strDate: rawData[i].0, dateFormatter: MainData.dateFormatter)
            self.outputData.append(Float(rawData[i].2))
            self.trainingDataDayOfWeek.append(getWeekDay(date: date))
            self.trainingData.append(convertDateToFloat(date: date) / 100000)
        }
        let initial_weights = Matrix<Float>(rows: 3, columns: 1, elements: [0.8, -0.2, -30.0])
        self.weights = try! self.polynomialModel.train([self.trainingData, self.trainingDataDayOfWeek], output:  self.outputData, initialWeights: initial_weights, stepSize: Float(4e-12), tolerance: Float(1e9))
        completion(true)
    }
    
    func makePrediction(predictDate: Date) -> Int {
        let quickPrediction = polynomialModel.predict([Float(1.0), convertDateToFloat(date: predictDate) / 100000, getWeekDay(date: predictDate)], yourWeights: (self.weights.elements))
        return (Int(quickPrediction))
    }
}

