//
//  MovieCollectionViewCell.swift
//  Movieverse
//
//  Created by Mert Gökduman on 21.06.2022.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imgMovie: UIImageView! {
        didSet {
            imgMovie.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCharacter: UILabel!
    
    var movie: PersonCast? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setData() {
        
        guard let movie = movie else { return }
        lblName.text = movie.title
        lblCharacter.text = movie.character
        getImage(with: movie.backdropPath)
    }
    
    private func getImage(with urlPath: String?) {
        
        if let urlPath = urlPath {
            let baseURL: String = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseURL + urlPath)
            imgMovie.kf.setImage(with: imageUrl)
        } else {
            imgMovie.image = UIImage(named: "empty")
        }
    }

}
