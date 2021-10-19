//
//  SearchDataViewController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/18.
//

import UIKit

class SearchDataViewController: UIViewController {

    let searchTableView : UITableView = {
       let searchTB = UITableView()
        return searchTB
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.frame = view.bounds
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        getBoardData()
    }

    private func getBoardData(){
        
    }

}

extension SearchDataViewController : UITableViewDelegate {
    
}
extension SearchDataViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
    
    
}
