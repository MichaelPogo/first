import Foundation
public class Utils{
    private static var actInd       : UIActivityIndicatorView!;
    private static var container    : UIView!;
    private static var loadingView  : UIView!;
    public static let backendless = Backendless.sharedInstance()!;
    public static let uService = Utils.backendless.userService!;
    public static func calcHeight(img:UIImage,width:CGFloat)->CGFloat{
        let iHeight = img.size.height;
        let iWidth = img.size.width;
        if iWidth > iHeight{
            return iHeight / iWidth * width;
        }else{
            return iWidth / iHeight * width
        }
    }
    //setting background
    static func assignbackground(view:UIView){
        let imageView  = UIImageView(frame: view.bounds);
        imageView.alpha = 0.4;
        imageView.contentMode =  UIViewContentMode.scaleAspectFill;
        imageView.clipsToBounds = true;
        imageView.image = UIImage(named: "bg_image.jpg");
        imageView.center = view.center;
        view.addSubview(imageView);
        view.sendSubview(toBack: imageView);
    }
    static func myFind(_ tblName:String , resHandler:@escaping (BackendlessCollection?)->Void){
        backendless.data.ofTable(tblName).find(resHandler, error: {(e)in
            //logout to fix token problem
            uService.logout();
            print("couldn't load data with error code \(e?.faultCode!), message:\(e?.message!)");
        })
    }
    static func myFind(_ tblName:String, dataQuery:BackendlessDataQuery , resHandler:@escaping (BackendlessCollection?)->Void){
        backendless.data.ofTable(tblName).find(dataQuery,response: resHandler, error: {(e) in
            //logout to fix token problem
            uService.logout();
            print("couldn't load data with error code \(e?.faultCode!), message:\(e?.message!)");
        })
    }
    static func PresentMessageAlert(viewController:UIViewController,title:String?,message:String?,btnTitle:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: {(a)in
            viewController.dismiss(animated: true, completion: nil);
        }))
        viewController.present(alert, animated: true, completion: nil);
    }
    static func showActivityIndicatory(uiView: UIView) {
        container   = UIView();
        loadingView = UIView();
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
        
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
    }
    static func hideActivityIndicator(){
        actInd.stopAnimating();
        container.isHidden=true;
    }
    private static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
   }
