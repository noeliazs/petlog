//
//  NewsViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 26/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var networkManager = NetworkManager()
    var arrayNews : [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Noticias"
        tableView.register(UINib(nibName: "NewsCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
               
            networkManager.fetchData()
            tableView.dataSource=self
            tableView.delegate=self
            tableView.rowHeight = 60
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(relanzar), userInfo: nil, repeats: false)
             
    }
    @objc func relanzar()
       {
        tableView.reloadData()
       }

}


//MARK: - TableViewDataSource
extension NewsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.posts.count
      
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NewsCell
 
        let nombre = networkManager.posts[indexPath.row].title
    
        cell.nombreLabel.text = nombre
       
        return cell
    }

    
}
//MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = WebViewController()
        if let url = networkManager.posts[indexPath.row].url{
            navigationController?.pushViewController(webViewController, animated: true)
            webViewController.url = url
           
        }

       
    }
}


