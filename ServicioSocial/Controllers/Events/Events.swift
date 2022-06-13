//
//  Events.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 18/04/22.
//

import UIKit
import SDWebImage

class Events: UIViewController {

    @IBOutlet weak var tableOfEvents: UITableView!
    var user = User()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableOfEvents.delegate = self
        tableOfEvents.dataSource = self
        
        getEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        getEvents()
    }

    func getEvents()
    {
        EventService.getEvents { events in
            
            self.events = events
            self.tableOfEvents.reloadData()
        }
    }
    @IBAction func newEventButtonAction(_ sender: Any) {
        
        performSegue(withIdentifier: "createEvent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createEvent"
        {
            let viewController = segue.destination as! CreateNewEvent
            viewController.currentUser = self.user
        }
    }
}

// MARK: - Extensión de UITableView para la clase eventos
extension Events : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Este switch ayuda a determinar el número de filas que tendrá cada sección, comenzando por el índice de sección 0
        switch section
        {
        case 0:
            return 1
        case 1:
            return events.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Se asignan los valores correspondientes para el usuario loggeado en la escena de eventos
        if indexPath.section == 0
        {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "addNewEvent") as! AddNewEventCell
            
            UserService.getUser { user in
                self.user = user
                
                userCell.lblCurrentUserName.text = "\(self.user.name) \(self.user.lastName)"
                
                if self.user.profileImage == ""
                {
                    userCell.imgCurrentUserImage.image = UIImage(named: "defaultProfileImage")
                
                } else {
                    
                    userCell.imgCurrentUserImage.sd_setImage(with: URL(string: self.user.profileImage))
                }
            
            }
            
            return userCell
            
            //Se asignan los valores correspondientes a los eventos posteados por usuarios a los que sigue el usuario loggeado
        } else {
            
            let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
            
            eventCell.lblEventName.text = events[indexPath.row].nameEvent
            eventCell.lblEventDate.text = events[indexPath.row].dateEvent
        
            if events[indexPath.row].hasImage
            {
                eventCell.imgEventImage.sd_setImage(with: URL(string: events[indexPath.row].imageEvent))
            
            } else {
                
                eventCell.imgEventImage.isHidden = true
            }
            
            eventCell.lblUserFullName.text = "\(events[indexPath.row].ownerUserName) \(events[indexPath.row].ownerUserLastName)"
            eventCell.lblEventTextArea.text = events[indexPath.row].textEvent
            
            if events[indexPath.row].ownerImageUrl != ""
            {
                eventCell.imgEventUserImage.sd_setImage(with: URL(string: events[indexPath.row].ownerImageUrl))
            }
            
            return eventCell
            
        }
    }
    
    @IBAction func unwindToEvents(_ sender: UIStoryboardSegue)
    {
        
    }
}
