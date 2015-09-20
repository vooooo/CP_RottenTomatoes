//
//  DvdsViewController.swift
//  RottenTomatoes
//
//  Created by vu on 9/19/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class DvdsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var dvds: [NSDictionary]?
    let dvdUrl = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchDvds()
    }
    
    func fetchDvds() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.dvds = []
        
        let request = NSURLRequest(URL: self.dvdUrl, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 5)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let json = data {
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(json, options: []) as! NSDictionary
                self.dvds = responseDictionary["movies"] as? [NSDictionary]
                self.tableView.hidden = false
                self.tableView.reloadData()
                sleep(1)
                
                NSLog("response: \(self.dvds)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dvds?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DvdsCell",forIndexPath: indexPath) as! DvdCell
        
        let dvd = dvds![indexPath.row]
        
        cell.titleLabel.text = dvd["title"] as? String
        cell.synopsisLabel.text = dvd["synopsis"] as? String
        
        let posters = dvd["posters"] as! NSDictionary
        let thumbnail = posters["thumbnail"] as! String
        
        let url = NSURL(string: thumbnail)!
        cell.posterView.setImageWithURL(url)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let dvd = dvds![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        movieDetailsViewController.movie = dvd
    }

}
