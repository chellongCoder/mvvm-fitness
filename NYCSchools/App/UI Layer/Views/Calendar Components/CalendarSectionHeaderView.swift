//
//  CalendarSectionHeaderView.swift
//  NYCSchools
//
//  Created by VTIT on 6/9/24.
//

import Foundation
import UIKit
class ActivityCollectionViewHeader: UITableViewHeaderFooterView {
    private struct Constants {
        static let edgeInsetsTitle = UIEdgeInsets(top: 0,
                                             left: 10,
                                             bottom: 5,
                                             right: 10)
        static let leftInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let imageHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 10.0
         
    }
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = .black
        return label
    }()

    var headerSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(forAutoLayout: ())
        return view
    }()

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.setupViews()
  }
  

    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.edgeInsetsTitle)
    }
    
    private func setupTitleLabel() {
      wrapperView.addSubview(headerLabel)
      headerLabel.text = "Monthly"
      headerLabel.autoPinEdge(toSuperviewEdge: .leading,
                            withInset: Constants.leftInset)
      headerLabel.autoPinEdge(toSuperviewEdge: .top,
                            withInset: Constants.topInset)
      headerLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.bottomInset)
      headerLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
      headerLabel.autoSetDimension(.width, toSize: 100) // Set the width for headerLabel
    }
    
    private func setupSubTitleLabel() {
        wrapperView.addSubview(headerSubLabel)
        // Add constraints for headerSubLabel using PureLayout
        headerSubLabel.autoPinEdge(.leading, to: .trailing, of: headerLabel, withOffset: 8)
        headerSubLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.rightInset)
        headerSubLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        headerSubLabel.autoPinEdge(toSuperviewEdge: .top,
                            withInset: Constants.topInset)
      headerSubLabel.text = "\(UserDefaultsManager.shared.getObjects().count) activities"
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        setupTitleLabel()
        setupSubTitleLabel()
        
    }
}
