//
//  PosterCollectionViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import UIKit

final class ThumbnailsCollectionViewCellType: UICollectionViewCell {
    static let identifier = "ThumbnailsCollectionViewCellType"
    
    private let recipe: UILabel = {
        let label = UILabel()
        label.text = "Recipe"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(recipe)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recipe.sizeToFit()
        recipe.frame = CGRect(
            x: contentView.right + 20,
            y: 0,
            width: recipe.width,
            height: contentView.height
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel:ThumbnailsCollectionViewCell){
        
    }
    
}
