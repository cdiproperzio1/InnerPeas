//
//  ViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/1/23.
//

import Firebase
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView? = nil
    
    private var viewModels = [[HomeFeedCellType]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "InnerPeas"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchPost()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchPost(){
        //test data
        let postData: [HomeFeedCellType] =
        [
            .poster(
                viewModel: PosterCollectionViewCell(
                    username: "FoodThatSmacks",
                    profilePictureURL: URL(string: "https://mymodernmet.com/wp/wp-content/uploads/2020/01/baby-yoda-eating-food-13.jpg")!
          
                )
            ),
            .post(
                viewModel: PostCollectionViewCell(
                    postUrl: URL(string: "https://www.foodandwine.com/thmb/Yt46CaGExGFVjruxJsNSFjNVMo0=/2000x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Super-Scoops-FT-2-MAG0622-00568f6534a44e0c8a422b66b25d6cf6.jpg")!
                )
            ),
            
            .postDescription(
                viewModel: PostDescriptionCollectionViewCell(
                    name: "Ice Cream with a long title to see how it holds in the frame",
                    isMade: false,
                    isFav: false
                )
            ),
            
            .postRating(
                viewModel: PostRatingCollectionViewCell(
                    averageRating: 3
                )
            ),
            
            .thumbNails(viewModel: ThumbnailsCollectionViewCell())
            
        ]
        viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    func configureCollectionView(){
        //post+action+average ratings+commentItem
        let height:CGFloat = 60 + 50 + 20 + 55 + view.width
        let collectionView = UICollectionView(frame: .zero,
                         collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

            //Items
            //poster
            let poster = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
                )
            )
            //post
            let post = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
                )
            )
            //postDescription
            let postDescription = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
                )
            )
            
            //average ratings
            let averageRating = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(20)
                )
            )
            
            //thumbNailImages
            let thumbNailImages = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(55)
                )
            )


            //Groups - poster, post, actions(favorite, created, comments, average rating)....
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(height)
                ),
                subitems: [
                    poster,
                    post,
                    postDescription,
                    averageRating,
                    thumbNailImages,
                ])

            //Sections
            let section =  NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 20, trailing: 0)
            return section
        })
       )
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            PosterCollectionViewCellType.self,
            forCellWithReuseIdentifier: PosterCollectionViewCellType.identifier
        )
        collectionView.register(
            PostCollectionViewCellType.self,
            forCellWithReuseIdentifier: PostCollectionViewCellType.identifier
        )
        collectionView.register(
            PostDescriptionCollectionViewCellType.self,
            forCellWithReuseIdentifier: PostDescriptionCollectionViewCellType.identifier
        )
        collectionView.register(
            PostRatingCollectionViewCellType.self,
            forCellWithReuseIdentifier: PostRatingCollectionViewCellType.identifier
        )
        collectionView.register(
            ThumbnailsCollectionViewCellType.self,
            forCellWithReuseIdentifier: ThumbnailsCollectionViewCellType.identifier
        )
        
        self.collectionView = collectionView
    }
    
    //collections to hold items in frame
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    let colors: [UIColor] = [.systemMint, .green, .blue, .systemGray, .orange,]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType{
            
        //WHERE INFO IS LOADED INTO THE CELL
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCellType.identifier,
                for: indexPath
            ) as? PosterCollectionViewCellType else{
                fatalError()
            }
            cell.delegate = self
            cell.configure(with:viewModel)
            //cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
            
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCellType.identifier,
                for: indexPath
            ) as? PostCollectionViewCellType else{
                fatalError()
            }
            cell.configure(with:viewModel)
            cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
            
        case .postDescription(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDescriptionCollectionViewCellType.identifier,
                for: indexPath
            ) as? PostDescriptionCollectionViewCellType else{
                fatalError()
            }
            cell.delegate = self
            cell.configure(with:viewModel)
            //cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
            
        case .postRating(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostRatingCollectionViewCellType.identifier,
                for: indexPath
            ) as? PostRatingCollectionViewCellType else{
                fatalError()
            }
            cell.configure(with:viewModel)
            //cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
            
        case .thumbNails(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ThumbnailsCollectionViewCellType.identifier,
                for: indexPath
            ) as? ThumbnailsCollectionViewCellType else{
                fatalError()
            }
            cell.configure(with:viewModel)
            cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
}

extension HomeViewController: PosterCollectionViewCellTypeDelegate{
    func PosterCollectionViewCellTypeDidTapUsername(_cell: PosterCollectionViewCellType){
        print("tapped username")
        
    }
    func PosterCollectionViewCellTypeDidTapMoreButton(_cell: PosterCollectionViewCellType){
        print("tapped more")
        let sheet = UIAlertController(title: "Actions",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Report",
                                      style: .destructive,
                                      handler: {_ in}))
        
        sheet.addAction(UIAlertAction(title: "Block",
                                      style: .destructive,
                                      handler: {_ in} ))
        present(sheet, animated: true)
    }

}
extension HomeViewController: PostDescriptionCollectionViewCellTypeDelegate{
    func PostDescriptionCollectionViewCellTypeDidTapisMade(_cell: PostDescriptionCollectionViewCellType, isMade: Bool) {
        print("Tapped is made")
    }
    
    func PostDescriptionCollectionViewCellTypeDidTapisFav(_cell: PostDescriptionCollectionViewCellType, isFav: Bool) {
        print("Tapped is Fav")
    }
    
    func PostDescriptionCollectionViewCellTypeDidTapComment(_cell: PostDescriptionCollectionViewCellType) {
        let vc = PostViewController()
        vc.title = "Comments"
        navigationController?.pushViewController(vc, animated: true)
        print("Tapped comment")
    }
}


    


