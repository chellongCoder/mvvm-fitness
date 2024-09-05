//
//  ViewController.swift
//  NYCSchools
//
//  Created by Rolan on 8/1/22.
//

import UIKit
import Combine
import PureLayout
import MBProgressHUD

class SchoolsCollectionViewController: UIViewController {
    
    private let schoolsViewModel: SchoolsViewModel = SchoolsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView?
    private var loadingHUD: MBProgressHUD?
    private let refreshControl = UIRefreshControl()
    
    private struct Constants {
        static let cellIdentifier: String = "schoolCell"
        static let cellHeight: CGFloat = 100
        static let sectionHeaderIdentifier: String = "sectionHeader"
        static let sectionHeight: CGFloat = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupBinders()
        setupLoadingHUD()
        retrieveSchoolData()
        setupRefreshControl()
        
        title = "schools.list.nav.title".localized()
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "pull.to.refresh.title".localized())
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        retrieveSchoolData()
        refreshControl.endRefreshing()
    }
    
    private func retrieveSchoolData() {
        removeStateView()
        loadingHUD?.show(animated: true)
        schoolsViewModel.getSchools()
        schoolsViewModel.getSchoolSATs()
    }
    
    private func setupLoadingHUD() {
        guard let collectionView = collectionView else {
            return
        }
        loadingHUD = MBProgressHUD.showAdded(to: collectionView,
                                             animated: true)
        loadingHUD?.label.text = "loading.hud.title".localized()
        loadingHUD?.isUserInteractionEnabled = false
        loadingHUD?.detailsLabel.text = "loading.hud.subtitle".localized()
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width,
                                               height: Constants.cellHeight)
        collectionViewLayout.headerReferenceSize = CGSize(width: view.frame.size.width,
                                                          height: Constants.sectionHeight)
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: collectionViewLayout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        //setup & customize flow layout
        collectionView.register(SchoolCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.register(SchoolSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.sectionHeaderIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupBinders() {
        Publishers.Zip(schoolsViewModel.$schools,
                       schoolsViewModel.$schoolSATs)
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                let schools = items.0
                let _ = items.1 // SATs
                
                guard let self = self,
                      let _ = schools else {
                    return
                }
                self.loadingHUD?.hide(animated: true)
                self.removeStateView()
                
                if self.schoolsViewModel.schools?.isEmpty == false {
                    self.collectionView?.reloadData()
                } else {
                    self.showEmptyState()
                }
            }
            .store(in: &cancellables)
        
        schoolsViewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    self.loadingHUD?.hide(animated: true)
                    switch error {
                    case .networkingError(let errorMessage):
                        self.showErrorState(errorMessage)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

/// Implementation of data source delegate for collection view to help with displaying schools
extension SchoolsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return schoolsViewModel.schoolSectionsList?[section].schools.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                            for: indexPath) as? SchoolCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let schoolSection = schoolsViewModel.schoolSectionsList?[indexPath.section] {
            let school = schoolSection.schools[indexPath.item]
            cell.populate(school)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schoolsViewModel.schoolSectionsList?.count ?? 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: Constants.sectionHeaderIdentifier,
                                                                               for: indexPath) as? SchoolSectionHeaderView  {
            sectionHeader.headerLabel.text = schoolsViewModel.schoolSectionsList?[indexPath.section].city
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension SchoolsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let school = schoolsViewModel.schoolSectionsList?[indexPath.section].schools[indexPath.item],
           let schoolSAT = schoolsViewModel.schoolSATDictionary[school.dbn] {
            let schoolDetailsVC = CalendarController()
//            schoolDetailsVC.viewModel = SchoolDetailsViewModel(school: school,
//                                                               schoolSAT: schoolSAT)
            navigationController?.pushViewController(schoolDetailsVC,
                                                     animated: true)
        }
    }
}

extension SchoolsCollectionViewController {
    func showErrorState(_ errorMessage: String) {
        let errorStateView = SchoolsListStateView(forAutoLayout: ())
        errorStateView.update(for: .error)
        collectionView?.backgroundView = errorStateView
    }
    
    func removeStateView() {
        collectionView?.backgroundView = nil
    }
    
    func showEmptyState() {
        let emptyStateView = SchoolsListStateView(forAutoLayout: ())
        emptyStateView.update(for: .empty)
        collectionView?.backgroundView = emptyStateView
    }
}
