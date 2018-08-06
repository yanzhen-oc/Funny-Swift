//
//  FunnyWaterfallLayout.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol FunnyWaterfallLayoutProtocol: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout waterfallLayout: FunnyWaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class FunnyWaterfallLayout: UICollectionViewLayout {
    
    
    public weak var delegate: FunnyWaterfallLayoutProtocol?
    public var minimumLineSpacing: CGFloat = 1
    public var minimumInteritemSpacing: CGFloat = 1
    public var sectionInset: UIEdgeInsets = .zero
    
    private var columnCount = 0
    private var maxYDict: [Int : CGFloat] = [:]
    private var attributesArray = [UICollectionViewLayoutAttributes]()
    required init(_ columnCount: Int) {
        super.init()
        self.columnCount = columnCount
    }
    
    override func prepare() {
        super.prepare()
        for i in 0..<columnCount {
            maxYDict[i] = sectionInset.top
        }
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        attributesArray.removeAll()
        for i in 0..<itemCount {
            let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            attributesArray.append(attributes!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var itemSize = CGSize.zero
        if let size = delegate?.collectionView(collectionView!, layout: self, sizeForItemAt: indexPath) {
            itemSize = size
        }
        var minYIndex = 0//找出最短的那一列
        for (key, value) in maxYDict {
            if maxYDict[minYIndex]! > value {
                minYIndex = key
            }
        }
        //根据最短列的列数计算item的x值
        let itemX = sectionInset.left + (itemSize.width + minimumLineSpacing) * CGFloat(minYIndex)
        //item的y值 = 最短列的最大y值 + 行间距
        let itemY = maxYDict[minYIndex]! + minimumInteritemSpacing
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemSize.width, height: itemSize.height)
        print(attributes.frame)
        maxYDict[minYIndex] = attributes.frame.maxY
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        var maxYIndex = 0
        for (key, value) in maxYDict {
            if maxYDict[maxYIndex]! < value {
                maxYIndex = key
            }
        }
        return CGSize(width: 0, height: maxYDict[maxYIndex]! + sectionInset.bottom)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

