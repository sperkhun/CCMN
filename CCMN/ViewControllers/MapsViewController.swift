//
//  MapsViewController.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/10/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController, UIScrollViewDelegate {
    
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
    var floor: String!
    var clients: [(macAddr: String, x: Int, y: Int, status: String)]? {
        didSet {
            for client in clients! {
                let rect = CGRect(x: client.x, y: client.y, width: 10, height: 10)
                let view = UIView(frame: rect)
                if client.status == "ASSOCIATED" {
                    view.backgroundColor = UIColor(red:0.49, green:0.72, blue:0.27, alpha:0.5)
                    view.layer.borderColor = UIColor(red:0.49, green:0.72, blue:0.27, alpha:1.0).cgColor
                    view.restorationIdentifier = "\(client.macAddr) ASSOCIATED"
                }
                else {
                    view.backgroundColor = UIColor(red:0.96, green:0.71, blue:0.70, alpha:0.5)
                    view.layer.borderColor = UIColor(red:0.96, green:0.71, blue:0.70, alpha:1.0).cgColor
                    view.restorationIdentifier = "\(client.macAddr) UNASSOCIATED"
                }
                view.layer.borderWidth = 2
                view.layer.cornerRadius = 5
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
        self.title = "Total users: \(MainData.clientsInfo1stFloor.count + MainData.clientsInfo2ndFloor.count + MainData.clientsInfo3rdFloor.count) / \(floor!): \(circles.count)"
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
            pvc.custom = false
            pvc.message = message
        }
    }
}
