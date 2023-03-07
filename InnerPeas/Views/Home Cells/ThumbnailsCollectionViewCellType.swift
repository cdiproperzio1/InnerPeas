//
//  PosterCollectionViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import UIKit

protocol ThumbnailsCollectionViewCellTypeDelegate: AnyObject{
    func
    ThumbnailsCollectionViewCellTypeDidTapRecipeLabel(_cell: ThumbnailsCollectionViewCellType)
    
}
final class ThumbnailsCollectionViewCellType: UICollectionViewCell {
    static let identifier = "ThumbnailsCollectionViewCellType"
    
    weak var delegate:
        ThumbnailsCollectionViewCellTypeDelegate?
    
    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(recipeLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector (didTapRecipeLabel))
        
        recipeLabel.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    @objc func didTapRecipeLabel(){
        delegate?.ThumbnailsCollectionViewCellTypeDidTapRecipeLabel(_cell: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recipeLabel.sizeToFit()
        recipeLabel.frame = CGRect(
            x: (contentView.width-recipeLabel.width)/2,
            y: (contentView.height - 50) / 2,
            width: recipeLabel.width,
            height: contentView.height
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel:ThumbnailsCollectionViewCell){
        
    }
    
}
