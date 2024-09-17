//
//  StructStorageViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/22/24.
//

import Foundation


struct Users {
    var user_id : String
    var userName: String
    var zipcode : Int
    var insurance : String
}

struct Car {
    var user_id : String
    var make : String
    var model : String
    var color : String
    var group_id : String
    var vin_number : String?
    var location: [(Float, Float)]
}
