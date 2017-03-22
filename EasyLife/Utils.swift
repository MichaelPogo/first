import Foundation
public class Utils{
    public static let backendless = Backendless.sharedInstance()!;
    
    public static func calcHeight(img:UIImage,width:CGFloat)->CGFloat{
        let iHeight = img.size.height;
        let iWidth = img.size.width;
        if iWidth > iHeight{
            return iHeight / iWidth * width;
        }else{
            return iWidth / iHeight * width
        }
    }
    
/*    public static func findFromBls(tblName:String)->[[String:Any]]?{
        var result : [[String:Any]]!;
        backendless.data.ofTable(tblName).find({(res) in
                result = res!.data as! [[String:Any]];
            }
            , error: {(e)in
                print("couldn't load data with error code \(e?.faultCode)");
            })
        return result;
    }
 */
    static func myFind(_ tblName:String , resHandler:@escaping (BackendlessCollection?)->Void){
        backendless.data.ofTable(tblName).find(resHandler, error: {(e)in
            print("couldn't load data with error code \(e?.faultCode)");
        })
    }
}
