//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by vu on 9/18/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        titleLabel?.sizeToFit()
        synopsisLabel?.sizeToFit()
        
        let posters = movie["posters"] as! NSDictionary
        
        //LOW RES IMAGE
        let original = posters["original"] as! String
        let url = NSURL(string: original)!
        imageView.setImageWithURL(url)
        
        loadLargeImage(original)
        //HIGH RES IMAGE


    }

    func loadLargeImage(original: String) {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            
            sleep(1)
            
            var large = original as! String
            let range = large.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                large = large.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            }
            
            let url = NSURL(string: large)!
            self.imageView.setImageWithURL(url)
            
            
            
        }
            
//            if let thumbnailUrl = story?.thumbnailUrl {
//                thumbnailView?.setImageWithURL(NSURL(string: thumbnailUrl))
//            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
