//
//  HomeViewController.swift
//  Login
//
//  Created by Mohamed Gamal on 8/7/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMaps
import GooglePlaces

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didPressLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressDetails(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        navigationController?.pushViewController(view, animated: true)
    }
    
}

  
