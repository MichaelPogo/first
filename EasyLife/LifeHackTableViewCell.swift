import UIKit

class LifeHackTableViewCell: UITableViewCell {
    var img     : UIImageView!;
    var lhData  : LifeHacksData!;
    @IBOutlet var desc: UILabel!
    @IBOutlet var uName: UILabel!;
    @IBOutlet var detailsView: UIView!
    //set the data to use in the cell, method called in the TableViewController
    func setlhData(_ lhData: LifeHacksData){
        self.lhData=lhData;
        
    }

    override func draw(_ rect: CGRect) {
        
        Utils.assignbackground(view: self);
        self.desc.text = lhData.txt;
        self.uName.text = lhData.uName;
        //get the cell width
        let cWidth  = bounds.width;
        //makes rounded corners at the bottom of the cell
        detailsView.layer.cornerRadius = 15;
        // create imageView dynamicly by calculating aspect ratio:
        img.image = lhData.img;
        img.frame=CGRect(x: 0, y: 0, width: cWidth, height: Utils.calcHeight(img:lhData.img,width:cWidth));
        addSubview(img);
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img     = UIImageView();
        Utils.assignbackground(view: self);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
