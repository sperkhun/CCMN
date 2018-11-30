//
//  CorrelationViewController.swift
//  CCMN
//
//  Created by Nadiia KUCHYNA on 11/14/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

class CorrelationViewController: UIViewController {

    @IBOutlet weak var passersbyCorrView: StatisticBar!
    @IBOutlet weak var passersbyLabel: UILabel!
    @IBOutlet weak var connectedCorrView: StatisticBar!
    @IBOutlet weak var connectedLabel: UILabel!
    var timer: Timer!
    @IBOutlet weak var visitorsCorrView: StatisticBar!
    @IBOutlet weak var visitorsLabel: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var dwellTimeCorrView: StatisticBar!
    @IBOutlet weak var dwellTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(buildCorrelations), userInfo: nil, repeats: true)
    }
    
    @objc func buildCorrelations() {
        info.isHidden = true
        passersbyLabel.isEnabled = true
        connectedLabel.isEnabled = true
        visitorsLabel.isEnabled = true
        dwellTimeLabel.isEnabled = true
        if (StatisticsViewController.correlations.validateTimePeriod() != 1 ) {
            info.isHidden = false
            passersbyLabel.isEnabled = false
            connectedLabel.isEnabled = false
            visitorsLabel.isEnabled = false
            dwellTimeLabel.isEnabled = false
        }
        if (MainData.reloadCorr == 1) {
            passersbyCorrView.setChart(type: "passersby", rawData: StatisticsViewController.correlations.passersbyCorrelation, dataPoints: MainData.dataPoints)
            connectedCorrView.setChart(type: "connected", rawData: StatisticsViewController.correlations.connectedCorrelation, dataPoints: MainData.dataPoints)
            visitorsCorrView.setChart(type: "visitors", rawData: StatisticsViewController.correlations.visitorsCorrelation, dataPoints: MainData.dataPoints)
            dwellTimeCorrView.setGroupChart(rawData: StatisticsViewController.correlations.dwellTimeCorrelation)
            MainData.reloadCorr = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
