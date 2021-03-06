//
//  SquadronPickerViewController.swift
//  PEX3_CadetsWithFriends
//
//  Created by Dom Celiano on 11/6/16.
//  Copyright © 2016 Troy Weingart. All rights reserved.
//

import UIKit

class SquadronPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerDataSource = ["01 - Mach One", "02 - Deuce", "03 - Dogs of War", "04 - Fightin' Fourth", "05 - Wolfpack", "06 - Bull Six", "07 - Shadow Seven", "08 - Eagle Eight", "09 - Viking Nine", "10 - Tiger Ten", "11 - Rebeleven", "12 - Dirty Dozen", "13 - Bulldawgs", "14 - Cobras", "15 - Warhawks", "16 - Chickenhawks", "17 - Stalag", "18 - Nightriders", "19 - Wolverines", "20 - Trolls", "21 - Blackjacks", "22 - Raptors", "23 - Barnstormers", "24 - Phantoms", "25 - Redeye", "26 - Barons", "27 - Thunderbirds", "28 - Blackbirds", "29 - Black Panthers", "30 - Knights of Thirty", "31 - Grim Reapers", "32 - Road Runners", "33 - King Ratz", "34 - Loose Hawgs", "35 - Wild Weasels", "36 - Pink Panthers", "37 - Animalistic Skyraiders", "38 - All-Stars", "39 - Campus Rads", "40 - Warhawks"] //these squads show up in the picker
    
    //the functions below are required by the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        (navigationController as! NewFriendNavigationController).squadronSelected = Int(String(String(pickerDataSource[row]).characters.prefix(2)))! //stupidly complicated
        let nav = navigationController as! NewFriendNavigationController
        (nav.viewControllers.first as! FriendDetailsTableViewController).updateSquadronLabel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
