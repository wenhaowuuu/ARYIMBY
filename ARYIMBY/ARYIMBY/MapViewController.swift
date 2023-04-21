//
//  MapViewController.swift
//  ARYIMBY
//
//  Created by Wenhao Wu on 4/9/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set up map view
        mapView.delegate = self
        
        //add markers
        let marker1 = MKPointAnnotation()
        marker1.coordinate = CLLocationCoordinate2D(latitude: 37.795844, longitude: -122.265470)
        marker1.title = "Site 1: Lake Merritt BART station site"
        marker1.subtitle = "69 7th St, Oakland, CA 94607"
        mapView.addAnnotation(marker1)
        
        //these site points are not built out
        let marker2 = MKPointAnnotation()
        marker2.coordinate = CLLocationCoordinate2D(latitude: 37.936237, longitude: -122.35373037)
        marker2.title = "Site 2: Richmond Bus Yard site"
        marker2.subtitle = "16Th St, Richmond, CA 94801"
        mapView.addAnnotation(marker2)
        
        let marker3 = MKPointAnnotation()
        marker3.coordinate = CLLocationCoordinate2D(latitude: 37.497801, longitude: -121.936625)
        marker3.title = "Site 3: Warm Springs Blvd Parking Lot site"
        marker3.subtitle = "Warm Springs Blvd, Fremont, CA 94539"
        mapView.addAnnotation(marker3)
        
        let marker4 = MKPointAnnotation()
        marker4.coordinate = CLLocationCoordinate2D(latitude: 37.720211, longitude: -122.447410)
        marker4.title = "Site 4: Balboa Park Station Triangle site"
        marker4.subtitle = "2340 San Jose Avenue, San Francisco, CA 94112"
        mapView.addAnnotation(marker4)
        
        
        //Center map on markers
        let markers = [marker1, marker2, marker3, marker4]
        var zoomRect = MKMapRect.null
        for marker in markers {
            let point = MKMapPoint(marker.coordinate)
            let rect = MKMapRect(x:point.x, y:point.y, width:0.1, height: 0.1)
            zoomRect = zoomRect.union(rect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top:100, left:100, bottom:100, right:100), animated: true)
        
    }
    
    //User Interaction: marker tap event
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let alert = UIAlertController(title: view.annotation?.title ?? "", message: view.annotation?.subtitle ?? "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
