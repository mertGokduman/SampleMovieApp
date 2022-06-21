//
//  CastCollectionViewCell.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CastCell"
    
    @IBOutlet weak var imgPerson: UIImageView! {
        didSet {
            imgPerson.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    var person: MovieCast? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Set Cell with Person Data
    private func setData() {
        
        guard let person = person else { return }
        lblName.text = person.name
        getImage(with: person.profilePath)
    }
    
    // Get Image with Kingfisher
    private func getImage(with urlPath: String?) {

        if let urlPath = urlPath {
            let baseURL: String = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseURL + urlPath)
            imgPerson.kf.setImage(with: imageUrl)
        } else {
            imgPerson.image = UIImage(named: "empty")
        }
    }
}
