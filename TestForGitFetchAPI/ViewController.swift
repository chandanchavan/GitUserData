//
//  ViewController.swift
//  TestForGitFetchAPI
//
//  Created by Rushikesh Nikam on 21/01/19.
//  Copyright © 2019 chandan chavan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Declaring component of View
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var myGitDataTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Local variable Declaration
    var arrOFUserData : [GitUserDataModel]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        setUpUI()
    }
    //Method for Set UI
    func setUpUI() -> Void {
        btnSearch.layer.cornerRadius = 5.0
        btnSearch.layer.borderColor = UIColor.white.cgColor
        btnSearch.layer.borderWidth = 2.0
        
        self.myGitDataTableView.tableFooterView = UIView()
        self.myGitDataTableView.estimatedRowHeight = 133.0
        self.myGitDataTableView.rowHeight = UITableView.automaticDimension
    }
    //Method For Search Button
    @IBAction func btnSearchClicked(_ sender: Any) {
        var userName = ""
        if txtUsername.text == ""
        {
            showErrorPopup(msg: "Please enter the user name")
            return
        }else{
            userName = txtUsername.text!
        }
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.getGitUserDataFromServer(userName: userName) { (response, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if error != nil {
                self.showErrorPopup(msg: error?.localizedDescription ?? "Please Try Again")
                return
            } else if let dictionaryData = response {
                self.arrOFUserData.removeAll()
                let obj = GitUserDataModel(jsonObject:dictionaryData)
                self.arrOFUserData.append(obj)
                DispatchQueue.main.async {
                    self.myGitDataTableView.isHidden = false
                    self.myGitDataTableView .reloadData()
                    self.activityIndicator.hidesWhenStopped = true
                    self.activityIndicator.stopAnimating()
                }
            } else {
                self.showErrorPopup(msg: error?.localizedDescription ?? "Something went wrong. Please Try Again")
                return
            }
        }
        
    }
    func showErrorPopup(msg : String) -> Void {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrOFUserData.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : GitUserDataCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GitUserDataCell
        cell.setData(data: arrOFUserData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pushVC = storyboard.instantiateViewController(withIdentifier: "gitvc")as!GItUserDetailViewController
        pushVC.userData = self.arrOFUserData[indexPath.row]
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill,completion : @escaping (_ sucess : Bool )-> Void) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(false)
                    return
                    
            }
            DispatchQueue.main.async() {
                self.image = image
                completion(true)
            }
            }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit,completionBlock : @escaping (_ sucess : Bool )-> Void) {
        guard let url = URL(string: link) else {
            completionBlock(false)
            return }
        self.downloaded(from: url, contentMode: mode) { (sucess) in
            completionBlock(sucess)
        }
    }
}
