//
//  ViewController.swift
//  ApiCall
//
//  Created by Twinbit Limited on 24/2/20.
//  Copyright © 2020 Twinbit Limited. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var apiCall : UIButton!{
        didSet{
            
            self.apiCall.addTarget(self, action: #selector(btnApiCallAction), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var resultLabel : UILabel!{
        didSet{
            
            self.resultLabel.text = ""
            self.resultLabel.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var btnClear : UIButton!{
        didSet{
            
            self.btnClear.addTarget(self, action: #selector(btnClearAction), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
        
    }
    
}

//Action
extension ViewController {
    
    @objc private func btnApiCallAction(){
        
        self.getServices()
        
    }
    
    @objc private func btnClearAction(){
        
        self.resultLabel.text = ""
        
    }
    
}


//API Call
extension ViewController {
    
    private func getServices(){
        
        self.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            
            guard let url = URL(string: "https://bongobd.com/disclaimer") else { return }
            
            var request = URLRequest(url: url)
            
            
            request.httpMethod = "GET"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            
            let task = URLSession.shared.dataTask(with: request){ rdata , rresponse, rerror in
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                }
                
                guard let data = rdata , let _ = rresponse else {
                    print("Data not found")
                    return }
                
                
                guard let dataString = String(data: data, encoding: .utf8) else { return }
                
                print(dataString)
                
                DispatchQueue.main.async {
                    
                    var result = ""
                    if let char = dataString.last {
                        
                        result = "Last Character : \(char)"
                        print("Last Character : \(char)")
                    }

                    
                    if let characterOf10th = self.getEvery10thChar(dataString) {
                        
                        result += "\nEvery 10th Character: \( characterOf10th)"
                    }
                    
                    if let words = self.getWordCount(dataString){
                        
                        result += "\nWord count : \( words)"
                    }
                    
                    self.resultLabel.text = result
                    
                    self.activityIndicator.stopAnimating()
                }
                
                
                
            }
            
            task.resume()
            
            
        }
        
        
        
    }
    
    
    private func getEvery10thChar(_ dataString : String)-> String?{
        
        var result = ""
        
        for (index,char) in dataString.enumerated(){
            
            if index%10 == 0 && index>9 {
                
                result += " \(char)"
                
                print("\(index)th charcacter : \(char)")
            }
            
        }
        
        return result.count>0 ? result : nil
        
    }
    
    private func getWordCount(_ dataString : String)->String?{
        
        let words = dataString.components(separatedBy: [" ","<",">","/",",",":","="])
        
        var counter = ""
        for word in words {
            
            counter += word.count == 0 ? "" : " \(word.count)"
            
            print("\(word) :\(word.count)")
        }
        
        return counter.count>0 ? counter : nil
        
    }

    
    
}


