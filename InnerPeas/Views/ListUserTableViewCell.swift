//
//  ListUserTableViewCell.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/29/23.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {

    static let identifier = "ListUserTableViewCell"
    
    private let profilePictireImageView:  UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(profilePictireImageView)
        contentView.addSubview(usernameLabel)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        usernameLabel.sizeToFit()
        let size: CGFloat = contentView.height/1.3
        
        profilePictireImageView.frame = CGRect(x: 5, y: (contentView.height-size)/2, width: size, height: size)
        profilePictireImageView.layer.cornerRadius = size/2
        usernameLabel.frame = CGRect(x: profilePictireImageView.right+10, y: 0, width: usernameLabel.width, height: contentView.height)
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilePictireImageView.image = nil
    }
    
    func configure(with viewModel: ListUserTableViewCellViewModel){
        usernameLabel.text = viewModel.usernmae
        StorageManager.shared.profilePictureURL(for: viewModel.usernmae) {[weak self] url in
            DispatchQueue.main.async {
                self?.profilePictireImageView.kf.setImage(with: url, completionHandler: nil)

            }
        }
    }
}
