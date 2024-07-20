

import Foundation
import CoreData
import UIKit
class PlaceDetailViewModel {
    
    private let place: NSManagedObject
    
    var placeName: String? {
        return place.value(forKey: "placeName") as? String
    }
    
    var placeDescription: String? {
        return place.value(forKey: "placeDescription") as? String
    }
    
    var latitude : Double? {
        return place.value(forKey: "latitude") as? Double
    }
    var longitude: Double? {
        return place.value(forKey: "longitude") as? Double
    }
    
    init(place: NSManagedObject) {
        self.place = place
    }
    
}
