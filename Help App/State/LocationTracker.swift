//
//  LocationTracker.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import Combine
import CoreLocation

final class LocationTracker: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let standard = LocationTracker()
    
    override init() {
        super.init()
        self.cl = CLLocationManager()
        cl.delegate = self
        cl.allowsBackgroundLocationUpdates = true
        cl.pausesLocationUpdatesAutomatically = false
        cl.distanceFilter = kCLDistanceFilterNone
        cl.desiredAccuracy = kCLLocationAccuracyBest
        cl.activityType = .other
    }
    
    var cl: CLLocationManager = CLLocationManager()
    
    var lastPushedLocation: CLLocation = .init(latitude: 0, longitude: 0)
    
    func startMonitoringLocation() {
        lastPushedLocation = .init(latitude: 0, longitude: 0)
        cl.startUpdatingLocation()
    }
    
    func terminateLocationMonitoring() {
        cl.stopUpdatingLocation()
        lastPushedLocation = .init(latitude: 0, longitude: 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpLoc:)")
        
        guard UserDefaults.standard.bool(forKey: "isInHelpRequest") else {
            print("loc rec, but not in help request")
            return
        }
        
        guard let helpRequestID = UserDefaults.standard.string(forKey: "helpRequestID"),
                helpRequestID != ""
//                ,
//                let userID = UserDefaults.standard.string(forKey: "userID")
        else {
            print("no help request id string, or is empty, or no userID")
            return
        }
        
        guard let location = locations.last else {
            print("no last location")
            return
        }
        
        //determine if update is worth pushing to server
        guard location.distance(from: lastPushedLocation) > 5 else {
            print("too close:", location.distance(from: lastPushedLocation))
            return
        }
        
        print("more than 5 meters diff, pushing!")
        
        guard let socket = SocketInteractor.standard.socket, socket.status == .connected else {
            //rest api call fallback for background
            
            return
        }
    
        SocketInteractor.standard.pushLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        lastPushedLocation = location
    }
}
