//
//  GItUserDetailViewController.swift
//  TestForGitFetchAPI
//
//  Created by Rushikesh Nikam on 21/01/19.
//  Copyright © 2019 chandan chavan. All rights reserved.
//

import UIKit

class GItUserDetailViewController: UIViewController {
    //IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHeaderLoginName: UILabel!
    @IBOutlet weak var lblHeaderFollwers: UILabel!
    @IBOutlet weak var lblHeaderPblicGits: UILabel!
    @IBOutlet weak var lblHeaderPublicRepo: UILabel!
    @IBOutlet weak var lblHeaderFollowrsUrl: UILabel!
    @IBOutlet weak var lblHeaderLocation: UILabel!
    @IBOutlet weak var lblHeaderUpdatedAt: UILabel!
    @IBOutlet weak var lblLoginName: UILabel!
    @IBOutlet weak var lblFollwers: UILabel!
    @IBOutlet weak var lblPblicGits: UILabel!
    @IBOutlet weak var lblPublicRepo: UILabel!
    @IBOutlet weak var lblFollowrsUrl: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUpdatedAt: UILabel!
    //Local variable Decleration
    var userData = GitUserDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI() //Setting the UI
        setData(data: self.userData) // Setting the data
    }
    func setUPUI() {
        imgView.layer.borderWidth = 1
        imgView.layer.masksToBounds = false
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.clipsToBounds = true
    }
    func setData(data:GitUserDataModel ) -> Void {
        self.title = "User Details"
self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        lblLoginName.text = userData.login
        lblFollwers.text = userData.followers
        lblPblicGits.text = userData.public_gists
        lblPublicRepo.text = userData.public_repos
        lblFollowrsUrl.text = userData.followers_url
        lblLocation.text = userData.location
        lblUpdatedAt.text = userData.updated_at
        if (userData.image != nil) {
            self.imgView.image = userData.image
        }else {
            self.imgView.downloaded(from: userData.avatar_url) { (sucess) in
                self.userData.image = self.imgView.image
            }
        }
    }
    @IBAction func btnShareClicked(_ sender: Any) {
    let text = "This is sharing Git user infomation"
    let url = NSURL(string: "\(userData.login), \(userData.followers_url)")
        let vc = UIActivityViewController(activityItems: [text,url as Any], applicationActivities: [])
        if let popovercontroller = vc.popoverPresentationController
        {
            popovercontroller.sourceView = self.view
            popovercontroller.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
    }
}
