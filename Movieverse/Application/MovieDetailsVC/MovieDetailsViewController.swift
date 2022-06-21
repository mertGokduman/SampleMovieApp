//
//  MovieDetailsViewController.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import UIKit
import Bond
import ReactiveKit
import SafariServices

class MovieDetailsViewController: BaseVC<MovieDetailsViewModel> {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 50
            bottomView.layer.zPosition = 5
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnPlay: UIButton! {
        didSet {
            btnPlay.layer.cornerRadius = 30
            btnPlay.layer.zPosition = 10
        }
    }
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var btnIMDB: UIButton! {
        didSet {
            btnIMDB.backgroundColor = .colorIMDB
            btnIMDB.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView! {
        didSet {
            castCollectionView.register(CastCollectionViewCell.self)
            castCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBlurView(for: bottomView)
        buttonBindings()
        collectionViewCellSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading()
        viewModel.pageOpened()
    }
    
    // Binding MovieDetail Data
    override func bind() {
        
        viewModel.movieDetails.observeNext { [weak self] movie in
            guard let self = self,
                  let movie = movie else { return }
            self.viewModel.getImages(to: self.imgMovie)
            self.lblMovieTitle.text = movie.title~ + " " + "\(movie.releaseDate~.getYearValue())"
            self.lblGenre.text = self.viewModel.getGenreString() + " - " + self.viewModel.getRuntime()
            self.lblReleaseDate.text = movie.releaseDate~.getDate()
            self.lblOverview.text = movie.overview~
            self.btnIMDB.setTitle("IMDB  \(movie.voteAverage~)", for: .normal)
        }.dispose(in: bag)
        
        viewModel.alert.observeNext { [weak self] alert in
            guard let self = self else { return }
            self.showAlert(alert: alert)
            self.stopLoading()
        }.dispose(in: bag)
    }
    
    // Binding Colelctionview
    private func bindCollectionView() {
        
        viewModel.movieCast.bind(to: castCollectionView) { cast , indexpath, collectionview -> UICollectionViewCell in
            let cell = self.castCollectionView.dequeueCell(CastCollectionViewCell.self, forIndexPath: indexpath)
            cell.person = cast[indexpath.row]
            return cell
        }
        castCollectionView.reactive.selectedItemIndexPath.map { $0.row }.bind(to: viewModel.selectedIndex).dispose(in: bag)
    }
    
    // Button Bindings
    private func buttonBindings() {
        btnBack.reactive.tap.bind(to: self) { $0.viewModel.btnClosePressed() }.dispose(in: bag)
        btnPlay.reactive.tap.bind(to: self) { $0.viewModel.btnPlayPressed() }.dispose(in: bag)
        btnWebsite.reactive.tap.bind(to: self) { $0.viewModel.btnWebPressed() }.dispose(in: bag)
        btnIMDB.reactive.tap.bind(to: self) { $0.viewModel.btnIMDBPressed() }.dispose(in: bag)
    }
    
    // Cast CollectionView Cell Pressed
    private func collectionViewCellSelected() {
        viewModel.selectedIndex.observeNext { [weak self] index in
            guard let index = index,
                  let self = self else { return }
            self.viewModel.collectionViewCellPressed(index: index)
        }.dispose(in: bag)
    }
    
    // MovieDetailsVC States
    override func onStateChanged(_ state: ViewState) {
        guard let state = state as? MovieDetailsViewState else { return }
        switch state {
        case .movieDetailsCame:
            bind()
        case .castDataCame:
            bindCollectionView()
            stopLoading()
        case .openWebView(let urlString):
            guard let url = URL(string: urlString) else { return }
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        case .openCastDetail(let id):
            presentToCastVC(for: id)
        case .dismissPage:
            self.dismiss(animated: true)
        }
    }
    
    // Present to CastDetailVC
    private func presentToCastVC(for id: Int) {
        let vc = CastDetailsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.viewModel.personID.value = id
        self.present(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 200)
    }
}
