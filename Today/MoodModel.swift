//
//  MoodModel.swift
//  Today
//
//  Created by Guest-Admin on 5/9/15.
//  Copyright (c) 2015 Viacom. All rights reserved.
//

import Foundation

class MoodModel: NSObject, Printable {
    let name: String
    let date: NSDate
    let facebookId: String
    let imageURL: String
    let city: String
    let weather: String
    let temperature: Int
    let moodIcon: String
    let mood: String
    
    init(name: String, date: NSDate, facebookId: String, imageURL: String, city: String, weather: String, temperature:Int, moodIcon: String, mood: String) {
        self.name = name
        self.date = date
        self.facebookId = facebookId
        self.imageURL = imageURL
        self.city = city
        self.weather = weather
        self.temperature = temperature
        self.moodIcon = moodIcon
        self.mood = mood
    }
}