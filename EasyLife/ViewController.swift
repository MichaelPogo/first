import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let bundle = Bundle.main;
    //array categories
    var categories   : [String] = [];
    var categoriesId : [String] = [];
    var imgs         : [UIImage]!;
    var isLoggedIn   = false;
    let backendless  = Utils.backendless;
    let uService     = Utils.backendless.userService!;
    let user         = BackendlessUser();
    
    @IBOutlet var signInOut: UIButton!
    @IBOutlet var uInfo: UILabel!
    @IBOutlet var tbl: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.assignbackground(view: view);
        if categories.isEmpty{
            Utils.showActivityIndicatory(uiView: view);
        }
        //loading categories from Backendless
        Utils.myFind("Categories", resHandler: {(res) in
            for r in res!.data as! [[String:Any]]{
                self.categories.append(r["name"] as! String);
                self.categoriesId.append(r["objectId"]as!String);
            }
            Utils.hideActivityIndicator();
            self.tbl.reloadData();
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        uService.isValidUserToken({(res)in
            let isLoggedIn = res!.boolValue
            if isLoggedIn{
                self.isLoggedIn = isLoggedIn;
                self.uInfo.text = "Welcome back\n\(self.uService.currentUser.name as String)!";
                self.signInOut.setTitle("SignOut", for: .normal);
            }
            }, error: {(fault)in
                self.uInfo.text = "Guest";
                
        })
        
    }
    
    // TableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bundle.loadNibNamed("CatsTableViewCell", owner: self, options: nil)?[0] as! CatsTableViewCell;
        cell.label.text = categories[indexPath.row];
        cell.layer.cornerRadius=15;
        //cell.img.image = UIImage(named: "worktools");
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let controller = storyboard?.instantiateViewController(withIdentifier: "lifeHacksList") as! LifeHacksViewController;
        controller.getCategory(categoryId: self.categoriesId[indexPath.row],categoryName:self.categories[indexPath.row],isLoggedIn:isLoggedIn);
        present(controller, animated: true, completion: nil);
    }
    // check the code when Internet connection is available
    @IBAction func login(_ sender: UIButton) {
        if isLoggedIn{
            uService.logout({(res)in
                self.uInfo.text = "Guest";
                sender.setTitle("SignIn", for: .normal);
                self.isLoggedIn = false;
                }, error: {(fault)in
                    print("server error can't logout");
            })
            return;
        }
        let alert = UIAlertController(title: "Login:", message: nil, preferredStyle: .alert);
        var uName,uPass : UITextField!;
        alert.addTextField(configurationHandler: {(input) in
            uName = input;
            uName.placeholder = "eMail";
            });
        alert.addTextField(configurationHandler: {(input) in
            uPass = input;
            uPass.placeholder = "password";
            uPass.isSecureTextEntry = true;
        });
        alert.addAction(UIAlertAction(title: "login", style: .default, handler: {(a)in
            //add code here
            self.uService.login(uName.text, password: uPass.text, response: {(res)in
                self.uInfo.text = "Welcome back \(res?.name as! String)!";
                self.signInOut.setTitle("SignOut", for: .normal);
                self.isLoggedIn = true;
                self.uService.setStayLoggedIn(true);
                
                }, error: {(fault)in
                    Utils.PresentMessageAlert(viewController: self, title: "Error:", message: "wrong userName or password", btnTitle: "ok");
            })
        }));
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil));
        present(alert, animated: true, completion: nil);
    }
}

