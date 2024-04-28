//
//  CategoryHeaderView.swift
//  Tracker
//
//  Created by Михаил  on 23.04.2024.
//

import Foundation
import UIKit

final class CategoryHeaderView: UICollectionReusableView{
    static let identifier = "CategoryHeaderViewForTracker"
    let titleLabel = UILabel()
    
    override init (frame:CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
    }
    
    func configure(with title: String){
        titleLabel.text = title
    }
}
