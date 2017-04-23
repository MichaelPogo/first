import UIKit

class LifeHackPostController: UIViewController {
    var img  : UIImage!;
    var text : String!;
    var name : String!;
    var req : URLRequest?;
    @IBOutlet var webView: UIWebView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var uName: UILabel!
    @IBOutlet var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.width;
        imgView.frame.size = CGSize(width: 50, height: Utils.calcHeight(img: img, width: width));
        imgView.image = img;
        textView.text = text;
        if name != nil {
            self.uName.text = name;
        }else{
            self.uName.text = "";
        }
        if req != nil{
            
            webView.loadRequest(req!);
            
        }else{
            webView.loadHTMLString("<html><body><h1>No video attached</h1></body></html>", baseURL: nil)
        }
    }

    @IBAction func backToLifehacksList(_ sender: UIButton) {
        dismiss(animated: true, completion: nil);
    }
    func set(img:UIImage,text:String,youtubeUrl:Any?,uName:String?){
        self.img = img;
        self.text = text;
        self.name = uName;
        
        if !(youtubeUrl is NSNull) {
            let req = URLRequest(url: URL(string:youtubeUrl! as! String)!);
            print(req);
            self.req = req;
        }
        
    }
    

}
