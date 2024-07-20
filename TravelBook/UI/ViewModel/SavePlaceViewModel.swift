import Foundation
import UIKit
import CoreData
import CoreLocation
import MapKit

class SavePlaceViewModel {
    
    var placeName: String?
    var placeDescription: String?
    var userLocation: CLLocationCoordinate2D?
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var updateMapWithAnnotation: ((MKPointAnnotation) -> Void)?
    
    func savePlace() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PlacesModel", in: managedContext)!
        let place = NSManagedObject(entity: entity, insertInto: managedContext)
        
        place.setValue(placeName,forKeyPath:"placeName")
        place.setValue(placeDescription, forKeyPath: "placeDescription")
        place.setValue(chosenLatitude, forKeyPath: "latitude")
        place.setValue(chosenLongitude, forKeyPath: "longitude")
        place.setValue(UUID(), forKeyPath: "id")
        
        do {
            try managedContext.save()
            print("Yer başarıyla kaydedildi.")
        }catch let error as NSError {
            print("Kaydetme hatası:\(error),\(error.userInfo)")
        }
        
    }
    func addAnnotation(for mapView: MKMapView, at coordinates: CLLocationCoordinate2D) {
           chosenLatitude = coordinates.latitude
           chosenLongitude = coordinates.longitude
           
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinates
           annotation.title = placeName
           annotation.subtitle = placeDescription
           
           updateMapWithAnnotation?(annotation)
       }
    
    
}
