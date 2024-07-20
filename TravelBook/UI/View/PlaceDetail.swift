

import UIKit
import MapKit


class PlaceDetail: UIViewController {
    
    private let placeNameLabel = UILabel()
    private let placeDescriptionLabel = UILabel()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()

    var viewModel: PlaceDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        setupContrains()
        updateUI()
        
        mapView.delegate = self

        
    }
    
    func setupViews(){
        placeNameLabel.font = UIFont.systemFont(ofSize: 20)
        placeNameLabel.textAlignment = .center
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeNameLabel)
        
        placeDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
        placeDescriptionLabel.textAlignment = .center
        placeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeDescriptionLabel)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
    }
    func setupContrains(){
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            placeNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            placeDescriptionLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 20),
            placeDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            mapView.topAnchor.constraint(equalTo: placeDescriptionLabel.bottomAnchor, constant: 50),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        
        
        ])
        }
    private func updateUI(){
        
        guard let viewModel = viewModel else { return }
        
        placeNameLabel.text = viewModel.placeName
        placeDescriptionLabel.text = viewModel.placeDescription
        
        if let latitude = viewModel.latitude, let longitude = viewModel.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = viewModel.placeName
            annotation.subtitle = viewModel.placeDescription
           
            mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) )
            mapView.setRegion(region, animated: true)
            
            
        }
        
    }
   

   

}
extension PlaceDetail: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
       if  pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
           pinView?.canShowCallout = true
           pinView?.tintColor = UIColor.black
           
           let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
           pinView?.rightCalloutAccessoryView = button
       }else {
           pinView?.annotation = annotation
       }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let latitude = viewModel?.latitude,let longitude = viewModel?.longitude else {
            return
        }
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = viewModel?.placeName
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        destinationMapItem.openInMaps(launchOptions: launchOptions)
       
    }
    
    
}
