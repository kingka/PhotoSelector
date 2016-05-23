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
    
    private lazy var images = [UIImage]()
    
}

@objc
protocol PhotoSelectorCellDelegate : NSObjectProtocol
{
    optional func photoSelectDidAdd(cell : PhotoSelectorCell)
    optional func photoSelectDidRemove(cell : PhotoSelectorCell)
}

class PhotoSelectorCell : UICollectionViewCell {
    
    weak var delegate : PhotoSelectorCellDelegate?
    
    var image : UIImage?{
        didSet{
            if image == nil
            {
                addButton.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                deleteButton.hidden = true
                addButton.userInteractionEnabled = true
            }else{
                deleteButton.hidden = false
                addButton.setImage(image, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            }
            
        }
    }
    
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
        
        if ((delegate?.respondsToSelector("photoSelectDidRemove:")) != false){
            delegate?.photoSelectDidRemove!(self)
        }
    }
    
    func addButtonClick(){
        
        if ((delegate?.respondsToSelector("photoSelectDidAdd:")) != false){
            delegate?.photoSelectDidAdd!(self)
        }
        
    }
    
    //Mark:- lazy
    
    private lazy var addButton : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var deleteButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "deleteButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        btn.hidden = true
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoSelectorViewController : UICollectionViewDataSource,PhotoSelectorCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoSelectorCollectionViewCellIdentifer, forIndexPath: indexPath) as! PhotoSelectorCell
        cell.backgroundColor = UIColor.greenColor()
        //cell.image = images[indexPath.item]
        //这里image.count 的数目是固定的，而item 会逐渐+1 ， 因为numberOfItemsInSection这里已经控制了数量是比 image.count +1 ,而 index.item 是从0开始， 所以最后一个，就可以是 + 号图片
        cell.image = indexPath.item == images.count ? nil : images[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func photoSelectDidAdd(cell: PhotoSelectorCell) {
        print(__FUNCTION__)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("can not open")
            return
        }
        
        let picVC = UIImagePickerController()
        //tip: 除了需要继承UIImagePickerControllerDelegate之外，还需要继承UINavigationControllerDelegate，不然会报错
        picVC.delegate = self
        
        // 设置允许用户编辑选中的图片
        // 开发中如果需要上传头像, 那么请让用户编辑之后再上传
        // 这样可以得到一张正方形的图片, 以便于后期处理(圆形)
        picVC.allowsEditing = true
        presentViewController(picVC, animated: true, completion: nil)
    }
    
    func photoSelectDidRemove(cell: PhotoSelectorCell) {
        //get index
        let indexPath = collectionView.indexPathForCell(cell)
        //remove item at index
        images.removeAtIndex((indexPath?.item)!)
        //reload
        collectionView.reloadData()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        images.append(image)
        collectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
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