//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Andreas Greiler Basaldua on 7/29/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit

//var caught: Bool = false

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokeSprite: UIImageView!
    
    var pokemon: Pokemon!
    
    @IBAction func toggleCatch() {
        //if caught == false {
        if UserDefaults.standard.bool(forKey: pokemon.name) == false {
            catchButton.setTitle(pokemon.name, for: .normal)
            UserDefaults.standard.set(true, forKey: pokemon.name)
            //caught = true
        }
        else {
            catchButton.setTitle("Catch", for: .normal)
            UserDefaults.standard.set(false, forKey: pokemon.name)
            //caught = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type1Label.text = ""
        type1Label.text = ""
        
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }
        
        
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                DispatchQueue.main.async {
                    self.nameLabel.text = self.pokemon.name
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
}
