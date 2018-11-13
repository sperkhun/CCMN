//
//  ThirdViewController.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/10/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UIScrollViewDelegate {
    
    var imageFloor: UIImageView! {
        didSet {
            mapView = UIView(frame: imageFloor.frame)
            mapView.addSubview(imageFloor)
            for circle in circles {
                mapView.addSubview(circle)
            }
            self.scrollView.addSubview(mapView)
            self.scrollView.contentSize = (self.mapView.frame.size)
            self.scrollView.maximumZoomScale = 100
        }
    }
    var mapView: UIView!
    var image: UIImage?
    var circles: [UIView] = []
    var clients: [(macAddr: String, x: Int, y: Int, status: String)]? {
        didSet {
            for client in clients! {
                let rect = CGRect(x: client.x, y: client.y, width: 14, height: 14)
                let view = UIView(frame: rect)
                view.restorationIdentifier = client.macAddr
                if client.status == "ASSOCIATED" {
                    view.backgroundColor = .green
                }
                else {
                    view.backgroundColor = .red
                }
                view.layer.cornerRadius = 8
                view.clipsToBounds = true
                circles.append(view)
            }
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    var request = CiscoRequests()
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let location = sender.location(in: view)
        let results = view?.hitTest(location, with: nil)
        if let address = results?.restorationIdentifier {
            let message = "MAC " + address
            performSegue(withIdentifier: "PopupViewController", sender: message)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Total users: \(MainData.clientsInfo1stFloor.count + MainData.clientsInfo2ndFloor.count + MainData.clientsInfo3rdFloor.count) / At floor: \(circles.count)"
        self.imageFloor = UIImageView(image: image)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.minimumZoomScale = scrollView.bounds.width / (mapView?.bounds.width)!
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopupViewController" {
            let message = sender as! String
            let pvc = segue.destination as! PopupViewController
            pvc.message = message
        }
    }
    
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
