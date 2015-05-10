//
//  MoodsTableViewController.swift
//  Today
//
//  Created by Guest-Admin on 5/9/15.
//  Copyright (c) 2015 Viacom. All rights reserved.
//

import UIKit

class MoodsTableViewController: UITableViewController, UITableViewDataSource {

    var moods = [MoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var session = NSURLSession.sharedSession()
        let url = "https://api.myjson.com/bins/19uud"
        
        DataManager.loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            if let urlData = data {
                let json = JSON(data: urlData)
                if let moodsArray = json.array {
                    for moodDict in moodsArray {
                        var name: String? = moodDict["name"].string
                        var facebookId: String? = moodDict["facebookId"].string
                        var imageURL: String? = moodDict["imageURL"].string
                        var city: String? = moodDict["city"].string
                        var weather: String? = moodDict["weather"].string
                        var temperature: Int? = moodDict["temperature"].string!.toInt()
                        var moodIcon: String? = moodDict["moodIcon"].string
                        var mood: String? = moodDict["mood"].string
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd";
                        var date = dateFormatter.dateFromString(moodDict["date"].string!)
                        
                        var moodModel = MoodModel(name: name!, date: date!, facebookId: facebookId!, imageURL: imageURL!, city: city!, weather:weather!, temperature: temperature!, moodIcon: moodIcon!, mood: mood!)
                        self.moods.append(moodModel);
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.moods.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoodCell", forIndexPath: indexPath) as! MoodTableViewCell
        
        var mood = moods[indexPath.row] as MoodModel

        cell.name?.text = mood.name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        cell.date?.text = dateFormatter.stringFromDate(mood.date)
        
        ImageLoader.sharedLoader.imageForUrl("http://graph.facebook.com/"+mood.facebookId+"/picture?type=square", completionHandler:{(image: UIImage?, url: String) in
            cell.avatar?.image = image
            cell.avatar?.layer.cornerRadius = 25.0
            cell.avatar?.layer.masksToBounds = true
        })
        
        ImageLoader.sharedLoader.imageForUrl(mood.imageURL, completionHandler:{(image: UIImage?, url: String) in
            cell.img?.image = image
        })
        
        ImageLoader.sharedLoader.imageForUrl("http://openweathermap.org/img/w/"+mood.weather+".png", completionHandler:{(image: UIImage?, url: String) in
            cell.weather?.image = image
        })
        
//        let urlAvatar = NSURL(string:"http://graph.facebook.com/"+mood.facebookId+"/picture")
//        let dataAvatar = NSData(contentsOfURL: urlAvatar!)
//        cell.avatar?.image = UIImage(data: dataAvatar!)
        
//        let urlImage = NSURL(string:mood.imageURL)
//        let dataImage = NSData(contentsOfURL: urlImage!)
//        cell.img?.image = UIImage(data: dataImage!)
        
        cell.city?.text = mood.city
        cell.temperature?.text = String(mood.temperature)+"°"
        cell.mood?.text = mood.mood
        
        cell.greyBackground?.backgroundColor = UIColor(white: 0.4, alpha: 0.6)
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
