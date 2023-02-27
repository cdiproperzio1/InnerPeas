//
//  PosterCollectionViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import UIKit

final class PostRatingCollectionViewCellType: UICollectionViewCell {
    static let identifier = "PostRatingCollectionViewCellType"
    
    private let rating: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(rating)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rating.sizeToFit()
        let ratingsWidth = max(rating.frame.width, 50) // ensure the width is at most 50
        rating.frame = CGRect(
            x: (contentView.width - ratingsWidth) / 2,
            y: (contentView.height - 50) / 2,
            width: ratingsWidth,
            height: 50
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel:PostRatingCollectionViewCell){
        rating.text = String("Avg Rating - \(viewModel.averageRating) stars")
        
    }
    
}
