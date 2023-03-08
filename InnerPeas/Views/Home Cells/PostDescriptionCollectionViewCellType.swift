//
//  PosterCollectionViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import UIKit

protocol PostDescriptionCollectionViewCellTypeDelegate: AnyObject {
    func PostDesciptionCollectionViewCellTypeDidTapRecipeName(_cell: PostDescriptionCollectionViewCellType)
    func PostDescriptionCollectionViewCellTypeDidTapisMade(_cell: PostDescriptionCollectionViewCellType, isMade: Bool)
    func PostDescriptionCollectionViewCellTypeDidTapisFav(_cell: PostDescriptionCollectionViewCellType, isFav: Bool)
    func PostDescriptionCollectionViewCellTypeDidTapComment(_cell: PostDescriptionCollectionViewCellType)
    
}
final class PostDescriptionCollectionViewCellType: UICollectionViewCell {
    static let identifier = "PostDescriptionCollectionViewCellType"
    
    weak var delegate: PostDescriptionCollectionViewCellTypeDelegate?
    
    private var isMade = false
    private var isFav = false
    
    private let recipeName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "message",
            withConfiguration: UIImage.SymbolConfiguration(pointSize:20)
        )
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let isFavButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "bookmark",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
        )
        button.setImage(image, for: .normal)
        
        return button
    }()

    
    private let isMadeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "hand.thumbsup",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
        )
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    
    
    
//    private let ratingStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 5
//        return stackView
//    }()
    
    
    private let starImage: UIImage = UIImage(systemName: "star.fill")!
    
    @objc func didtapCommentButtom() {
        delegate?.PostDescriptionCollectionViewCellTypeDidTapComment(_cell: self)
        
    }
    
    @objc func didTapRecipeName() {
        delegate?.PostDesciptionCollectionViewCellTypeDidTapRecipeName(_cell: self)
        //going to make it so that large text can fit in the frame of the recipe name
        //allow for users to expand the truncated text
    }
 
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(recipeName)
        contentView.addSubview(commentButton)
        contentView.addSubview(isFavButton)
        contentView.addSubview(isMadeButton)
        commentButton.addTarget(self, action: #selector(didtapCommentButtom), for: .touchUpInside)
        isMadeButton.addTarget(self, action: #selector(didTapisMade), for: .touchUpInside)
        isFavButton.addTarget(self, action: #selector(didTapisFav), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapRecipeName))
        
        recipeName.isUserInteractionEnabled = true
        recipeName.addGestureRecognizer(tap)

        //contentView.addSubview(ratingStackView)
        
//        for _ in 0..<5 {
//            let imageView = UIImageView(image: starImage)
//            imageView.contentMode = .scaleAspectFit
//            imageView.tintColor = .systemYellow
//            ratingStackView.addArrangedSubview(imageView)
//        }
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    @objc func didTapisMade(){
        if self.isMade{
            let image = UIImage(
                systemName: "hand.thumbsup",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
            )
            isMadeButton.setImage(image, for: .normal)
            isMadeButton.tintColor = .label
            
        }
        else {
            let image = UIImage(
                systemName: "hand.thumbsup.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
            )
            isMadeButton.setImage(image, for: .normal)
            isMadeButton.tintColor = .systemGreen
            
        }
        delegate?.PostDescriptionCollectionViewCellTypeDidTapisMade(_cell: self,
                                                           isMade: !isMade)
        self.isMade = !isMade
        
    }
    
    @objc func didTapisFav(){
        if self.isFav{
            let image = UIImage(
                systemName: "bookmark",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
            )
            isFavButton.setImage(image, for: .normal)
            isFavButton.tintColor = .label
            
        }
        else {
            let image = UIImage(
                systemName: "bookmark.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
            )
            isFavButton.setImage(image, for: .normal)
            isFavButton.tintColor = .systemYellow
            
        }
        delegate?.PostDescriptionCollectionViewCellTypeDidTapisFav(_cell: self,
                                                           isFav: !isFav)
        self.isFav = !isFav
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recipeName.sizeToFit()
        recipeName.frame = CGRect(
            x: 7,
            y: 0,
            width: (contentView.width)/2,
            height: contentView.height
        )
        commentButton.frame = CGRect(
            x: contentView.width-50,
            y: (contentView.height-50)/2,
            width: 50,
            height: 50
        )
        
        isMadeButton.frame = CGRect(
            x: contentView.width-91,
            y: (contentView.height-50)/2,
            width: 50,
            height: 50
        )

        isFavButton.frame = CGRect(
            x: contentView.width-130,
            y: (contentView.height-50)/2,
            width: 50,
            height: 50
        )
        

        
        //        ratingStackView.frame = CGRect(
        //            x: (contentView.width-25*5)/2,
        //            y: (contentView.height-25)/2,
        //            width: 130,
        //            height: 25
        //        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeName.text = nil
        
//        for subview in ratingStackView.arrangedSubviews {
//             if let imageView = subview as? UIImageView {
//                 imageView.image = starImage
//             }
//         }
    }
    
    func configure(with viewModel:PostDescriptionCollectionViewCell){
        recipeName.text = viewModel.name
        isMade = viewModel.isMade
        isFav = viewModel.isFav
        
        
        
        
        
//        for i in 0..<5 {
//            if i < viewModel.averageRating {
//                (ratingStackView.arrangedSubviews[i] as? UIImageView)?.image = UIImage(systemName: "star.fill")
//            } else {
//                (ratingStackView.arrangedSubviews[i] as? UIImageView)?.image = UIImage(systemName: "star")
//            }
//        }
    }
        
}
