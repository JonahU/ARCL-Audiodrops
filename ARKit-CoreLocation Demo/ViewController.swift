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
import AVFoundation

class ViewController: UIViewController{
    
    let sceneLocationView = SceneLocationView()
    
    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation? //user image
    var locationEstimateAnnotation: MKPointAnnotation? //compass image
    let dropAnnotation = MKPointAnnotation() //drop image
//    let dropAdded: Bool = false
    
    var updateUserLocationTimer: Timer?
    
    var showMapView: Bool = true
    
    var headingImageView: UIImageView?
    var updateHeadingArrow: Timer?
    
    var centerMapOnUserLocation: Bool = true
    
    var displayDebugging = false
    
    var infoLabel = UILabel()
    var updateInfoLabelTimer: Timer?
    
    //MARK: -Music Player UI Elements
    @IBOutlet weak var musicPanel: UIView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var musicProgressSlider: CustomSlider!
    @IBOutlet weak var restartButton: UIButton!
    
    var musicPanelManager: MusicPanelManager!
    var audioPlayer: AVAudioPlayer!
    
    var restartButtonIsEnabled = true
    
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
//        let coordinate = CLLocationCoordinate2D(latitude: 40.7312, longitude: -73.9971)
//        let location = CLLocation(coordinate: coordinate, altitude: 0)
//        let dropLocationNode = LocationAnnotationNode(location: location, image: #imageLiteral(resourceName: "drop"))
//        addLocationNode(locationNode: dropLocationNode)
        
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
        
        setupMusicPanel()
        //view.bringSubview(toFront: restartButton) IMPLEMENT BETTER
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer.stop()
        musicPanelManager.pause()
        
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    //MARK: -Setup

    func setupMusicPanel(){
        musicPanelManager = MusicPanelManager(viewController: self)
        
        musicPanel.layer.cornerRadius = 3.0
        musicPanel.clipsToBounds = true
        musicPanel.isHidden = true
        trackLabel.text = ""
        
    }
    
    //MARK: -Adding node functions
    
    @objc func addSpecificLocationNode(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let location = CLLocation(coordinate: newCoordinates, altitude: 0)
            
            let song = allSongs[count]
            print("Count:\(count) - \(song.description)") //for DEBUG
            if count < allSongs.count - 1{
                count += 1
            } else{
                count = 0
            }
            
            let audioNode  = Drop(location: location, song: song)
            audioNode.scaleRelativeToDistance = false
            addLocationNode(locationNode: audioNode)
        }
    }
    
    //adds map pin
    func addLocationNode(locationNode: LocationNode){
        if locationNode.location != nil {
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
            if showMapView{
//                if dropAdded{
                    let annotation = MKPointAnnotation()
                    let coordinate = locationNode.location.coordinate
                    annotation.coordinate = coordinate
                    
                    let latitude = coordinate.latitude
                    let longitude = coordinate.longitude
                    annotation.title = "\(String(format: "%.4f", latitude)), \(String(format: "%.4f", longitude))"
                    mapView.addAnnotation(annotation)
//                } else{
//                    dropAnnotation.coordinate = locationNode.location.coordinate
//                    dropAnnotation.title = "Washington Square Park"
//                    mapView.addAnnotation(dropAnnotation)
//                }
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
    
    //MARK: -Gesture Recognizers
    
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
            
            guard let drop = result.node.parent else{ //fix up this code (node manager)
                fatalError("Node is not a drop")
            }
            playMusic(drop as! Drop)
        } else {
//            let pinLocationNode = LocationAnnotationNode(location: nil, image: #imageLiteral(resourceName: "pin"))
//            pinLocationNode.continuallyAdjustNodePositionWhenWithinRange = false
//            addLocationNode(locationNode: pinLocationNode)
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
    
    //MARK: -Update functions
    
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
    
    //MARK: -Play Music UI
    
    func playMusic(_ drop: Drop){
        let trackName = drop.song.title
        
        guard let url = Bundle.main.url(forResource: "\(trackName)", withExtension: "mp3") else {
            print("song url not found")
            return
        }
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.play()
            musicPanelManager.showNewMusicInfo(trackName: "\(drop.song.title)", artistName: "\(drop.song.artist)")
        } catch let error {
            print(error.localizedDescription)
        }
        

    }
}

//MARK: -Extensions

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

