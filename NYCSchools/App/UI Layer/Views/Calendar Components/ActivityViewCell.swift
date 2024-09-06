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
        contentView.addSubview(activityLabel)
        contentView.addSubview(activityImageView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            activityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            activityImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityImageView.widthAnchor.constraint(equalToConstant: 40),
            activityImageView.heightAnchor.constraint(equalToConstant: 40),
            
            activityLabel.leadingAnchor.constraint(equalTo: activityImageView.trailingAnchor, constant: 16),
            activityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            activityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // Configure cell with data
    func configure(with activity: String, image: UIImage?) {
        activityLabel.text = activity
        activityImageView.image = image
    }
}
