//
//  Filters.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/14/15.
//

import Foundation

class Category {
 
    let title : String = {
        return "Category"
    }()
    
    let category : Array<Dictionary<String,String>> = {
       return [["Indian":"indpak"], ["Asian Fusion":"asianfusion"], ["American":"newamerican"]]
    }()
    
    func count() -> Int {
        return category.count
    }
  
}

class Sort {
    let title : String = {
      return "Sort"
    }()
    
    let sort : Array<Dictionary<String,Int>> = {
        return [["Match":0], ["Distance":1], ["Rating":2]]
    }()
    
    func count() -> Int {
        return sort.count
    }
}

class Distance {
    let title : String = {
        return "Distance"
        }()
    
    let distance : Array<Int> = {
        return [100, 1600, 8046]
    }()
    
}

