//
//  Phrases.swift
//  ServicioSocial
//
//  Created by UNAM FCA 17 on 16/05/22.
//

import UIKit

struct Phrase : Decodable
{
    var phrase : String
    var author : String
}

class Phrases: UIViewController {

    @IBOutlet weak var lblPhrase: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhrase()
    }
    @IBAction func refreshBarButton(_ sender: Any) {
        
        loadPhrase()
    }
    
    func loadPhrase()
    {
        let urlString = "https://frasedeldia.azurewebsites.net/api/phrase"
        
        if let url = URL(string: urlString)
        {
            guard let data = try? Data(contentsOf: url) else { return }
            
            let jsonDecoder = JSONDecoder()
            
            if let phrase = try? jsonDecoder.decode(Phrase.self, from: data)
            {
                print("DEBUG:- \(phrase)")
                self.lblPhrase.text = phrase.phrase
                self.lblAuthor.text = phrase.author
            }
        }
    }
}
