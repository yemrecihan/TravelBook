import UIKit
import CoreLocation
import MapKit

class SavePlacePage: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let placeNameTextField = UITextField()
    private let placeDescriptionTextField = UITextField()
    private let mapView = MKMapView()
    private let saveButton = UIButton(type: .system)
    private let locationManager = CLLocationManager()
    
    var viewModel: SavePlaceViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Save Place"
        viewModel = SavePlaceViewModel()
        
        viewModel?.updateMapWithAnnotation = { [weak self] annotation in
                   self?.mapView.addAnnotation(annotation)
               }
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self // MapView delegate ayarlandı
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupLocationManager()
    }
    
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            viewModel?.placeName = placeNameTextField.text // TextField'dan placeName'i al
            viewModel?.placeDescription = placeDescriptionTextField.text // TextField'dan placeDescription'ı al
            viewModel?.addAnnotation(for: mapView, at: touchedCoordinates)
            }
        
        
        
        
    }
    
    func setupViews() {
        placeNameTextField.placeholder = "Enter Place Name"
        placeNameTextField.borderStyle = .roundedRect
        placeNameTextField.textAlignment = .center
        placeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeNameTextField)
        
        placeDescriptionTextField.placeholder = "Enter Description"
        placeDescriptionTextField.borderStyle = .roundedRect
        placeDescriptionTextField.textAlignment = .center
        placeDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeDescriptionTextField)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            placeNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            placeNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              
            placeDescriptionTextField.topAnchor.constraint(equalTo: placeNameTextField.bottomAnchor, constant: 20),
            placeDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              
            mapView.topAnchor.constraint(equalTo: placeDescriptionTextField.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Konsola log ekleyelim
        print("Location manager started updating location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            viewModel?.userLocation = coordinate
            
            // Konum güncelleme logu
            print("Location updated: \(coordinate.latitude), \(coordinate.longitude)")
            
            // Harita merkezleme logu
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            mapView.setRegion(region, animated: true)
            print("Map centered to: \(coordinate.latitude), \(coordinate.longitude)")
            
          
            
            
            locationManager.stopUpdatingLocation() // Konum güncellemelerini durdur
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
    
    @objc func saveButtonTapped() {
        viewModel?.placeName = placeNameTextField.text
        viewModel?.placeDescription = placeDescriptionTextField.text
        viewModel?.savePlace()
        //Kayıt işlemi gerçekleştikten sonra HomePage'e dön.
        navigationController?.popViewController(animated: true)
    }
}

