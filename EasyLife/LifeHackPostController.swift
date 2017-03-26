//
//  LifeHackPostController.swift
//  EasyLife
//
//  Created by hackeru on 21 Adar 5777.
//  Copyright © 5777 hackeru. All rights reserved.
//

import UIKit

class LifeHackPostController: UIViewController {
    var img  : UIImage!;
    var text : String!;
    var imgView : UIImageView!;
    @IBOutlet var webView: UIWebView!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.width;
        imgView = UIImageView();
        imgView.frame=CGRect(x: 0, y: textView.frame.height+1, width: width, height: Utils.calcHeight(img:img,width:width));
        view.addSubview(imgView);
        textView.text = text;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToLifehacksList(_ sender: UIButton) {
        dismiss(animated: true, completion: nil);
    }
    func set(img:UIImage,text:String,youtubeUrl:Any?){
        self.img = img;
        self.text = text;
         /* if youtubeUrl != nil {
            let req = URLRequest(url: URL(string:youtubeUrl! as! String)!);
            print(youtubeUrl!);
            //webView.loadRequest(req);
 
        }
         */
    }

}
