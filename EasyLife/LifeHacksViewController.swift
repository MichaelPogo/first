import UIKit
class LifeHacksViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    //selected category from the Previous TableViewController
    var categoryId   : String = "";
    var categoryName : String = "";
    var isLoggedIn   = false;
    var lifehacks    : [LifeHacksData]=[];
    var filtLifehacks: [LifeHacksData]=[];
    let backendless  = Utils.backendless;
    
    @IBOutlet var tbl: UITableView!
    @IBOutlet var categoryLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.assignbackground(view: view);
        Utils.assignbackground(view: tbl);
        if filtLifehacks.isEmpty{
            Utils.showActivityIndicatory(uiView: view);
        }
        categoryLabel.text = categoryName;
        //reminder: add query to reuest: 
        Utils.myFind("Posts", resHandler: {(res) in
            
            for p in res?.data as! [[String:Any]]{
                //Split the categories Id's and iterate over them
                let catsId = (p["categories"] as! String).components(separatedBy: ";");
                for id in catsId{
                    
                    if id == self.categoryId{
                        let data = try! Data(contentsOf: URL(string: p["mainImage"] as! String)!);
                        let lh = LifeHacksData();
                        self.lifehacks.append(lh.set(img: UIImage(data: data)!).set(txt: p["text"] as! String).set(youtubeUrl:p["youtubeId"]));
                        if let id = p["ownerId"] as? String{
                            let dataQuery = BackendlessDataQuery();
                            dataQuery.whereClause = "objectId = '\(id)'";
                            self.backendless.persistenceService.ofTable("Users").find(dataQuery, response: {(res)in
                                    let myDict = res!.data.first as! NSDictionary;
                                    lh.set(uName: myDict["name"]! as! String);
                                    self.tbl.reloadData();
                                }
                                , error: {(e)in
                                    print("****************could not load user names");
                            })
                        }else{print("no owner");}
                    }
                }
            }
            self.reset();
            Utils.hideActivityIndicator();
        })
    }

    @IBAction func endEditing(_ sender: UIButton) {
        view.endEditing(true);
    }
    @IBAction func filterSearch(_ sender: UITextField) {
        let str = sender.text!;
        print(str);
        if str.isEmpty{
            reset();
        }else{
            filtLifehacks.removeAll();
            for h in lifehacks{
                if h.txt.contains(str){
                    filtLifehacks.append(h);
                }
            }
            tbl.reloadData();
        }
    }
    
    private func reset(){
        filtLifehacks = lifehacks;
        tbl.reloadData();
    }
   
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtLifehacks.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("LifeHackTableViewCell", owner: self, options: nil)?[0] as! LifeHackTableViewCell;
        cell.setlhData(filtLifehacks[indexPath.row]);
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let img = filtLifehacks[indexPath.row].img;
        return Utils.calcHeight(img:img!,width:tableView.frame.width)+100;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "lifeHackPost") as! LifeHackPostController;
        let lhIndex = lifehacks[indexPath.row];
        controller.set(img: lifehacks[indexPath.row].img, text: lhIndex.txt,youtubeUrl: lhIndex.youtubeUrl,uName: lhIndex.uName);
        present(controller, animated: true, completion: nil);
    }
    
    //set the category variable, method called from previous TableViewController
    func getCategory(categoryId:String,categoryName:String, isLoggedIn:Bool){
        self.categoryId = categoryId;
        self.categoryName = categoryName;
        self.isLoggedIn = isLoggedIn;
    }
    // move back to the first ViewController
    @IBAction func backToMain(_ btn:UIButton){
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func moveToNewPostController(_ sender: UIButton) {
        if isLoggedIn{
            let c = storyboard?.instantiateViewController(withIdentifier: "newPost") as! NewPostController;
            show(c, sender: self);
        }else{
            
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
                Utils.uService.login(uName.text, password: uPass.text, response: {(res)in
                    Utils.uService.setStayLoggedIn(true);
                    
                    }, error: {(fault)in
                        Utils.PresentMessageAlert(viewController: self, title: "Error:", message: "wrong userName or password", btnTitle: "ok");
                })
            }));
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil));
            present(alert, animated: true, completion: nil);
            
        }
    }
    

}
    
