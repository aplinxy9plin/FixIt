//
//  MapViewController.swift
//  Eateries
//
//  Created by Aleksey Kabishau on 1103..17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    var restaurant: Restaurant!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // instance of Core Location Geocoder Class
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first!
            
            // instance of MKPointAnnotation Class - pin on map
            let annotation = MKPointAnnotation()
            annotation.title = self.restaurant.name
            annotation.subtitle = self.restaurant.type
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            // presenting on the map
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        // to see Pin on the map we have to use MKPinAnnotationView, not just MKAnnotationView
        let annotationIdentifier = "restaurantAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        // if creation of annotation through the dequeueReusable method was not successful, this view should be created manually
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        // adding image to the right side of annotation
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightImage.image = UIImage(data: restaurant.image! as Data)//UIImage(named: restaurant.image)
        annotationView?.rightCalloutAccessoryView = rightImage
        
        // pin customization
        annotationView?.pinTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        return annotationView
        
    }

}
