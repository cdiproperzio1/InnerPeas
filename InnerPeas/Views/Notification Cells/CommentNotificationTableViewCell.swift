//
//  CommentNotificationTableViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import UIKit

protocol CommentNotificationTableViewCellDelegate: AnyObject{
    func commentNotificationTableViewCell(_cell: CommentNotificationTableViewCell,
                                          didTapPostWith viewModel: CommentNotificationCellViewModel
    )
}

class CommentNotificationTableViewCell: UITableViewCell {
    static let identifier = "CommentNotificationTableViewCell"
    
    weak var delegate: CommentNotificationTableViewCellDelegate?
    private var viewModel: CommentNotificationCellViewModel?
    
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(postImageView)
        contentView.addSubview(dateLabel)
        
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.addGestureRecognizer(tap)
                                         
    }
    
    @objc func didTapPost(){
        guard let vm = viewModel else {
            return
        }
        delegate?.commentNotificationTableViewCell(_cell: self, didTapPostWith: vm)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height/1.5
        profilePictureImageView.frame = CGRect(
            x: 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        profilePictureImageView.layer.cornerRadius = imageSize/2

        let postSize: CGFloat = contentView.height - 6
        postImageView.frame = CGRect(
            x: contentView.width-postSize-10,
            y: 3,
            width: postSize,
            height: postSize)
        
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width-profilePictureImageView.right-25-postSize,
            height: contentView.height))
        
        dateLabel.sizeToFit()
        label.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: 0,
            width: labelSize.width,
            height: contentView.height-dateLabel.height-3
        )
        
        dateLabel.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: contentView.height-dateLabel.height-3,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilePictureImageView.image = nil
        postImageView.image = nil
        dateLabel.text = nil
    }
    
    public func configure(with viewModel: CommentNotificationCellViewModel){
        self.viewModel = viewModel
        profilePictureImageView.kf.setImage(with: viewModel.profilePictureURL, completionHandler: nil)
        postImageView.kf.setImage(with: viewModel.postURL, completionHandler: nil)
        label.text = viewModel.username + " commented on your post."
        dateLabel.text = viewModel.date
    }
}
