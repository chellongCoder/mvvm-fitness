//
//  CalendarController.swift
//  NYCSchools
//
//  Created by VTIT on 5/9/24.
//

import Foundation
import UIKit

class CalendarController: UIViewController {
    private var collectionView: UICollectionView!
    private var listView: UITableView!
    struct ActivityItem {
        let activity: String
        let imageName: String
    }
    // Data source array
    var items: [ActivityItem] = [] // Populate this array with your data
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private struct Constants {
        static let cellIdentifier: String = "activityCell"
        static let cellHeight: CGFloat = 100
        static let sectionHeaderIdentifier: String = "sectionHeader"
        static let sectionHeight: CGFloat = 50
    }
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.numberOfLines = 0
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Activity"
        view.backgroundColor = .white
        
        // Populate the items array
        items = [
            ActivityItem(activity: "Running", imageName: "running_icon"),
            ActivityItem(activity: "Swimming", imageName: "swimming_icon"),
            ActivityItem(activity: "Cycling", imageName: "cycling_icon")
        ]
        
        setupHeaderView()
        setupCalendarView()
        setupListView()

        // Calculate and set the height of the collectionView
        updateCollectionViewHeight()

    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Hide the default navigation bar
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
        
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    
}

extension CalendarController {
    
    func setupHeaderView() {
        // Create header view
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Create back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        if let backImage = UIImage(systemName: "chevron.left") {
            backButton.setImage(backImage, for: .normal)
        }
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backButton)
        
        // Create title label

        // Set the title label text to the current date formatted as "MMMM YYYY"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let currentDate = Date()
        titleLabel.text = dateFormatter.string(from: currentDate)

        let titleLabel = titleLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // Create three-dot button
        let threeDotButton = UIButton(type: .system)
        if let threeDotImage = UIImage(systemName: "ellipsis") {
            threeDotButton.setImage(threeDotImage, for: .normal)
        }        
        threeDotButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(threeDotButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Header view constraints
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Back button constraints
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Title label constraints
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Three-dot button constraints
            threeDotButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            threeDotButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
}

extension CalendarController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCalendarView() {
        // Create layout for collection view
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // Create collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "dayOfWeekCell")

        view.addSubview(collectionView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // One section for days of the week, one for days of the month
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if section == 0 {
             return 7 // Days of the week
         } else {
             return 42 // 6 weeks * 7 days
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayOfWeekCell", for: indexPath)
            let dayOfWeekLabel = UILabel(frame: cell.contentView.bounds)
            dayOfWeekLabel.textAlignment = .center
            dayOfWeekLabel.font = UIFont.systemFont(ofSize: 14)
            dayOfWeekLabel.text = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][indexPath.item]
            cell.contentView.addSubview(dayOfWeekLabel)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 10 // Set corner radius
            cell.layer.masksToBounds = true // Ensure the corners are clipped

            // Calculate the day number
            let dayLabel = UILabel(frame: cell.contentView.bounds)
            dayLabel.textAlignment = .center
            dayLabel.font = UIFont.systemFont(ofSize: 14)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: components)!
            let startDayOfWeek = calendar.component(.weekday, from: startOfMonth) - 1
            let day = indexPath.item - startDayOfWeek + 1
            
            if day > 0 && day <= calendar.range(of: .day, in: .month, for: startOfMonth)!.count {
                dayLabel.text = "\(day)"
                
                // Highlight today's date
                if calendar.isDateInToday(calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!) {
                    cell.backgroundColor = .red
                }
            } else {
                dayLabel.text = ""
            }
            
            cell.contentView.addSubview(dayLabel)
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        if indexPath.section == 0 {
            return CGSize(width: width, height: 30) // Height for days of the week
        } else {
            let height = (collectionView.frame.height - 30) / 6 // Subtract height of days of the week
            return CGSize(width: width, height: width)
        }
    }
    
}

extension CalendarController : UITableViewDataSource, UITableViewDelegate{
    private func updateCollectionViewHeight() {
        let totalHeight = Constants.cellHeight * CGFloat(items.count)
        collectionViewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
    }

    private func setupListView()  {
        // Create list view
        listView = UITableView()
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.dataSource = self
        listView.delegate = self
        listView.register(ActivityViewCell.self, forCellReuseIdentifier: "ActivityViewCell")
        view.addSubview(listView)
        
        // Add constraints
        listView.autoPinEdge(.top, to: .bottom, of: collectionView, withOffset: 8)
        listView.autoPinEdge(toSuperviewEdge: .leading)
        listView.autoPinEdge(toSuperviewEdge: .trailing)
        listView.autoPinEdge(toSuperviewEdge: .bottom)
        
        // collectionView.register(SchoolCollectionViewCell.self,
        //                         forCellWithReuseIdentifier: Constants.cellIdentifier)
        // collectionView.register(ActivityCollectionViewHeader.self,
        //                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        //                         withReuseIdentifier: Constants.sectionHeaderIdentifier)

    }

    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityViewCell", for: indexPath) as! ActivityViewCell
        let item = self.items[indexPath.row]
        
        // Configure the cell with data
        cell.configure(with: item.activity, image: UIImage(named: "item.imageName")) // Assuming you have a configure method in your cell
        
        return cell
    }
    
    // UITableViewDelegate methods for header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityCollectionViewHeader") as! ActivityCollectionViewHeader
        
        // Configure the header with data
        // header.configure(with: yourData) // Assuming you have a configure method in your header
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0 // Set the height for the header view
    }
}
    
