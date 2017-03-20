import UIKit

class LifeHackTableViewCell: UITableViewCell {
    
    var desc    : UILabel!;
    var user    : UILabel!;
    var details : UIButton!;
    var img     : UIImageView!;
    var lhData  : LifeHackData!;
    @IBOutlet var detailsView: UIView!
    //set the data to use in the cell, method called in the TableViewController
    func setlhData(_ lhData: LifeHackData){
        self.lhData=lhData;
        
    }

    override func draw(_ rect: CGRect) {
        //get the cell width
        let cWidth  = bounds.width;
        //makes rounded corners at the bottom of the cell
        detailsView.layer.cornerRadius = 15;
        // create imageView dynamicly by calculating aspect ratio:
        let imgWidth = lhData.img.size.width;//for aspect ratio calc
        let imgHeight = lhData.img.size.height/imgWidth*cWidth;//
        img.image = lhData.img;
        img.frame=CGRect(x: 0, y: 0, width: cWidth, height: imgHeight);
        addSubview(img);
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //instantiations
        self.desc    = UILabel();
        self.user    = UILabel();
        self.details = UIButton();
        self.img     = UIImageView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}








// create button dynamicly doesn't do anything for now
/*details.setTitle("Details>", for: .normal);
 details.sizeToFit();
 details.frame.origin = CGPoint(x:cWidth-details.frame.width,y:imgHeight+1);
 addSubview(details);
 // create label dynamicly for text
 desc.frame.size.width = cWidth-details.frame.width;
 desc.frame.origin = CGPoint(x: 0, y: imgHeight+1);
 desc.numberOfLines = 2
 desc.text = lhData.desc;
 desc.font = desc.font.withSize(20);
 desc.sizeToFit();
 addSubview(desc);
 // create label for user info;
 user.text = lhData.user;
 user.frame.origin = CGPoint(x: 0, y: imgHeight+desc.frame.height+1);
 user.font = user.font.withSize(20);
 user.sizeToFit();
 addSubview(user);
 //height of desc + user WITH FONT SIZE OF 20 is: 72;
 print("*********** user height: \(user.frame.height)");
 print("########### desc height: \(desc.frame.height)");*/
