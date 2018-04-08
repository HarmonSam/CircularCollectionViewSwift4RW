//
//  CircularCollectionViewCell.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 10/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
  
//  var imageName: String = "" {
//    didSet {
//      imageView!.image = UIImage(named: imageName)
//    }
//  }
  
  
  var imageName = #imageLiteral(resourceName: "awt.png")
  
    @IBOutlet weak var imageView: UIImageView?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    print("loading nib")
//    let nib = UINib(nibName: "CircularCollectionViewCell", bundle: nil)
//    nib.instantiate(withOwner: self, options: nil)
    contentView.layer.cornerRadius = 5
    contentView.layer.borderColor = UIColor.black.cgColor
    contentView.layer.borderWidth = 1
    contentView.layer.shouldRasterize = true
    contentView.layer.rasterizationScale = UIScreen.main.scale
    contentView.clipsToBounds = true
    
  }
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    //commonInit()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //imageView!.contentMode = .scaleAspectFill
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
    self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
    self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
  }
}

class CardCell: UICollectionViewCell{
  
  @IBOutlet weak var cardImage: UIImageView!
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
    self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
    self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
  }
}



