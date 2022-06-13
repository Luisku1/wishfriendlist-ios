//
//  Categories.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 09/06/22.
//

import UIKit

class Categories: UIViewController {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

}

extension Categories : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
