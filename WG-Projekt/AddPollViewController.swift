//
//  AddPollViewController.swift
//  WG-Projekt
//
//  Created by Paul Pfisterer on 15.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit

class AddPollViewController: UIViewController {
    var optionCounter = 2 //counter starts with 2
    var newPoll: Poll!  // newPoll that is accassable in the CalendarVC

    @IBOutlet weak var pollDescription: UITextField!
    @IBOutlet weak var pollDue: UIDatePicker!
    @IBOutlet weak var pollOptions: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pollOptions.delegate = self
        pollOptions.dataSource = self
    }
    
    //Button for adding an option
    //option counter is incremented and the data is reloaded
    @IBAction func addOption(_ sender: Any) {
        optionCounter += 1
        pollOptions.reloadData()
    }
    
    //Create the Poll
    //Gets properties, creates a Poll and performs a Segue
    @IBAction func createPoll(_ sender: Any) {
        var optionsArray: [String] = []
        if(pollDescription.text == "") {
            self.showToast(message: "Beschreibung hinzufügen", font: .systemFont(ofSize: 12.0))
            return
        }
        //Create an Array with the options
        for k in 0...optionCounter-1 {
            let cell = pollOptions.cellForRow(at: IndexPath(row: k, section: 0)) as! PollOptionCell
            if(cell.pollOption.text != "") {
                optionsArray.append(cell.pollOption.text!)
            }
        }
        //Array has to have more than 1 option
        if(optionsArray.count <= 1) {
            self.showToast(message: "Mehr als zwei Optionen notwendig", font: .systemFont(ofSize: 12.0))
            return
        }
        //Create a map for the users where the default value is -1, create Poll and store it in the class variable, perform segue
        let userMap : [String: Int] = ["Emil" : -11, "Hanna": -1, "Paul":-1, "Jerome":-1]
        newPoll = Poll(title: pollDescription.text!, user: userMap, options: optionsArray, till: pollDue.date, finished: false, id: "")
        performSegue(withIdentifier: "unwindFromPoll", sender: nil)
    }


}



extension AddPollViewController: UITableViewDataSource, UITableViewDelegate {
    
    //option count -> stored in variable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionCounter
    }
    
    //cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pollOptionCell", for: indexPath) as? PollOptionCell else {
            fatalError("Cell could not be cast")
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    //delete cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            optionCounter -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}

