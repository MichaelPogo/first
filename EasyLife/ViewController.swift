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
    var imgs:[UIImage]!;
    let backendless = Backendless.sharedInstance()!;
    let user: BackendlessUser = BackendlessUser();
    override func viewDidLoad() {
        super.viewDidLoad()
        //loading categories from plist
        categories = NSArray(contentsOfFile: bundle.path(forResource: "Categories", ofType: "plist")!) as! Array;
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
        controller.getCategory(category: self.categories[indexPath.row]);
        present(controller, animated: true, completion: nil);
    }
    
}

