//
//  ViewController.swift
//  BostonHacksImgToRingtone
//
//  Created by Jay Ravaliya on 10/31/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit
import Alamofire
import AddressBook
import AddressBookUI
import SwiftAddressBook

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView!
    var contacts : [SwiftAddressBookPerson]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBarHidden = false
        self.title = "tonifai"
        
        let status : ABAuthorizationStatus = SwiftAddressBook.authorizationStatus()
        let addressBook : SwiftAddressBook? = swiftAddressBook
        
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        contacts = []
        
        swiftAddressBook?.requestAccessWithCompletion { (success, err) -> Void in
            
            if success {
                
                if let people = addressBook?.allPeople {
                    for person in people {
                        if person.image != nil && person.phoneNumbers != nil {
                            self.contacts.append(person)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        cell?.textLabel?.text = contacts[indexPath.row].firstName! + " " + contacts[indexPath.row].lastName!
        cell?.imageView?.image = contacts[indexPath.row].image
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let person : SwiftAddressBookPerson = contacts[indexPath.row]
        let numbers = person.phoneNumbers?.map( ({$0.value}) )
        var usageNumber : String!
        for number in numbers! {
            usageNumber = number
        }
        postToBackend(contacts[indexPath.row].image!, phoneNumber: usageNumber)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func postToBackend(img : UIImage, phoneNumber : String) {
        
        let imageData = UIImagePNGRepresentation(img)
        let baseString : String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)))!
        
        let parameters : [String : String] = [
            "image" : baseString,
            "number" : phoneNumber
        ]
        
        Alamofire.request(Method.POST, "http://jayravaliya.com:5000", parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil).responseJSON { (request, response, result) -> Void in
            
            if result.isSuccess {
                print("Successfully posted!")
            }
            else {
                print("Uh oh!")
            }
            
        }
        
    }
}

