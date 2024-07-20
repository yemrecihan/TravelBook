import Foundation
import CoreData
import UIKit

class HomePageViewModel {
    
    var places:[NSManagedObject] = []
    
    func fetchPlaces() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlacesModel")
        
        do {
            places = try managedContext.fetch(fetchRequest)
            
        }catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
    }
    
    func place(at index: Int)-> NSManagedObject {
        return places[index]
    }
    var count: Int {
        return places.count
    }
    func deletePlace(at index: Int) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let placeToDelete = places[index]
           managedContext.delete(placeToDelete)
           
           do {
               try managedContext.save()
               places.remove(at: index)
           } catch let error as NSError {
               print("Delete error: \(error), \(error.userInfo)")
           }
       }
}
