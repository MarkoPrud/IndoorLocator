//
//  ClassCellPrototype.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/9/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import UIKit
class ClassCellPrototype : UITableViewCell {
    
    var product : ClassObject? {
        didSet {
            classNameLabel.text = product?.ClassName
            classDescriptionLabel.text = product?.RoomNumber
            classSwitch.onTintColor = product?.MarkerColor
            classColor.backgroundColor = product?.MarkerColor
        }
    }
    
    private let classColor : UIImageView = {
        
        let imgView = UIImageView()
        imgView.frame.size.height = 20
        imgView.frame.size.width = 20
        imgView.layer.borderColor = UIColor.blue.cgColor
        
        return imgView
    }()
    private let classNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let classDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    private let classSwitch : UISwitch = {
        let turnOnandOff = UISwitch()
        turnOnandOff.isOn = true
        return turnOnandOff
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(classColor)
        addSubview(classNameLabel)
        addSubview(classDescriptionLabel)
        addSubview(classSwitch)
        
    
        classColor.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 20, paddingRight: 0, width: frame.size.width / 6 , height: 0, enableInsets: false)
        classNameLabel.anchor(top: topAnchor, left: classColor.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 20, paddingRight: 0, width: frame.size.width / 4 , height: 0, enableInsets: false)
        classDescriptionLabel.anchor(top: topAnchor, left: classNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 4, height: 0, enableInsets: false)
         classSwitch.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 4, height: 0, enableInsets: false)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
