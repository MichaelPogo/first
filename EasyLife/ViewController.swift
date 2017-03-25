import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let bundle = Bundle.main;
    //array categories
    var categories:[String] = [];
    var categoriesId:[String] = [];
    var imgs:[UIImage]!;
    let backendless = Utils.backendless;
    //let backendlessUser = BackendlessUser();
    let uService = Utils.backendless.userService!;
    let user: BackendlessUser = BackendlessUser();
    @IBOutlet var uInfo: UILabel!
    @IBOutlet var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        uService.isValidUserToken({(res)in
            if res!.boolValue{
            self.uInfo.text = "Welcome back \(self.uService.currentUser.name as String)";
                }
            }, error: {(fault)in
                self.uInfo.text = "Guest";
        
        })
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
    // check the code when Internet connection is available
    @IBAction func login(_ sender: UIButton) {
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
                self.uInfo.text = res?.name as? String;
                self.uService.setStayLoggedIn(true);
                
                }, error: {(fault)in
                    Utils.PresentMessageAlert(viewController: self, title: "Error:", message: "wrong userName or password", btnTitle: "ok");
            })
        }));
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil));
        present(alert, animated: true, completion: nil);
    }
}

