//
//  GitUserDataCell.swift
//  TestForGitFetchAPI
//
//  Created by Rushikesh Nikam on 21/01/19.
//  Copyright © 2019 chandan chavan. All rights reserved.
//

import UIKit

class GitUserDataCell: UITableViewCell {
    //Outlet for cell
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(data : GitUserDataModel) -> Void {
        if data.name != ""
        {
            self.lblName.text = data.name
        }
        else{
            self.lblName.text = data.login
        }
        self.activityIndicator.stopAnimating()
        if (data.image != nil) {
            self.imgView.image = data.image
        }else {
            self.activityIndicator.startAnimating()
            self.imgView.downloaded(from: data.avatar_url) { (sucess) in
                data.image = self.imgView.image
                self.activityIndicator.stopAnimating()
            }
        }
        self.backgroundCellView?.layer.cornerRadius = 8.0
        self.backgroundCellView?.layer.masksToBounds = true
        
        
        imgView.layer.borderWidth = 1
        imgView.layer.masksToBounds = false
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.clipsToBounds = true
    }
}
