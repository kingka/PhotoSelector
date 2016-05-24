//
//  UIImage+Category.swift
//  PhotoSelector
//
//  Created by Imanol on 16/5/24.
//  Copyright © 2016年 imanol. All rights reserved.
//

import UIKit

extension UIImage
{
    func imageWithWidth(width : CGFloat)-> UIImage
    {
        let height = width * size.height/size.width
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
