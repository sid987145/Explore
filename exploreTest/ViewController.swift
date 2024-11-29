//
//  ViewController.swift
//  exploreTest
//
//  Created by Siddharth Chaudhary on 29/11/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var blurView: UIView!
    
    private var selectedFilter: ProblemFilter?
    private let viewModel = JourneyViewModel()
    private var filteredJourneys: [Journey] = []
    private var cancellables: Set<AnyCancellable> = []
    private var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        fetchJourneys()
        setupCollectionView()
    }
    
    private func setupUI() {
        styleSearchBar()
        searchBar.delegate = self
        filterCollectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
        contentCollectionView.register(UINib(nibName: "ContentCell", bundle: nil), forCellWithReuseIdentifier: "contentCell")
        
        setupLoader()
    }
    
    private func setupLoader() {
        loader = UIActivityIndicatorView(style: .large)
        loader.center = blurView.center
        loader.hidesWhenStopped = true
        blurView.addSubview(loader)
    }
    func setupCollectionView() {
        if let layout = filterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)        }

        if let layout = contentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    
    private func setupBindings() {
        viewModel.$journeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterJourneys()
                self?.toggleLoader(show: false)
            }
            .store(in: &cancellables)
        
        viewModel.$problemFilters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filters in
                self?.filterCollectionView.reloadData()
                if let allFilter = filters.first(where: { $0.title == "All" }) {
                    self?.selectedFilter = allFilter
                    self?.filterJourneys()
                    self?.filterCollectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                                           animated: false,
                                                           scrollPosition: .centeredHorizontally)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchJourneys() {
        toggleLoader(show: true)
        viewModel.fetchJourneys()
    }
    
    private func filterJourneys() {
        let query = searchBar.text?.lowercased() ?? ""
        filteredJourneys = viewModel.journeys
        
        if !query.isEmpty {
            filteredJourneys = filteredJourneys.filter {
                $0.title?.lowercased().contains(query) ?? false
            }
        }
        
        if let selectedFilter = selectedFilter, selectedFilter.title != "All" {
            filteredJourneys = filteredJourneys.filter {
                $0.problems?.contains { $0.lowercased() == selectedFilter.title?.lowercased() } ?? false
            }
        }
        
        contentCollectionView.reloadData()
    }
    
    private func toggleLoader(show: Bool) {
        blurView.isHidden = !show
        show ? loader.startAnimating() : loader.stopAnimating()
    }
    
    private func styleSearchBar() {
        searchBar.layer.cornerRadius = 20
        searchBar.layer.masksToBounds = true
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.clipsToBounds = true
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
            textField.textColor = UIColor.white
            textField.backgroundColor = UIColor(red: 27/255.0, green: 31/255.0, blue: 33/255.0, alpha: 1.0)
        }
        
        searchBar.barTintColor = UIColor(red: 27/255.0, green: 31/255.0, blue: 33/255.0, alpha: 1.0)
        searchBar.tintColor = UIColor.white
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            let searchIcon = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysTemplate)
            searchBar.setImage(searchIcon, for: .search, state: .normal)
            searchBar.tintColor = UIColor.white
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterJourneys()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == filterCollectionView ? viewModel.problemFilters.count : filteredJourneys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
            let filter = viewModel.problemFilters[indexPath.item]
            
            cell.titleLabel.text = filter.title
            
            // Update cell UI based on selection
            cell.rightImage.isHidden = (filter != selectedFilter)
            cell.contentView.backgroundColor = (filter == selectedFilter) ? UIColor(red: 74/255.0, green: 77/255.0, blue: 79/255.0, alpha: 1.0) : UIColor.clear
            cell.titleLabel.textColor = (filter == selectedFilter) ? UIColor.black : UIColor.white
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as! ContentCell
            cell.configureCell(with: filteredJourneys[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            selectedFilter = viewModel.problemFilters[indexPath.item]
            filterCollectionView.reloadData()
            filterJourneys()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentCollectionView {
            let screenWidth = UIScreen.main.bounds.width
            let cellWidth = (screenWidth-60)/2
            return CGSize(width: cellWidth, height: 200)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }


}
