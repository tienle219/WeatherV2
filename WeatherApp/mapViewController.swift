//
//  mapViewController.swift
//  WeatherApp
//
//  Created by Tien Le on 4/18/17.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class mapViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap{

    var googleMapsView: GMSMapView!
    var seachResultCtroller: SearchResultsController!
    var resultsArray = [String]()
    
    @IBOutlet weak var tabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self

        // Do any additional setup after loading the view.
    }

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.googleMapsView = GMSMapView(frame: self.ggmapContainer.frame)
        self.view.addSubview(self.googleMapsView)
        seachResultCtroller = SearchResultsController()
        seachResultCtroller.delegate = self
        
    }
    @IBOutlet weak var ggmapContainer: UIView!
    
    
    @IBAction func searchWithAddress(_ sender: Any) {
        let seachController = UISearchController(searchResultsController: seachResultCtroller)
        seachController.searchBar.delegate = self
        self.present(seachController, animated: true, completion: nil)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
            self.googleMapsView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView
            
        }

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil)  {(results, error: Error?) -> Void in
                        self.resultsArray.removeAll()
                        if results == nil {
                            return
                        }
            
                        for result in results! {
                            if let result = result as? GMSAutocompletePrediction {
                                self.resultsArray.append(result.attributedFullText.string)
                            }
                        }
                    self.seachResultCtroller.reloadDataWithArray(self.resultsArray)
                    }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension mapViewController : UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
        }
        else if item.tag == 1 {
            let actionSheet = UIAlertController(title: "Kiểu bản đồ", message: "Chọn một kiểu bản đồ:", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.googleMapsView.mapType = .normal
            }
            
            let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.googleMapsView.mapType = .terrain
            }
            
            let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.googleMapsView.mapType =  .hybrid
                
            }
            let satelliteMapTypeAction = UIAlertAction(title: "Satallite", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.googleMapsView.mapType =  .satellite
                
            }
            
            
            let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                
            }
            
            actionSheet.addAction(normalMapTypeAction)
            actionSheet.addAction(terrainMapTypeAction)
            actionSheet.addAction(satelliteMapTypeAction)
            actionSheet.addAction(hybridMapTypeAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)        }
    }
    
}
