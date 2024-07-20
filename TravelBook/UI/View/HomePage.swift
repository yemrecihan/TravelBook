import UIKit

class HomePage: UIViewController {
    var tableView:UITableView!
    private var viewModel: HomePageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomePageViewModel()
        
        setupTableView()
        setupNavigationBar()
     
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPlaces()
        tableView.reloadData()
    }
    
    
    private func setupTableView() {
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource=self
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar(){
        self.title = "Home Page"
        view.backgroundColor = .white
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        let savePlacePage = SavePlacePage()
        navigationController?.pushViewController(savePlacePage, animated: true)
        
    }
        
   


}
extension HomePage: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let place = viewModel.place(at: indexPath.row) as! PlacesModel
        cell.configure(with: place)
        return cell
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPlace = viewModel.place(at: indexPath.row) 
        let placeDetailVC = PlaceDetail()
        placeDetailVC.viewModel = PlaceDetailViewModel(place: selectedPlace)
        navigationController?.pushViewController(placeDetailVC, animated: true)
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60 // Hücre yüksekliği
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                presentDeleteConfirmationAlert(forRowAt: indexPath)
            }
        }
        
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    private func presentDeleteConfirmationAlert(forRowAt indexPath: IndexPath) {
           let alert = UIAlertController(title: "Are you sure you want to delete it ?",
                                         message: "You can't undo it!",
                                         preferredStyle: .alert)
           
           let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
               self.viewModel.deletePlace(at: indexPath.row)
               self.tableView.deleteRows(at: [indexPath], with: .automatic)
           }
           
           let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
           
           alert.addAction(deleteAction)
           alert.addAction(cancelAction)
           
           present(alert, animated: true, completion: nil)
       }
    
}
