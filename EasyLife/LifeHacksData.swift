import UIKit;
class LifeHacksData{
    var img:UIImage!;
    var txt:String!;
    var uName:String!;
    //set youtubeUrl as Any because it may be set as NSNull;
    var youtubeUrl:Any?;
    public init(){};
    public func set(img:UIImage)->LifeHacksData{
        self.img = img;
        return self;
    }
    public func set(txt:String)->LifeHacksData{
        self.txt = txt;
        return self;
    }
    public func set(uName:String)->LifeHacksData{
        self.uName = uName;
        return self;
    }
    public func set(youtubeUrl:Any)->LifeHacksData{
        self.youtubeUrl = youtubeUrl;
        return self;
    }
}
