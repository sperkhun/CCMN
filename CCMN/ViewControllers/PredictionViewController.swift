//
//  PredictionViewController.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/18/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

class PredictionViewController: UIViewController {
    
    @IBOutlet weak var visitorsPred: UILabel!
    
    @IBOutlet weak var passersbyPred: UILabel!
    @IBOutlet weak var connectedPred: UILabel!
    @IBAction func predictionDayPicker(_ sender: UIDatePicker) {
        MainData.predictDate =  sender.date
        makePredictions()
    }
    @IBOutlet weak var visitorsPredView: SimpleLineChart!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var passersbyPredView: SimpleLineChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.backgroundColor = UIColor(red:0.94, green:0.61, blue:0.22, alpha:1.0)
        datePicker.setValue(UIColor.white, forKey: "textColor")
        makePredictions()
        visitorsPredView.setGroupChart(type: ["visitors", "connected"], rawData: [MainData.visualVisitorsPrediction, MainData.visualConnectedPrediction], dataPoints: MainData.predictionX)
        passersbyPredView.setGroupChart(type: ["passersby"], rawData: [MainData.visualPassersbyPrediction], dataPoints: MainData.predictionX)
    }

    @objc func makePredictions() {
        MainData.visitorsPredicted = StatisticsViewController.visitorsPrediction.makePrediction(predictDate: MainData.predictDate)
        MainData.passersbyPredicted = StatisticsViewController.passersbyPrediction.makePrediction(predictDate: MainData.predictDate)
        MainData.connectedPredicted = StatisticsViewController.connectedPrediction.makePrediction(predictDate: MainData.predictDate)
        visitorsPred.text = String(MainData.visitorsPredicted)
        passersbyPred.text = String(MainData.passersbyPredicted)
        connectedPred.text = String(MainData.connectedPredicted)
    }
}
