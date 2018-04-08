//
//  CollectionViewController.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 10/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "cardCell"

class CollectionViewController: UICollectionViewController {
  
  let images: [String] = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Images")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Register cell classes
    print("viewDidLoad")
    //collectionView!.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    let imageView = UIImageView(image: UIImage(named: "bg-dark.jpg"))
    imageView.contentMode = UIViewContentMode.scaleAspectFill
    collectionView!.backgroundView = imageView
  }
  
}

extension CollectionViewController{//: UICollectionViewDataSource {
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("selected: \(indexPath.row)")
  }
  
  override func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    
      return images.count
  }
  
//  override func collectionView(collectionView: UICollectionView,
//    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
    cell.cardImage.image = #imageLiteral(resourceName: "awt")

      //cell.imageName = images[indexPath.row]
    //cell.imageView.image = cell.imageName
    
      return cell
  }
  
}
