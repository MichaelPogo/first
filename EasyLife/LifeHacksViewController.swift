import UIKit

class LifeHacksViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    //selected category from the Previous TableViewController
    var categoryId:String="";
    var lifehacks:[LifeHackData]=[];
    var filtLifehacks:[LifeHackData]=[];
    let backendless = Utils.backendless;
    @IBOutlet var tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.myFind("Posts", resHandler: {(res) in
            
            for p in res?.data as! [[String:Any]]{
                //make iteration on categoriesId
                let catsId = (p["categories"] as! String).components(separatedBy: ";");
                for id in catsId{
                    if id == self.categoryId{
                        let data = try! Data(contentsOf: URL(string: p["image"] as! String)!);
                        self.lifehacks.append(LifeHackData(img: UIImage(data: data)! , desc: p["text"]as!String, user: "user"));
                    }
                }
                
            }
            self.reset();
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
                if h.desc.contains(str){
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
        return Utils.calcHeight(img:img,width:tableView.frame.width)+100;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "lifeHackPost");
        present(controller!, animated: true, completion: nil);
    }
    
    //set the category variable, method called from previous TableViewController
    func getCategory(categoryId:String){
        self.categoryId = categoryId;
    }
    // move back to the first ViewController
    @IBAction func backToMain(_ btn:UIButton){
        dismiss(animated: true, completion: nil);
    }
    
    

}
    
