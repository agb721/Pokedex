//
//  ViewController.swift
//  Pokedex
//
//  Created by Andreas Greiler Basaldua on 7/28/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var pokemon: [Pokemon] = []
    var PokemonSearchResult: [Pokemon] = []
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    
    // says what happens when app opens
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
         
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else {
            return
        }
        
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                self.PokemonSearchResult = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PokemonSearchResult.count
    }
    
    // what does this function do?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: PokemonSearchResult[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = PokemonSearchResult[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
                
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            PokemonSearchResult = pokemon
            tableView.reloadData()
            return
        }
        
        // Clear search results
        PokemonSearchResult.removeAll()
        
        // Regex * // use search string length?
        for element in pokemon {
            if element.name.contains(searchText.lowercased()) {
                PokemonSearchResult.append(element)
                tableView.reloadData()
            }
        }
        tableView.reloadData()
    }

}

