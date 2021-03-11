//
//  ViewController.swift
//  Project7
//
//  Created by Catalin Neculaide on 09.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .done, target: self, action: #selector(creditButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(filterButton))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                filteredPetitions = petitions
                return
            }
        }
        showError()
    }
    
    @objc func creditButton(){
        let ac = UIAlertController(title: "Credits for this app", message: "The data comes from We The People API of the WhiteHouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterButton(){
        let ac = UIAlertController(title: "Filter Petitions", message: "Write a word to filter by", preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.filterPetition(text.lowercased())
        }
        
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    func filterPetition(_ text: String){
        filteredPetitions.removeAll()
        
        if !text.isEmpty {
            for petition in petitions {
                if petition.body.lowercased().contains(text) || petition.title.lowercased().contains(text) {
                    filteredPetitions.append(petition)
                }
            }
        } else {
            filteredPetitions = petitions
        }
        
        tableView.reloadData()
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, please check your connecion and ttry again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

