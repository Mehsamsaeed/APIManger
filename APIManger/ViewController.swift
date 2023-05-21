//
//  ViewController.swift
//  APIManger
//
//  Created by Mehsam Saeed on 12/05/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }

    @IBAction func onGet(_ sender: Any) {
        let endPoint = EndPoint(path: "products/1")
        APIManger.shared.runGetRequest(endPoint: endPoint) { [weak self] (result: Result<ResponseModel, Error>) in
            switch result{
            case .success(let res):
                print(res)
            case .failure(let error):
                print("error")
            }
        }
    }
    @IBAction func onPost(_ sender: Any) {
        let endPoint = EndPoint(path: "products/1")
        APIManger.shared.runGetRequest(endPoint: endPoint) { [weak self] (result: Result<ResponseModel, Error>) in
            switch result{
            case .success(let res):
                print(res)
            case .failure(let error):
                print("error")
            }
        }
    }
    
}

