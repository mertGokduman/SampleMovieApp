//
//  MainViewController.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import UIKit
import Bond
import ReactiveKit

class MainViewController: BaseVC<MainViewModel> {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var tfSearch: UITextField! {
        didSet {
            tfSearch.setSearchBar()
            tfSearch.delegate = self
        }
    }
    @IBOutlet weak var lblPopularMovies: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(MoviesTableViewCell.self)
            tableView.rowHeight = MoviesTableViewCell.rowHeight
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.separatorColor = .clear
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        }
    }
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            searchTableView.register(MoviesTableViewCell.self)
            searchTableView.rowHeight = MoviesTableViewCell.rowHeight
            searchTableView.contentInsetAdjustmentBehavior = .never
            searchTableView.separatorColor = .clear
            if #available(iOS 15.0, *) {
                searchTableView.sectionHeaderTopPadding = 0
            }
        }
    }
    @IBOutlet weak var tableViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var searchTableViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var imgEmpty: UIImageView! {
        didSet {
            imgEmpty.layer.shadowColor = UIColor.white.cgColor
            imgEmpty.layer.shadowOpacity = 0.25
            imgEmpty.layer.shadowRadius = 10
            imgEmpty.layer.shadowOffset = CGSize(width: 0, height: 10)
            imgEmpty.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var lblEmpty: UILabel! {
        didSet {
            lblEmpty.layer.shadowColor = UIColor.white.cgColor
            lblEmpty.layer.shadowOpacity = 0.25
            lblEmpty.layer.shadowRadius = 10
            lblEmpty.layer.shadowOffset = CGSize(width: 0, height: 10)
            lblEmpty.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCellPressed()
        searchTableCellPressed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading()
        viewModel.pageOpened()
    }
    
    // Binding Popular Movies TableView
    override func bind() {
        
        viewModel.popularResults.bind(to: tableView) { movie, indexpath, tableview -> UITableViewCell in
            let cell = tableview.dequeueCell(MoviesTableViewCell.self, forIndexPath: indexpath)
            cell.movie = movie[indexpath.row]
            cell.selectionStyle = .none
            return cell
        }
        tableView.reactive.selectedRowIndexPath.map { $0.row }.bind(to: viewModel.selectedTableIndex).dispose(in: bag)
        viewModel.popularResults.dropFirst(1).observeNext { [weak self] list in
            if list.collection.count != 0 {
                self?.tableViewHeightConstrait.constant = CGFloat(list.collection.count) * MoviesTableViewCell.rowHeight
            }
        }.dispose(in: bag)
        
        // Alert Present
        viewModel.alert.observeNext { [weak self] alert in
            guard let self = self else { return }
            self.stopLoading()
            self.showAlert(alert: alert)
            self.imgEmpty.isHidden = false
            self.lblEmpty.isHidden = false
        }.dispose(in: bag)
    }
    
    //Binding Search TableView
    private func bindSearchTableView() {
        
        if viewModel.totalSearchedResult == 0 {
            searchTableViewHeightConstrait.constant = 0
            imgEmpty.isHidden = false
            lblEmpty.text = "The movies or people you're looking for do not seem to exit!"
            lblEmpty.isHidden = false
        } else {
            imgEmpty.isHidden = true
            lblEmpty.isHidden = true
        }
        
        viewModel.searchResults.bind(to: searchTableView) { searchData, indexpath, searchtable -> UITableViewCell in
            let cell = searchtable.dequeueCell(MoviesTableViewCell.self, forIndexPath: indexpath)
            cell.searchResult = searchData[indexpath.row]
            cell.selectionStyle = .none
            return cell
        }.dispose(in: bag)
        searchTableView.reactive.selectedRowIndexPath.map { $0.row }.bind(to: viewModel.selectedSearchTableIndex).dispose(in: bag)
        viewModel.searchResults.observeNext { [weak self] array in
            if array.collection.count != 0 {
                self?.searchTableViewHeightConstrait.constant = CGFloat(array.collection.count) * MoviesTableViewCell.rowHeight
            }
        }.dispose(in: bag)
    }
    
    // Popular TableView Cell Pressed
    private func tableViewCellPressed() {
        viewModel.selectedTableIndex.observeNext { [weak self] index in
            guard let index = index,
                  let self = self else { return }
            self.viewModel.tableViewCellPressed(index: index)
        }.dispose(in: bag)
    }
    
    // Search TableView Pressed
    private func searchTableCellPressed() {
        viewModel.selectedSearchTableIndex.observeNext { [weak self] index in
            guard let index = index ,
                  let self = self else { return }
            self.viewModel.searchTableViewCellPressed(index: index)
        }.dispose(in: bag)
    }
    
    // MainViewController States
    override func onStateChanged(_ state: ViewState) {
        guard let state = state as? MainViewState else { return }
        switch state {
        case .popularDataCame:
            stopLoading()
            self.imgEmpty.isHidden = true
            self.lblEmpty.isHidden = true
        case .searchDataCame:
            bindSearchTableView()
            stopLoading()
        case .pagination:
            tableView.reloadData()
        case let .tableViewPressed(id):
            presentToDetailVC(for: id)
        case let .searchTablePressed(id, type):
            if type == "movie" {
                presentToDetailVC(for: id)
            } else if type == "person" {
                presentToPersonVC(for: id)
            }
        }
    }
    
    // Present to Movie Detail VC
    private func presentToDetailVC(for id: Int) {
        let vc = MovieDetailsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.viewModel.movieID.value = id
        self.present(vc, animated: true)
    }
    
    // Present to Person Detail VC
    private func presentToPersonVC(for id: Int) {
        let vc = CastDetailsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.viewModel.personID.value = id
        self.present(vc, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //MARK: - For TopRatedMovies Pagination
        let maximumVerticalOffset : CGFloat = tableView.contentSize.height - scrollView.frame.size.height
        let currentOffset : CGPoint = scrollView.contentOffset
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y

        if currentVerticalOffset > maximumVerticalOffset {
            if !viewModel.isSearhing {
                viewModel.moviesPagination()
            }
            scrollView.setContentOffset(currentOffset, animated: false)
        }
    }
}

//MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchtext = tfSearch.text, !searchtext.isEmpty {
            let searchedText = searchtext.lowercased()
            viewModel.getSearchedResults(searchedText: searchedText)
            tableViewHeightConstrait.constant = 0
            searchTableView.isHidden = false
            tableView.isHidden = true
            viewModel.isSearhing = true
        } else {
            searchTableViewHeightConstrait.constant = 0
            viewModel.isSearhing = false
            viewModel.pageOpened()
            tableView.isHidden = false
            searchTableView.isHidden = true
        }
    }
}
