//
//  ViewController.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 8/30/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import SceneKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    let sceneLocationView = SceneLocationView()
    
    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation? //user image
    var locationEstimateAnnotation: MKPointAnnotation? //compass image
    let dropAnnotation = MKPointAnnotation() //drop image
    var dropAdded: Bool = false
    
    var updateUserLocationTimer: Timer?
    
    var showMapView: Bool = true
    
    var headingImageView: UIImageView?
    var updateHeadingArrow: Timer?
    
    var centerMapOnUserLocation: Bool = true
    
    var displayDebugging = false
    
    var infoLabel = UILabel()
    var updateInfoLabelTimer: Timer?
    
    private var allSongs: [Song] = LibraryAPI.shared.getSongs()
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = .left
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
        sceneLocationView.addSubview(infoLabel)
        
        updateInfoLabelTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                    target: self,
                                                    selector: #selector(ViewController.updateInfoLabel),
                                                    userInfo: nil,
                                                    repeats: true)
        
        sceneLocationView.showAxesNode = false
        
        if displayDebugging {
            sceneLocationView.showFeaturePoints = true
        }
        
        //Location: Washington Square Park
        let coordinate = CLLocationCoordinate2D(latitude: 40.7312, longitude: -73.9971)
        let location = CLLocation(coordinate: coordinate, altitude: 0)
        let dropLocationNode = LocationAnnotationNode(location: location, image: #imageLiteral(resourceName: "drop"))
        addLocationNode(locationNode: dropLocationNode)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneLocationView.addGestureRecognizer(tapGesture)
        
        view.addSubview(sceneLocationView)
        
        if showMapView {
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.alpha = 0.7
            view.addSubview(mapView)
            
            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addSpecificLocationNode))
            longPressGR.minimumPressDuration = 1.5
            mapView.addGestureRecognizer(longPressGR)
            
            updateUserLocationTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                                           target: self,
                                                           selector: #selector(ViewController.updateUserLocation),
                                                           userInfo: nil,
                                                           repeats: true)
            
            updateHeadingArrow = Timer.scheduledTimer(timeInterval: 0.1,
                                                      target: self,
                                                      selector: #selector(ViewController.updateHeadingRotation),
                                                      userInfo: nil,
                                                      repeats: true)
        }
    }
    
    
    @objc func addSpecificLocationNode(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let location = CLLocation(coordinate: newCoordinates, altitude: 0)
            //let locationNode = LocationAnnotationNode(location: location, image: #imageLiteral(resourceName: "pin"))
            
            let song = allSongs[count]
            count += count
            let audioNode  = AudioDrop(location: location, song: song)
            audioNode.scaleRelativeToDistance = false
//            addLocationNode(locationNode: locationNode)
            addLocationNode(locationNode: audioNode)
        }
    }
    
    //adds map pin
    func addLocationNode(locationNode: LocationNode){
        if locationNode.location != nil {
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
            if showMapView{
                if dropAdded{
                    let annotation = MKPointAnnotation()
                    let coordinate = locationNode.location.coordinate
                    annotation.coordinate = coordinate
                    
                    let latitude = coordinate.latitude
                    let longitude = coordinate.longitude
                    annotation.title = "\(String(format: "%.4f", latitude)), \(String(format: "%.4f", longitude))"
                    mapView.addAnnotation(annotation)
                } else{
                    dropAnnotation.coordinate = locationNode.location.coordinate
                    dropAnnotation.title = "Washington Square Park"
                    mapView.addAnnotation(dropAnnotation)
                    dropAdded = true
                }
            }
        }else{
            sceneLocationView.addLocationNodeForCurrentPosition(locationNode: locationNode)
            if showMapView{
                let annotation = MKPointAnnotation()
                annotation.coordinate = (sceneLocationView.currentLocation()?.coordinate)! //discrepancy with constantly updating nodes within 100m
                annotation.title = "Current Location Node"
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //sceneLocationView.frame = view.bounds
        sceneLocationView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
        
        infoLabel.frame = CGRect(x: 6,
                                 y: 0,
                                 width: self.view.frame.size.width - 12,
                                 height: 14 * 4)
        
        if showMapView {
            infoLabel.frame.origin.y = (self.view.frame.size.height / 2) - infoLabel.frame.size.height
        } else {
            infoLabel.frame.origin.y = self.view.frame.size.height - infoLabel.frame.size.height
        }
        
        mapView.frame = CGRect(x: 0,
                               y: self.view.frame.size.height / 2,
                               width: self.view.frame.size.width,
                               height: self.view.frame.size.height / 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer){
        //check what nodes are tap
        let p = gestureRecognize.location(in: sceneLocationView)
        let hitResults = sceneLocationView.hitTest(p, options: [:])
        
        //check that we clicked on at least one object
        if hitResults.count > 0 {
            //retrieved the first clicked object
            let result = hitResults[0]
            
            //get its material
            let material = result.node.geometry!.firstMaterial!
            
            //highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            //on completetion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        } else {
            let pinLocationNode = LocationAnnotationNode(location: nil, image: #imageLiteral(resourceName: "pin"))
            pinLocationNode.continuallyAdjustNodePositionWhenWithinRange = false
            addLocationNode(locationNode: pinLocationNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != nil {
                if (mapView == touch.view! || mapView.recursiveSubviews().contains(touch.view!)) {
                    centerMapOnUserLocation = false
                } else {
                    //let pinLocationNode = LocationAnnotationNode(location: nil, image: #imageLiteral(resourceName: "pin"))
                    //addLocationNode(locationNode: pinLocationNode)
                }
            }
        }
        
    }
    
    @objc func updateInfoLabel(){
        if let position = sceneLocationView.currentScenePosition() {
            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
        }
        
        if let eulerAngles = sceneLocationView.currentEulerAngles(){
            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
        }
        
        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
        }
        
        let date = Date()
        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
        }
    }
    
    @objc func updateUserLocation(){
        if let currentLocation = sceneLocationView.currentLocation() {
            DispatchQueue.main.async {
                if self.userAnnotation == nil {
                    self.userAnnotation = MKPointAnnotation()
                    //self.mapView.addAnnotation(self.userAnnotation!)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.userAnnotation?.coordinate = currentLocation.coordinate
                }, completion: nil)
                
                if self.centerMapOnUserLocation {
                    UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                    }, completion: {
                        _ in
                        self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                    })
                }
                
                if self.displayDebugging{
                    let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate()
                    
                    if bestLocationEstimate != nil {
                        if self.locationEstimateAnnotation == nil {
                            self.locationEstimateAnnotation = MKPointAnnotation()
                            self.mapView.addAnnotation(self.locationEstimateAnnotation!)
                        }
                        
                        self.locationEstimateAnnotation!.coordinate = bestLocationEstimate!.location.coordinate
                    } else {
                        if self.locationEstimateAnnotation != nil {
                            self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
                            self.locationEstimateAnnotation = nil
                        }
                    }
                }
                
            }
        }
    }
    
    @objc func updateHeadingRotation() {
        DispatchQueue.main.async {
            if let heading = self.sceneLocationView.locationManager.heading,
                let headingImageView = self.headingImageView {
                headingImageView.isHidden = false
                let rotation = CGFloat(heading/180 * .pi)
                headingImageView.transform = CGAffineTransform(rotationAngle: rotation)
            }
        }
    }
    
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

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}

