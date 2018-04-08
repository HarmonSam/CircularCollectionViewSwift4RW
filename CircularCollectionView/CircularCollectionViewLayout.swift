//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Samuel Harmon on 4/4/18.
//  Copyright © 2018 Rounak Jain. All rights reserved.
//

import UIKit


class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  // 1
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    // 2
    didSet {
      zIndex = Int(angle * 1000000)
      transform = CGAffineTransform(rotationAngle: angle)
    }
  }
  // 3 override

  override func copy(with zone: NSZone? = nil) -> Any {
    let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
    copiedAttributes.anchorPoint = self.anchorPoint
    copiedAttributes.angle = self.angle
    return copiedAttributes
  }

}

class CircularCollectionViewLayout: UICollectionViewLayout {
  let itemSize = CGSize(width: 300, height: 500)
  
  var angleAtExtreme: CGFloat {
    return collectionView!.numberOfItems(inSection: 0) > 0 ?
      -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
  }
  var angle: CGFloat {
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
      collectionView!.bounds.width)
  }
  
  var radius: CGFloat = 1000 {
    didSet {
      invalidateLayout()
    }
  }
  
  var anglePerItem: CGFloat {
    return atan(itemSize.width / radius)
  }
  
  var attributesList = [CircularCollectionViewLayoutAttributes]()
  
//  func collectionViewContentSize() -> CGSize {
//    return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView!.bounds.height)
//  }
  override var collectionViewContentSize: CGSize {
    let collection = collectionView!
    let width = CGFloat(collection.numberOfItems(inSection: 0)) * itemSize.width
    let height = collectionView!.bounds.height
    
    return CGSize(width: width, height: height)
  }

  class func layoutAttributesClass() -> AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }

  override func prepare() {
    super.prepare()
    
    let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
    let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
    
    let theta = atan2(collectionView!.bounds.width / 2.0,
                      radius + (itemSize.height / 2.0) - (collectionView!.bounds.height / 2.0))
    // 2
    var startIndex = 0
    var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
    // 3
    if (angle < -theta) {
      startIndex = Int(floor((-theta - angle) / anglePerItem))
    }
    // 4
    endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
    // 5
    if (endIndex < startIndex) {
      endIndex = 0
      startIndex = 0
    }
    
//    attributesList = (0..<collectionView!.numberOfItemsInSection(0)).map { (i)
//      -> CircularCollectionViewLayoutAttributes in
      attributesList = (startIndex...endIndex).map { (i)
        -> CircularCollectionViewLayoutAttributes in
      // 1
        let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))

        attributes.size = self.itemSize
      // 2
      attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
      // 3
      //attributes.angle = self.anglePerItem*CGFloat(i)
      attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
      
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      return attributes
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
//  override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

//  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
          multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
          multiplier = floor(ratio)
        } else {
          multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
  }
}
