//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Aditya Jayaraman on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func didChangeFilters(sender: FiltersViewController, value: Dictionary<String,Int>)
}

class FiltersViewController: UITableViewController, SwitchCellDelegate, SegmentedCellDelegate {

    var filtersDict : Dictionary<String,Int>?
    var delegate : FiltersViewControllerDelegate?
    
    var filterSectionTitles : Dictionary<Int,String>?
    var filterSections : Dictionary<Int,Array<String>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SwitchCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "codepath.switchcell")
        
        let snib = UINib(nibName: "SegmentedCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(snib, forCellReuseIdentifier: "codepath.segmentedcell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.filterSectionTitles = Dictionary()
        self.filterSectionTitles?[0]  = "Category"
        self.filterSectionTitles?[1]  = "Sort"//best match, distance highest rated
        self.filterSectionTitles?[2]  = "Distance"//meters
        self.filterSectionTitles?[3]  = "Deals"//on/off

        self.filterSections = Dictionary()
        self.filterSections?[0] = Array<String>(arrayLiteral:"Indian", "Asian Fusion", "American")
        self.filterSections?[1]  = Array<String>(arrayLiteral:"Match", "Distance", "Rating")
        self.filterSections?[2]  = Array<String>(arrayLiteral:"Nearest", "1 Mile", "5 Miles")
        self.filterSections?[3]  = Array<String>(arrayLiteral:"Deals")

        
        println("viewDidLoad")
        var cancelButton = UIBarButtonItem(title: "Cancel", style: .Bordered, target: self, action: "onCancel")
        cancelButton.tintColor = UIColor.redColor()
        navigationItem.leftBarButtonItem = cancelButton
        
        var filterButton = UIBarButtonItem(title: "Filter", style: .Bordered, target: self, action: "onFilter")
        filterButton.tintColor = UIColor.redColor()
        navigationItem.rightBarButtonItem = filterButton
        
        navigationItem.title = "Yelp"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //load the filters dictionary from nsuserdefaults
        if let dict = NSUserDefaults.standardUserDefaults().dictionaryForKey("filtersDict") {
            println(dict)
            self.filtersDict = dict as Dictionary<String,Int>
        } else {
            self.filtersDict = Dictionary()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCancel() {
        println("Canceled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onFilter() {
        println("Filtered")
        //stick the dictionary into NS defaults
        NSUserDefaults.standardUserDefaults().setObject(self.filtersDict!, forKey: "filtersDict")
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
          self.delegate?.didChangeFilters(self, value: self.filtersDict!)
            return
        })}
    
    func didChangeFilter(sender: SwitchCell, key: String, value: Bool) {
        println("Delegate called switch cell \(key) : \(value)")
        var row = tableView.indexPathForCell(sender)?.row
        self.filtersDict?[key] = Int(value)
    }
    
    func didChangeFilter(sender: SegmentedCell, key : String, value: Int) {
        println("Delegate called segmented cell \(key) : \(value)")
        var row = tableView.indexPathForCell(sender)?.row
        self.filtersDict?[key] = value
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("cellForRowAtIndexPath")
        
        switch indexPath.section {
            case 0: //cetegory
                let cell = tableView.dequeueReusableCellWithIdentifier("codepath.switchcell") as SwitchCell
                loadCellInSection(indexPath.section, row: indexPath.row, cell: cell)
                return cell
            case 1: //sort
                let cell = tableView.dequeueReusableCellWithIdentifier("codepath.segmentedcell") as SegmentedCell
                loadCellInSection(indexPath.section, row: indexPath.row, cell: cell)
                return cell
            case 2: //distance
                let cell = tableView.dequeueReusableCellWithIdentifier("codepath.segmentedcell") as SegmentedCell
                loadCellInSection(indexPath.section, row: indexPath.row, cell: cell)
                return cell
            case 3: //deals
                let cell = tableView.dequeueReusableCellWithIdentifier("codepath.switchcell") as SwitchCell
                loadCellInSection(indexPath.section, row: indexPath.row, cell: cell)
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("codepath.switchcell") as SwitchCell
                loadCellInSection(indexPath.section, row: indexPath.row, cell: cell)
                return cell
        }
    }
    
    func loadCellInSection(section: Int, row: Int, cell: SwitchCell)  {
        var fs = self.filterSections!
        cell.Label?.text = fs[section]![row]
        if let switchValue = self.filtersDict?[fs[section]![row]] {
            cell.onSwitch!.on = Bool(switchValue)
        } else {
            cell.onSwitch!.on = false
        }
        cell.delegate = self
    }
    
    
    func loadCellInSection(section: Int, row: Int, cell: SegmentedCell)  {
        println("Loading Segmented cell")
        var label = self.filterSectionTitles![section]!
        cell.Label?.text = label
        var fs = self.filterSections!
        var sc = UISegmentedControl (items: fs[section]!)
        for r in 0...(fs[section]!.count - 1) {
            cell.SegmentControl.setTitle(fs[section]![r], forSegmentAtIndex: r)
        }
        if let selectedSegment = self.filtersDict?[label] {
            cell.SegmentControl.selectedSegmentIndex = selectedSegment
        }
        cell.delegate = self
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Did tap row \(indexPath.row)")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("numberOfRowsInSection")
        var fs = self.filterSections!
        switch section {
            case 0: //category
                return fs[section]!.count
            case 1://sort
                return 1
            case 2: //distance
                return 1
            case 3: //deals
                return fs[section]!.count
            default:
                break
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.filterSectionTitles![section]
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var fst = self.filterSectionTitles!
        return fst.count
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
 
}
