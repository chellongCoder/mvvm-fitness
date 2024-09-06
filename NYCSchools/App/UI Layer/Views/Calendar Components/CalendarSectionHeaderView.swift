//
//  CalendarSectionHeaderView.swift
//  NYCSchools
//
//  Created by VTIT on 6/9/24.
//

import Foundation
import UIKit
class ActivityCollectionViewHeader: UICollectionReusableView {
    private struct Constants {
        static let edgeInsetsTitle = UIEdgeInsets(top: 5,
                                             left: 10,
                                             bottom: 5,
                                             right: 5)
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
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    var headerSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(forAutoLayout: ())
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.edgeInsetsTitle)
    }
    
    private func setupTitleLabel() {
        wrapperView.addSubview(headerLabel)
        headerLabel.autoPinEdge(toSuperviewEdge: .leading,
                              withInset: Constants.leftInset)
        headerLabel.autoPinEdge(toSuperviewEdge: .trailing,
                              withInset: Constants.rightInset)
        headerLabel.autoPinEdge(toSuperviewEdge: .top,
                              withInset: Constants.topInset)
        headerLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

    }
    
    private func setupSubTitleLabel() {
        wrapperView.addSubview(headerSubLabel)
        // Add constraints for headerSubLabel using PureLayout
        headerSubLabel.autoPinEdge(.leading, to: .trailing, of: headerLabel, withOffset: 8)
        headerSubLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        headerSubLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

        
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        setupTitleLabel()
        setupSubTitleLabel()
        
    }
}
