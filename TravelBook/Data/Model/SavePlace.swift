
import Foundation
import CoreLocation

class SavePlace {
    var placeName:String?
    var placeDescription:String?
    var userLocation:CLLocationCoordinate2D?
    
    init(placeName: String, placeDescription: String, userLocation: CLLocationCoordinate2D) {
        self.placeName = placeName
        self.placeDescription = placeDescription
        self.userLocation = userLocation
    }
}
