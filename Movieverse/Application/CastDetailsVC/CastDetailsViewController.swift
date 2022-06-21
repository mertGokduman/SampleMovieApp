//
//  CastDetailsViewController.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import UIKit
import Bond
import ReactiveKit
import SafariServices

class CastDetailsViewController: BaseVC<CastDetailsViewModel> {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 50
            bottomView.layer.zPosition = 5
        }
    }
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnIMDB: UIButton! {
        didSet {
            btnIMDB.backgroundColor = .colorIMDB
            btnIMDB.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var lblBiography: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView! {
        didSet {
            moviesCollectionView.register(MovieCollectionViewCell.self)
            moviesCollectionView.delegate = self
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
    
    override func bind() {
        viewModel.personDetails.observeNext { [weak self] person in
            guard let self = self,
                  let person = person else { return }
            self.viewModel.getImages(to: self.imgPerson)
            self.lblName.text = person.name~
            self.lblBirthday.text = person.birthday?.getDate()
            self.lblBiography.text = person.biography~
        }.dispose(in: bag)
        
        viewModel.alert.observeNext { [weak self] alert in
            guard let self = self else { return }
            self.showAlert(alert: alert)
            self.stopLoading()
        }.dispose(in: bag)
    }
    
    private func bindCollectionView() {
        
        viewModel.movieCast.bind(to: moviesCollectionView) { cast , indexpath, collectionview -> UICollectionViewCell in
            let cell = self.moviesCollectionView.dequeueCell(MovieCollectionViewCell.self, forIndexPath: indexpath)
            cell.movie = cast[indexpath.row]
            return cell
        }
        moviesCollectionView.reactive.selectedItemIndexPath.map { $0.row }.bind(to: viewModel.selectedIndex).dispose(in: bag)
    }
    
    private func buttonBindings() {
        btnBack.reactive.tap.bind(to: self) { $0.viewModel.btnClosePressed() }.dispose(in: bag)
        btnWeb.reactive.tap.bind(to: self) { $0.viewModel.btnWebPressed() }.dispose(in: bag)
        btnIMDB.reactive.tap.bind(to: self) { $0.viewModel.btnIMDBPressed() }.dispose(in: bag)
    }
    
    private func collectionViewCellSelected() {
        viewModel.selectedIndex.observeNext { [weak self] index in
            guard let index = index,
                  let self = self else { return }
            self.viewModel.collectionViewCellPressed(index: index)
        }.dispose(in: bag)
    }
    
    override func onStateChanged(_ state: ViewState) {
        guard let state = state as? CastDetailsViewState else { return }
        switch state {
        case .personDetail:
            bind()
        case .movieCast:
            bindCollectionView()
            stopLoading()
        case .openWebView(let urlString):
            guard let url = URL(string: urlString) else { return }
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        case .openMovieDetail(let id):
            presentToMovieDetailVC(for: id)
        case .dismissPage:
            self.dismiss(animated: true)
        }
    }
    
    private func presentToMovieDetailVC(for id: Int) {
        let vc = MovieDetailsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.viewModel.movieID.value = id
        self.present(vc, animated: true)
    }
}

extension CastDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
    }
}
