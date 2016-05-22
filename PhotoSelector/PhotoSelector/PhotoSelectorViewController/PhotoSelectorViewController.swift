//
//  PhotoSelectorViewController.swift
//  PhotoSelector
//
//  Created by Imanol on 5/22/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

let photoSelectorCollectionViewCellIdentifer = "photoSelectorCollectionViewCellIdentifer"
class PhotoSelectorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(collectionView)
        collectionView.registerClass(PhotoSelectorCell.self, forCellWithReuseIdentifier: photoSelectorCollectionViewCellIdentifer)
        collectionView.dataSource = self
        
        //autoLayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView":collectionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView":collectionView])
        
        view.addConstraints(cons)
    }

    //Mark:- lazy
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoSelectorCellLayout())
    
    
}

class PhotoSelectorCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(addButton)
        contentView.addSubview(deleteButton)
        
        //autoLauout
        addButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[deleteButton]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["deleteButton": deleteButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[deleteButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["deleteButton": deleteButton])
        
        contentView.addConstraints(cons)

    }
    
    func deleteButtonClick(){
        print(__FUNCTION__)
    }
    
    func addButtonClick(){
        print(__FUNCTION__)
    }
    
    //Mark:- lazy
    private lazy var addButton : UIButton = {
       let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var deleteButton : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "deleteButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoSelectorViewController : UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoSelectorCollectionViewCellIdentifer, forIndexPath: indexPath) as! PhotoSelectorCell
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

class PhotoSelectorCellLayout : UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = CGSizeMake(80, 80)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}