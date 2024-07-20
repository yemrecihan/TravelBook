import Foundation
import CoreData
import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    let placeNameLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        //placeNameLabel
        placeNameLabel.font = UIFont.systemFont(ofSize: 20)
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(placeNameLabel)
        
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            placeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15),
            placeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            placeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10)
        ])
    }
    func configure(with place: NSManagedObject) {
        placeNameLabel.text = place.value(forKey: "placeName") as? String
    }
}
