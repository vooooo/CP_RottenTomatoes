//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by vu on 9/17/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var errorCell: ErrorViewCell!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary]?
    var filtered: [NSDictionary]? = []
    
    let moviesUrl = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
    let dvdUrl = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorCell.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchMovies", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchMovies()
        
    }

    func fetchMovies() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.movies = []
    
        let request = NSURLRequest(URL: self.moviesUrl, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 5)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let json = data {
                self.errorCell.hidden = true
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(json, options: []) as! NSDictionary
                self.movies = responseDictionary["movies"] as? [NSDictionary]
                self.tableView.hidden = false
                self.tableView.reloadData()
                sleep(1)

                self.refreshControl.endRefreshing()
                
                NSLog("response: \(self.movies)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)

            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)

                    self.errorCell.hidden = false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return self.filtered?.count ?? 0
        }
        return self.movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviesCell",forIndexPath: indexPath) as! MovieCell
        
        let movie: NSDictionary
        if(searchActive) {
            movie = filtered![indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
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

    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filtered = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            
            let m = movie["title"] as! String
            return m.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        if(self.filtered?.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie: NSDictionary
        if (searchActive) {
            movie = filtered![indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
    
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        movieDetailsViewController.movie = movie
    }

}
