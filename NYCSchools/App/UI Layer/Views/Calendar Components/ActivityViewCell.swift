//
//  ActivityViewCell.swift
//  NYCSchools
//
//  Created by VTIT on 6/9/24.
//

import Foundation
import UIKit

class ActivityViewCell: UITableViewCell {
    
    // Define UI components
    let activityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let activityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let verticalLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray // Set the color of the line
        view.layer.cornerRadius = 2 // Set the border radius
        view.layer.masksToBounds = true
        return view
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup UI components
    private func setupViews() {
        contentView.addSubview(activityImageView)
        contentView.addSubview(verticalLine)
        contentView.addSubview(containerView)

        containerView.addSubview(activityLabel)
        containerView.addSubview(timeLabel)

        // Constraints for verticalLine
        verticalLine.autoSetDimensions(to: CGSize(width: 5, height: 50))
        verticalLine.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        verticalLine.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        // Constraints for activityImageView
        activityImageView.autoPinEdge(.leading, to: .trailing, of: verticalLine, withOffset: 8)
        activityImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        activityImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        activityImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        activityImageView.autoSetDimensions(to: CGSize(width: 40, height: 40))

         // Constraints for containerView
        containerView.autoPinEdge(.leading, to: .trailing, of: activityImageView, withOffset: 8)
        containerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        containerView.autoAlignAxis(toSuperviewAxis: .horizontal)

        // Constraints for activityLabel
        activityLabel.autoPinEdge(toSuperviewEdge: .top)
        activityLabel.autoPinEdge(toSuperviewEdge: .leading)
        activityLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        // Constraints for timeLabel
        timeLabel.autoPinEdge(.top, to: .bottom, of: activityLabel, withOffset: 4)
        timeLabel.autoPinEdge(toSuperviewEdge: .leading)
        timeLabel.autoPinEdge(toSuperviewEdge: .trailing)
        timeLabel.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    // Configure cell with data
  func configure(with activity: String, time: String, image: UIImage?) {
        activityLabel.text = activity
        activityImageView.image = image
        timeLabel.text = time
    }
}
