//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by vu on 9/17/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
        
    var movies: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        
//        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
//        let request = NSURLRequest(URL: url)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
//            if let json = data {
//                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(json, options: []) as! NSDictionary
//                self.movies = responseDictionary["movies"] as? [NSDictionary]
//                self.tableView.reloadData()
//                
//                NSLog("response: \(self.movies)")
//            } else {
//                if let e = error {
//                    NSLog("Error: \(e)")
//                }
//            }
//        }
        tableView.dataSource = self
        tableView.delegate = self
    }

    func fetchMovies() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let json = data {
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(json, options: []) as! NSDictionary
                self.movies = responseDictionary["movies"] as? [NSDictionary]
                self.tableView.reloadData()
                sleep(2)
                
                NSLog("response: \(self.movies)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)

            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MoviesCell",forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String

        let posters = movie["posters"] as! NSDictionary
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
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        movieDetailsViewController.movie = movie
    }

}
