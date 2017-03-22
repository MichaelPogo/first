//
//  ViewController.swift
//  EasyLife
//
//  Created by hackeru on 18 Adar 5777.
//  Copyright © 5777 hackeru. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let bundle = Bundle.main;
    //array categories
    var categories:[String] = [];
    var categoriesId:[String] = [];
    var imgs:[UIImage]!;
    let backendless = Utils.backendless;
    let user: BackendlessUser = BackendlessUser();
    @IBOutlet var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading categories from plist
        Utils.myFind("Categories", resHandler: {(res) in
            for r in res!.data as! [[String:Any]]{
                self.categories.append(r["name"] as! String);
                self.categoriesId.append(r["objectId"]as!String);
            }
            self.tbl.reloadData();
        })
        
    }
    
    // TableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bundle.loadNibNamed("CatsTableViewCell", owner: self, options: nil)?[0] as! CatsTableViewCell;
        cell.label.text = categories[indexPath.row];
        //cell.img.image = UIImage(named: "worktools");
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let controller = storyboard?.instantiateViewController(withIdentifier: "lifeHacksList") as! LifeHacksViewController;
        controller.getCategory(categoryId: self.categoriesId[indexPath.row]);
        present(controller, animated: true, completion: nil);
    }
    
    @IBAction func login(_ sender: UIButton) {
        let alert = UIAlertController(title: "Login", message: nil, preferredStyle: .alert);
        var uName,uPass : UITextField!;
        alert.addTextField(configurationHandler: {(input) in
            uName = input;
            uName.placeholder = "user name";
            });
        
    }
    @IBAction func register(_ sender: UIButton) {
        
    }
}

