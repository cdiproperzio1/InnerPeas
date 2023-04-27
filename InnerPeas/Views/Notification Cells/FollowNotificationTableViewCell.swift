//
//  FollowNotificationTableViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import UIKit

protocol FollowNotificationTableViewCellDelegate: AnyObject {
    func followNotificationTableViewCell(_ cell: FollowNotificationTableViewCell,
                                         didTapButton isFollowing : Bool,
                                         viewModel: FollowNotificationCellViewModel)
}
class FollowNotificationTableViewCell: UITableViewCell {

    static let identifier = "FollowNotificationTableViewCell"
    
    weak var delegate: FollowNotificationTableViewCellDelegate?
    
    private var viewModel: FollowNotificationCellViewModel?
    
    private var isFollowing = false
    
    private let profilePictureImageView: UIImageView = {
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
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapFollowButton(){
        guard let vm = viewModel else {
            return
        }
        delegate?.followNotificationTableViewCell(self,
                                                  didTapButton: !isFollowing,
                                                  viewModel: vm)
        self.isFollowing = !isFollowing
        updateButton()
    }
    
    private func updateButton(){
        followButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        
        followButton.backgroundColor = isFollowing ? .secondaryLabel : .systemGreen
        followButton.setTitleColor(isFollowing ? .label : .white,
                                   for: .normal)
        
        if isFollowing {
            followButton.layer.borderWidth = 0.5
            followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        }

        
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
        
        followButton.sizeToFit()
        let buttonWidth: CGFloat = max(followButton.width, 75)
        followButton.frame = CGRect(
            x: contentView.width - buttonWidth - 24,
            y: (contentView.height - followButton.height)/2,
            width: buttonWidth + 14,
            height: followButton.height)
        
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width-profilePictureImageView.width-buttonWidth-44,
            height: contentView.height))
        
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
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        dateLabel.text = nil
    }
    
    public func configure(with viewModel: FollowNotificationCellViewModel){
        self.viewModel = viewModel
        label.text = viewModel.username + " started following you."
        profilePictureImageView.kf.setImage(with: viewModel.profilePictureURL, completionHandler: nil)
        isFollowing = viewModel.isCurrentUserFollowing
        updateButton()
        dateLabel.text = viewModel.date
    }
}
