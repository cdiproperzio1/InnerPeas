//
//  HomeFeedCellType.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/14/23.
//

import Foundation

enum HomeFeedCellType{
    case poster(viewModel: PosterCollectionViewCell)
    case post(viewModel: PostCollectionViewCell)
    case postDescription(viewModel: PostDescriptionCollectionViewCell)
    case postRating(viewModel: PostRatingCollectionViewCell)
    case thumbNails(viewModel: ThumbnailsCollectionViewCell)
    
}
