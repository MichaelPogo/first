
import UIKit

class NewPostController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let youtubeUrl = "https://www.youtube.com/watch?v=";
    let embedYoutubeUrl = "https://www.youtube.com/embed/";
    var youtubeFullUrl = "";
    var categoriesId:String = "";
    @IBOutlet var webView: UIWebView!
    @IBOutlet var youtubeURL: UITextField!
    @IBOutlet var youtubeVideoTitle: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var mainImg: UIImageView!
    
    
    @IBOutlet var otherBtn: UIButton!
    @IBOutlet var workToolsBtn: UIButton!
    @IBOutlet var menBtn: UIButton!
    @IBOutlet var kitchenBtn: UIButton!
    @IBOutlet var womenBtn: UIButton!
    @IBOutlet var officeBtn: UIButton!
    
    let imgPicker = UIImagePickerController();
   
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionText.layer.borderWidth = 2;
        mainImg.layer.borderWidth = 2;
        imgPicker.delegate = self;
    }
    

    @IBAction func addMainPhoto(_ sender: UIButton) {
        imgPicker.sourceType = .photoLibrary;
        show(imgPicker, sender: self);
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        dismiss(animated: true, completion: {
            self.mainImg.image = image;
        });
    }
    @IBAction func loadvid(_ sender: UITextField) {
        let str = sender.text!;
        if str.contains(youtubeUrl){
            let vidId = str.substring(from: youtubeUrl.characters.endIndex);
            youtubeFullUrl = embedYoutubeUrl+vidId;
            let req = URLRequest(url: URL(string: youtubeFullUrl)!);
            webView.loadRequest(req);
            webView.isHidden = false;
        }
    }
    @IBAction func selectCategory(_ btn:UIButton){
        
        if btn.backgroundColor != UIColor.green{
            btn.backgroundColor = UIColor.green;
        }else{btn.backgroundColor = UIColor.clear}
        
    }
    
    @IBAction func createPost(_ sender: UIButton) {
        selectedBtnTitles(btns: menBtn,officeBtn,womenBtn,workToolsBtn,kitchenBtn,otherBtn);
        
        Utils.showActivityIndicatory(uiView: view);
        let jpg=UIImageJPEGRepresentation(mainImg.image!, 0.5);
        let fileName = "IMG_\(Utils.uService.currentUser.name!)_\(Date().timeIntervalSince1970).jpg";
        //upload photo to backendless
        Utils.backendless.file.upload("media/\(fileName)", content: jpg, response: {(resFile)in
            let postDic:[String:Any] = ["text":self.descriptionText.text,"youtubeId":self.youtubeFullUrl,"mainImage":resFile!.fileURL!,"ownerId":Utils.uService.currentUser.objectId!,"categories":self.categoriesId];
            //upload new Post to backendless
            Utils.backendless.data.ofTable("Posts").save(postDic, response: {(res)in
                print("successfully uploaded");
                Utils.hideActivityIndicator();
                self.dismiss(animated: true, completion: nil);
                //uploading post fault
                }, error: {(fault)in
                    print("***********************failed with code:\(fault!.message)");
                    Utils.hideActivityIndicator();
                    Utils.PresentMessageAlert(viewController: self, title: "Server Error", message: "couldn't create post, please try again later", btnTitle: "ok");
                })
            //image upload fault
            }, error: {(fault)in
                Utils.hideActivityIndicator();
                Utils.PresentMessageAlert(viewController: self, title: "Server Error", message: "couldn't upload photo", btnTitle: "ok");
        })
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func endEditing(_ sender: UIButton) {
        view.endEditing(true);
    }
    private func selectedBtnTitles(btns:UIButton...){
        for b in btns{
            if b.backgroundColor == UIColor.green{
                categoriesId += getObjectId(category: (b.titleLabel?.text!)!)+";";
            }
        }
    }
    private func getObjectId(category:String)->String{
        switch category {
        case "men":
            return "DD530F44-24CD-CC60-FF60-5C0791523600";
        case "women":
            return "4ECCB18B-D0CE-83F3-FFDE-78B0FF5A6200"
        case "kitchen":
            return "C07FBF96-A3A8-8F6F-FF77-013E0F5DCC00";
        case "workTools":
            return "B3B6768D-7B41-3299-FFD6-3D62210D3B00";
        case "office":
            return "53B210E7-6844-2F01-FF12-F621B3D61500";
        case "other":
            return "21CBE6C4-3815-B22B-FFB8-3388F2A80C00";
        default:
            return "";
        }
    }
}
