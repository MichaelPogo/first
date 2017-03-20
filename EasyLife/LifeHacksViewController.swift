import UIKit

class LifeHacksViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    //selected category from the Previous TableViewController
    var category:String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category);
        // Do any additional setup after loading the view.
    }

   
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = Bundle.main.loadNibNamed("LifeHackTableViewCell", owner: self, options: nil)?[0] as! LifeHackTableViewCell;
            cell.setlhData(LifeHackData(img: #imageLiteral(resourceName: "cabelLifehack"), desc: "descriptionfgjhdfkvnksadjvnskjdvhaslkdjfalfivjldgajvnlksdjlasfkhaslkdfjalsfkgasdjlvjruvdnkjfajsldkfjawprigjasrkdfjasklghjfalKFJPWQFJAWKRLDFJALSKRGJFARKGJEWQAELFJWLA", user: "user"));
      
           return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let img = #imageLiteral(resourceName: "cabelLifehack");
        let imgHeight  = img.size.height;
        let imgWidth   = img.size.width;
        let calcHeight = imgHeight/imgWidth*tableView.frame.width;
        return calcHeight+100;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "lifeHackPost");
        present(controller!, animated: true, completion: nil);
    }
    
    //set the category variable, method called from previous TableViewController
    func getCategory(category:String){
        self.category = category;
    }
    // move back to the first ViewController
    @IBAction func backToMain(_ btn:UIButton){
        dismiss(animated: true, completion: nil);
    }

}
