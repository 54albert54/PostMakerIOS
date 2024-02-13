//
//  MapaViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/12/24.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    var posts: [BodyAP] = []
    
    @IBOutlet weak var mapContainer: UIView!
    
    
    private var map: MKMapView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    private func setMap(){
        
        map = MKMapView(frame: mapContainer.bounds)
        mapContainer.addSubview(map ?? UIView())
        setupMarkers()
        
    }
    private func setupMarkers(){
        posts.forEach { item in
            let marker = MKPointAnnotation()
            guard let latitud:Double = Double(item.latitud) ,let longitud:Double = Double(item.longitud) else{
                return
            }
            
            
            marker.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
            marker.title = item.title
            marker.subtitle = item.ownerUser
            map?.addAnnotation(marker)
        }
        // Buscamos el último post delarreglo
        guard let lastPost = posts.last else {
            return
        }
    
        guard let latitud:Double = Double(lastPost.latitud) ,let longitud:Double = Double(lastPost.longitud) else{
            return
        }
        let  lastPostLocation = CLLocationCoordinate2D(latitude: latitud,
                                                      longitude: longitud)
        
        guard let heading = CLLocationDirection (exactly: 12) else {
            return
        }
        
        
        map?.camera = MKMapCamera (lookingAtCenter: lastPostLocation, fromDistance: 30, pitch: .zero, heading: heading)
        
    }

}
