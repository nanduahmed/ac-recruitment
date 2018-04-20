//
//  MapDetailViewController.swift
//  Realtor
//
//  Created by Nandu Ahmed on 4/19/18.
//  Copyright © 2018 Baabul Ilm. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController {
    
    var coordinates:CLLocationCoordinate2D?
    var displayMultiple:Bool = false
    

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showPins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showPins() {
        var annonations = [MKPointAnnotation]()
        if (displayMultiple) {
            let places = Models.shared.all
            for place in places {
                if let location = place.coordinates{
                    let annonation = self.addPin(coordinates: location)
                    annonations.append(annonation)
                }
            }
            
        } else {
            if let location = self.coordinates {
                let annonation = self.addPin(coordinates: location)
                annonations.append(annonation)            }
        }
        
        self.mapView.showAnnotations(annonations, animated: true)
    }
    
    /* Method for setting region
    private func addPin(coordinates:CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        if (!self.displayMultiple) {
            let region = MKCoordinateRegion(center:coordinates, span:span)
            self.mapView.setRegion(region, animated: true)
        }
        self.mapView.addAnnotation(pin)
    }*/
    
    private func addPin(coordinates:CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        return pin
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
