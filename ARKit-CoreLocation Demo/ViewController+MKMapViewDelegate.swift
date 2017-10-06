//
//  ViewController+MKMapViewDelegate.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/12/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    //MARK: -MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if pointAnnotation == self.userAnnotation {
                marker.displayPriority = .required
                marker.glyphImage = UIImage(named: "user")
            } else if pointAnnotation == self.dropAnnotation {
                marker.displayPriority = .required
                marker.glyphImage = UIImage(named: "drop")
            }else if pointAnnotation == self.locationEstimateAnnotation {
                marker.displayPriority = .required
                marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
                marker.glyphImage = UIImage(named: "compass")
            } else {
                marker.displayPriority = .required
                marker.glyphImage = UIImage(named: "audio")
            }
            
            return marker
        }
        
        return nil
    }
    
    //MARK: Orientation Indicator (blue arrow) funcs
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if views.last?.annotation is MKUserLocation {
            addHeadingView(toAnnotationView: views.last!)
        }
    }
    
    func addHeadingView(toAnnotationView annotationView: MKAnnotationView){
        if headingImageView == nil{
            let image = UIImage(named: "bluearrow")
            headingImageView = UIImageView(image: image)
            headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - (image?.size.width)!)/2,
                                             y: (annotationView.frame.size.height - (image?.size.height)!)/2,
                                             width: (image?.size.width)!,
                                             height: (image?.size.height)!)
            annotationView.insertSubview(headingImageView!, at: 0)
            headingImageView!.isHidden = true
        }
    }
    
}
