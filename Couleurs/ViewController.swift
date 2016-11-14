//
//  ViewController.swift
//  Couleurs
//
//  Created by Kamel Makhloufi on 22/09/2015.
//  Copyright © 2015 Kamel Makhloufi. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var progress: UISlider!
    
    var locationManager:CLLocationManager = CLLocationManager()
    var location:CLLocation!
    var newAlt:Int = 450
    var oldAlt:Int = 450
    let colors = Colors()
    
    override func viewDidLoad() {
        self.locationManager.distanceFilter  = 1
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        Timer.scheduledTimer(timeInterval: 1.0/60, target:self, selector:#selector(ViewController.updateTextLabel), userInfo:nil, repeats: true)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
            
        case .authorizedAlways:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    func updateTextLabel() {
        self.altitudeLabel.text = "\(Int(self.progress.value))"
    }
    
    func refresh(_ altitude:Int) {
        UIView.animate(withDuration: 1.2,
            delay:1.0,
            options: UIViewAnimationOptions(),
            animations: {
                self.progress.setValue(Float(altitude), animated: true)
                self.view.backgroundColor = self.colors.img.getPixelColorAtLocation(CGPoint(x: 0, y: CGFloat(altitude)))
            },
            completion: {
                (finished: Bool) -> Void in
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        let alt = Int(ceil(location.altitude))
        //altitudeLabel.text = "\(alt)"
        refresh(alt)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
}

