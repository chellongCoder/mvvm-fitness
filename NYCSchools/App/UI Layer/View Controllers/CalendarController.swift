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
    var items: [ExerciseModel] = [] // Populate this array with your data
    var collectionViewHeightConstraint: NSLayoutConstraint!

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
        let userDefault = UserDefaultsManager.shared
          // Create an array of ExerciseModel objects
        let exerciseModels = userDefault.getObjects()
        items = exerciseModels

        setupHeaderView()
        setupCalendarView()
        setupListView()
        setupFloatingButton()


    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      // Hide the default navigation bar
      self.navigationController?.setNavigationBarHidden(true, animated: animated)

      reloadItems()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        // Reload items and update UI
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         updateCollectionViewHeight()
    }

    private func reloadItems() {
        let userDefault = UserDefaultsManager.shared
        let exerciseModels = userDefault.getObjects()
        items = exerciseModels.sorted { $0.createdAt > $1.createdAt }

        // Update the UI, e.g., reload table view or collection view
        // Assuming you have a tableView or collectionView
        self.listView.reloadData()
//        self.collectionView.reloadData()
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
        ])

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
        updateCollectionViewHeight()

    }

    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint.constant = contentHeight
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // One section for days of the week, one for days of the month
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if section == 0 {
             return 7 // Days of the week
         } else {
             return 31 // max days in month
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayOfWeekCell", for: indexPath)
            let dayOfWeekLabel = UILabel(frame: cell.contentView.bounds)
            dayOfWeekLabel.textAlignment = .center
            dayOfWeekLabel.font = UIFont.systemFont(ofSize: 14)
            dayOfWeekLabel.textColor = .placeholderText
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
                    cell.backgroundColor = .secondarySystemBackground
                }
            } else {
                dayLabel.text = "31"
                dayLabel.textColor = .placeholderText
            }
            
            let items = self.items

            // Create the icon image view
            var iconImageView = UIImageView(image: UIImage(systemName: "")) // Use your desired icon
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.contentMode = .center


            if items.contains(where: {
              let date = calendar.dateComponents([.day, .month, .year], from: $0.createdAt)
              return date.day == day
            }) {
               // it exists, do something
              iconImageView = UIImageView(image: UIImage(named: "check-circle")?.withTintColor(.systemGreen)) // Use your desired icon

              let currentDate = calendar.dateComponents([.day, .month, .year], from: Date())
              if(currentDate.day == day) {
                iconImageView = UIImageView(image: UIImage(named: "calendar-plus")?.withTintColor(.systemYellow)) // Use your desired icon
              }
            }

            cell.contentView.addSubview(dayLabel)
           
            // Add the icon image view to the cell's content view
            cell.contentView.addSubview(iconImageView)

           // Set up constraints
            NSLayoutConstraint.activate([
                iconImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
                iconImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -0),
                iconImageView.widthAnchor.constraint(equalToConstant: 16), // Adjust the size as needed
                iconImageView.heightAnchor.constraint(equalToConstant: 16) // Adjust the size as needed
            ])

            iconImageView.autoSetDimensions(to: CGSize(width: 16, height: 16))

            return cell
        }
    }

        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if section == 0 {
        return 0
      } else {
        return 5
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      if section == 0 {
        return 0
      } else {
        return 5
      }
    }
    
      // UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      if section == 0 {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      } else {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
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

    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.day, .month, .year], from: date1)
        let components2 = calendar.dateComponents([.day, .month, .year], from: date2)
        return components1.day == components2.day && components1.month == components2.month && components1.year == components2.year
    }
    private func setupListView()  {
        // Create list view
        listView = UITableView()
        listView.translatesAutoresizingMaskIntoConstraints = true
        listView.dataSource = self
        listView.delegate = self
        listView.register(ActivityViewCell.self, forCellReuseIdentifier: "ActivityViewCell")
        listView.register(ActivityCollectionViewHeader.self, forHeaderFooterViewReuseIdentifier: "ActivityCollectionViewHeader")

        view.addSubview(listView)

        // Add constraints
        listView.autoPinEdge(.top, to: .bottom, of: collectionView, withOffset: 0)
        listView.autoPinEdge(toSuperviewEdge: .leading)
        listView.autoPinEdge(toSuperviewEdge: .trailing)
        listView.autoPinEdge(toSuperviewEdge: .bottom)

    }

    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityViewCell", for: indexPath) as! ActivityViewCell
        let item = self.items[indexPath.row]
        if isSameDay(item.createdAt, Date()) {
            print("The exercise was created in the past.")
          cell.configure(with: item.exerciseName, time: item.createdAt.toString(), ytLink: item.ytLink, image: UIImage(named: "calendar-plus")?.withTintColor(.systemYellow)) // Assuming you have a configure method in your cell
        } else {
            print("The exercise was created in the future.")
          cell.configure(with: item.exerciseName, time: item.createdAt.toString(),ytLink: item.ytLink, image: UIImage(named: "check-circle")?.withTintColor(.systemGreen)) // Assuming you have a configure method in your cell
        }
        // Configure the cell with data
        return cell
    }
    // UITableViewDelegate methods for header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityCollectionViewHeader") as? ActivityCollectionViewHeader else {
            fatalError("Unable to dequeue ActivityCollectionViewHeader")
        }

        // Configure the header with data
        // header.configure(with: yourData) // Assuming you have a configure method in your header

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0 // Set the height for the header view
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaultsManager.shared.pushObjects(items)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension CalendarController {
    @objc func goToAddNewActivity() {
        let addNewActivityVC = AddActivityController()

      self.navigationController?.pushViewController(addNewActivityVC, animated: true)
    }

    private func setupFloatingButton() {
        let floatingButton = UIButton(type: .custom)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.backgroundColor = .systemBlue // Set the background color
        floatingButton.setTitle("+", for: .normal) // Set the title
        floatingButton.setTitleColor(.white, for: .normal) // Set the title color
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 24) // Set the font size
        floatingButton.layer.cornerRadius = 30 // Set the corner radius to make it circular
        floatingButton.layer.masksToBounds = true
        floatingButton.addTarget(self, action: #selector(goToAddNewActivity), for: .touchUpInside)

        view.addSubview(floatingButton)
        
        // Constraints for floatingButton
        floatingButton.autoSetDimensions(to: CGSize(width: 60, height: 60)) // Set the size of the button
        floatingButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        floatingButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
    }
}
    
