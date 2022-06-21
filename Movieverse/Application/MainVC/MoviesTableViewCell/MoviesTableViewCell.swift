//
//  MoviesTableViewCell.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import UIKit
import Kingfisher

class MoviesTableViewCell: UITableViewCell {
    
    static let rowHeight: CGFloat = 120
    static let identifier = "MovieTableViewCell"

    @IBOutlet weak var imgMovie: UIImageView! {
        didSet {
            imgMovie.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    var movie: MovieModel? {
        didSet {
            setData()
        }
    }
    
    var searchResult: SearchResult? {
        didSet {
            setDataWithSearch()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Setting Cell with Popular Movie
    private func setData() {
        guard let movie = movie else {
            return
        }
        lblTitle.text = movie.title
        lblOverview.text = movie.overview
        getImage(with: movie.posterPath)
    }
    
    // Setting Cell with Searched Data
    private func setDataWithSearch() {
        guard let searchResult = searchResult else { return }
        lblTitle.text = searchResult.name~.isEmpty ? searchResult.title : searchResult.name
        lblOverview.text = searchResult.overview
        getImage(with: searchResult.profilePath~.isEmpty ? searchResult.posterPath : searchResult.profilePath)
    }
    
    // Getting Image with Kingfisher
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
