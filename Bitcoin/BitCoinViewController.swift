//
//  ViewController.swift
//  Bitcoin
//
//  

//

import UIKit
class BitCoinViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    /// loading view
    @IBOutlet weak var containerView: UIView!
    /// get the price of label
    @IBOutlet weak var priceLabel: UILabel!
    
    var networkSession:EditionNetworkSession?
    /// There are functions to populate pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Bitcoin.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Bitcoin.currencyArray[row]
    }
    
    /// This function calls API on selection of particular currency
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /// some issue with constants so using literal it 
        let urlString = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC" + Bitcoin.currencyArray[row]
        networkSession?.cancelRequest()
        containerView.isHidden = false
       networkSession?.setUpGetRequest(urlString)
        
      //  networkSession?.setUpGetRequest("​https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCCAD")
       // networkSession?.setUpGetRequest(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        networkSession = EditionNetworkSession(url: URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCCAD")!, withSuccessBlock: { (data) in
            let decoder = JSONDecoder()
            var response:Response?
            do {
                response  =  try decoder.decode(Response.self, from: data)
                
            }
            catch {
                
            }
            DispatchQueue.main.async {
                self.containerView.isHidden = true
                self.priceLabel.text = "\(response?.last ?? 0)"
            }
        }, andFailure: { (error) in
            DispatchQueue.main.async {
                self.containerView.isHidden = true
            }
        })
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

