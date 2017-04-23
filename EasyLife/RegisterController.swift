
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
        Utils.assignbackground(view: view);
        designTextFields(userName,eMail,pass,cPass);
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
        container = UIView();
        loadingView = UIView();
        loadUNames();
        if uNames.isEmpty{
            Utils.showActivityIndicatory(uiView: view);
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
            Utils.hideActivityIndicator();
        })
    }
    
    private func designTextFields(_ tf:UITextField...){
        for t in tf {
            t.layer.borderWidth = 2;
            t.layer.borderColor = UIColor.gray.cgColor;
            t.layer.cornerRadius = 8;
        }
    }
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil);
    }
}
