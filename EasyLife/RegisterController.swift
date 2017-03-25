//
//  RegisterController.swift
//  EasyLife
//
//  Created by hackeru on 25 Adar 5777.
//  Copyright © 5777 hackeru. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    var uNames : [String] = [];
    var validUser:Bool = false;
    @IBOutlet var userName : UITextField!
    @IBOutlet var eMail    : UITextField!
    @IBOutlet var pass     : UITextField!
    @IBOutlet var cPass    : UITextField!
    var actInd      : UIActivityIndicatorView!;
    var container   : UIView!;
    var loadingView : UIView!;
    override func viewDidLoad() {
        super.viewDidLoad()
        designTextFields(userName,eMail,pass,cPass);
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
        container = UIView();
        loadingView = UIView();
        loadUNames();
        if uNames.isEmpty{
            showActivityIndicatory(uiView: view);
        }
    }
    @IBAction func validateUName(_ sender: UITextField) {
        
        let layer = userName.layer;
        let str = sender.text!;
        if str.isEmpty{
            layer.borderColor = UIColor.gray.cgColor;
            return;
        }
        
        for n in uNames{
            if n != str{
                layer.borderColor = UIColor.green.cgColor;
                validUser = true;
            }else{
                layer.borderColor = UIColor.red.cgColor;
                validUser = false;
                return;
                }
            }
        
    }

    @IBAction func register(_ sender: UIButton) {
        if pass.text != cPass.text{
            pass.layer.borderColor  = UIColor.red.cgColor;
            cPass.layer.borderColor = UIColor.red.cgColor;
            cPass.text = "";
            return;
        }
        if validUser{
            
            let user = BackendlessUser()
            user.email    = eMail.text as NSString!;
            user.name     = userName.text as NSString!;
            user.password = pass.text as NSString!;
            
            Utils.backendless.userService.registering(user,
                  response: { (registeredUser) -> () in
                    Utils.PresentMessageAlert(viewController: self, title: "Registration Complete", message: "The user has been created", btnTitle: "\u{2714}");
                    print("User has been registered (ASYNC): \(registeredUser)");
            },
                  error: { (fault) -> () in
                    print("Server reported an error: \(fault)");
            })
            
        }
        
    }
    private func loadUNames(){
        
        Utils.myFind("Users", resHandler: {(res)in
            let result = res!.data as! [[String:Any]];
            for r in result {
                self.uNames.append(r["name"] as! String);
            }
            print("********\(self.uNames)");
            self.hideActivityIndicator();
        })
    }
    
    func showActivityIndicatory(uiView: UIView) {
       
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3);
        
        loadingView.frame = CGRect(x:0, y:0, width:100, height:100)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0, y: 0, width: 50, height: 50);
        actInd.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        actInd.hidesWhenStopped = true
        
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
        hideInputs(true);
    }
    private func hideActivityIndicator(){
        actInd.stopAnimating();
        container.isHidden=true;
        hideInputs(false);
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    private func hideInputs(_ bool:Bool){
        userName.isHidden = bool;
        eMail.isHidden = bool;
        pass.isHidden = bool;
        cPass.isHidden = bool;
    }
    
    private func designTextFields(_ tf:UITextField...){
        for t in tf {
            t.layer.borderWidth = 2;
            t.layer.borderColor = UIColor.gray.cgColor;
            t.layer.cornerRadius = 8;
        }
    }
}
