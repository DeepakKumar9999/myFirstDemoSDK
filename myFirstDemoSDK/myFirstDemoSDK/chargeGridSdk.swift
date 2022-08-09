//
//  ViewController.swift
//  ChargeGridSDK
//
//  Created by DEEPAK KUMAR on 29/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    var charger_Id = ""

    var location = ""

    var mobile = 7503482233
    var chargeboxid =  ""
    var connectortype = ""
    var connectorno = ""
    var priceplan = ""
    var enterprise = ""
    var planid = ""
    var createdby = ""
    var chargingamount = 0

    var transactionid = 0
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var oneTimeNav = true
    var getReceiptTimeNav = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loader.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        oneTimeNav =  true
        getReceiptTimeNav =  true
    }
    @IBAction func getAccessTokenAction(_ sender: UIButton) {
        
        print("tapTokenButton")
       
       
        webservicesAPICalltoGetAccessToken(baseURL:DEVELOPMENT_BASE_URL)
        
    }
    @IBAction func chargerlistAction(_ sender: UIButton) {
        webservicesAPICalltoChargerList()
        
    }
    
    @IBAction func stationDetailsAction(_ sender: UIButton) {
        webservicesAPICalltoStationDetails(location:location)
        
    }
    
    @IBAction func startChargingRequestAction(_ sender: UIButton) {
        let parameters: [String: Any] = [

                "mobile" : mobile,
                "chargeboxid" : chargeboxid,
                "connectortype" : connectortype,
                "connectorno" : connectorno,
                "priceplan": "pay as you go",//priceplan
                "enterprise": "",//enterprise,
                "planid": "",
                "createdby": createdby,
                "chargingamount":0


        ]
        webservicesAPICalltoStartChargingRequest(mobile: mobile, chargeboxid: chargeboxid, connectortype: connectortype, connectorno: connectorno, priceplan: "pay as you go", enterprise: "", planid: "", createdby: createdby, chargingamount: 0)
        
    }
    
    @IBAction func ChargingProgressAction(_ sender: UIButton) {
        webservicesAPICalltoChargingProgress(transectionId: transactionid)
        
    }
    @IBAction func ChargingStopRequestAction(_ sender: UIButton) {
        webservicesAPICalltoChargingStopRequest()
        
    }
    @IBAction func generateReceiptAction(_ sender: UIButton) {
        webservicesAPICalltoGenerateReceipt()
        
    }
    
}

//Marks:- Webservice API
extension ViewController {
    
    func webservicesAPICalltoGetAccessToken(baseURL:String) {
        
        loader.isHidden = false
        loader.startAnimating()
        DEVELOPMENT_BASE_URL = baseURL
        let Url = String(format: "\(baseURL + GET_ACCESSTOKEN_API)")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameter: [String: Any] = [

                "source" : "HpPay"


        ]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            if let response = response {
                print(response)
                print("The response is : ",String(data: data!, encoding: .utf8)!)
            }
            if let data = data {
                do {
                    
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json!)
                    Token_ID = json!["token"] as! String
                    Token_ID =  "basic " + Token_ID
                    DispatchQueue.main.async { [self] in
                        if oneTimeNav{
                            
                            loader.isHidden = true
                            loader.stopAnimating()
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                            vc!.DetailsData =  String(data: data, encoding: .utf8)!
                            vc!.title = "Token"
                            self.navigationController?.pushViewController(vc!, animated: true)
                            oneTimeNav = false
                        }
                    }
                    
                } catch {
                    print(error)
                    loader.isHidden = true
                    loader.stopAnimating()
                }
            }
        }.resume()
    }
    
    
    
    func webservicesAPICalltoChargerList() {
        
        loader.isHidden = false
        loader.startAnimating()
        
        let task = URLSession.shared.dataTask(with: URL(string: "\(DEVELOPMENT_BASE_URL + CHARGERLIST_API)")!) { [self](data, response, error) in
         
            print("The response is : ",String(data: data!, encoding: .utf8)!)
            
            
            if let data = data {
                do {
                    
                    let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                    let ListData =  someDictionaryFromJSON[0]
                    location  = ListData["id"] as! String
                    DispatchQueue.main.async { [self] in
                        if oneTimeNav{
                            
                            loader.isHidden = true
                            loader.stopAnimating()
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                            vc!.DetailsData =  String(data: data, encoding: .utf8)!
                            vc!.title = "Charger List"
                            self.navigationController?.pushViewController(vc!, animated: true)
                            oneTimeNav = false
                        }
                    }
                    
                } catch {
                    print(error)
                    loader.isHidden = true
                    loader.stopAnimating()
                }
            }
            
        
        }
        task.resume()
     
    }
    
    
    func webservicesAPICalltoStationDetails(location:String) {
   
        
        loader.isHidden = false
        loader.startAnimating()
        
        
        let Url = String(format: "\(DEVELOPMENT_BASE_URL + GET_STATIONDETAILS_API)")
        guard let serviceUrl = URL(string: Url) else { return }
        let header = [
            
            
            "Authorization": Token_ID,
            "Content-Type": "application/json"
            
            
        ]
        

        let parameters: [String: Any] = [

                "location" : location,
                "stationid" : ""



        ]
      
       
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = header
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            
            if let data = data {
                do {
                    let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                 
                    let chargers = someDictionaryFromJSON["chargers"] as! [[String:Any]]
                    
                  
        
                    
                    let connectorsData = chargers[0]["connectors"] as! [[String:Any]]
                    priceplan = chargers[0]["priceplan"] as! String
                  
                    chargeboxid = connectorsData[0]["chargeboxid"] as! String//"CGHP002"
                    connectortype = connectorsData[0]["connectortype"] as! String
                    connectorno = connectorsData[0]["connectorno"] as! String
                 
                    enterprise = connectorsData[0]["enterprise"] as! String//""
                    
                    createdby = connectorsData[0]["createdby"] as! String//"623d665d26a410fd0536ebf4"
                 
                    DispatchQueue.main.async { [self] in
                        
                        loader.isHidden = true
                        loader.stopAnimating()
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                        vc!.DetailsData =  String(data: data, encoding: .utf8)!
                        
                        vc!.title = "Station  Details"
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }
                } catch {
                    print(error)
                    loader.isHidden = true
                    loader.stopAnimating()
                }
            }
        }.resume()
    }
    
    func webservicesAPICalltoStartChargingRequest(
                    mobile:Int,
                    chargeboxid:String,
                   connectortype:String,
                   connectorno:String,
                    priceplan:String,//priceplan
                   enterprise :String,//enterprise,
                   planid:String,
                   createdby:String,
                   chargingamount:Int
    
    ) {
        loader.isHidden = false
        loader.startAnimating()
        
        
        let Url = String(format: "\(DEVELOPMENT_BASE_URL + START_CHARGING_REQUEST_API)")
        guard let serviceUrl = URL(string: Url) else { return }
        let header = [
            
            
            "Authorization": Token_ID,
            "Content-Type": "application/json"
            
            
        ]
        
        let parameters: [String: Any] = [

                "mobile" : mobile,
                "chargeboxid" : chargeboxid,
                "connectortype" : connectortype,
                "connectorno" : connectorno,
                "priceplan": priceplan,
                "enterprise": enterprise,
                "planid": planid,
                "createdby": createdby,
                "chargingamount":chargingamount


        ]
        self.mobile = mobile
        self.chargeboxid = chargeboxid
        self.connectortype = connectortype
        self.connectorno = connectorno
        self.chargingamount = chargingamount
        self.planid = planid
      
      
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = header
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
         
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
               
                    transactionid = json["transactionid"] as! Int
                    DispatchQueue.main.async { [self] in
                        
                        loader.isHidden = true
                        loader.stopAnimating()
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                        vc!.DetailsData =  String(data: data, encoding: .utf8)!
                        
                        vc!.title = "Charging Request"
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }
                } catch {
                    print(error)
                    loader.isHidden = true
                    loader.stopAnimating()
                }
            }
        }.resume()
    }
    
    
    
    func webservicesAPICalltoChargingProgress(transectionId:Int) {
        
        loader.isHidden = false
        loader.startAnimating()
        
        let Url = String(format: "\(DEVELOPMENT_BASE_URL + CHARGING_PROGRESS_API)")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let header = [
            
            
            "Authorization": Token_ID,
            "Content-Type": "application/json"
            
            
        ]
        
        var parameters: [String: Any] = [
           
                "mobile" : mobile,
                "chargeboxid" : chargeboxid,
                "connectortype" : connectortype,
                "connectorno" : connectorno,
                "chargingamount": chargingamount,
                "planid": planid,
              
                
           
        ]
        
        parameters["transactionid"] = transectionId
        print("header   \(header)")
        print("parameters  \(parameters)")
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = header
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            if let data = data {
                do {
               
                    print("The response is : ",String(data: data, encoding: .utf8)!)
                DispatchQueue.main.async { [self] in
                loader.isHidden = true
                loader.stopAnimating()
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                    vc!.DetailsData =  String(data: data, encoding: .utf8)!
                    vc!.title = "Charging Progress"
               
                self.navigationController?.pushViewController(vc!, animated: true)
                }
            } catch {
                print(error)
                loader.isHidden = true
                loader.stopAnimating()
            }
        }
        
        }.resume()
    }
    
    
    
    
    
    
    func webservicesAPICalltoChargingStopRequest() {
        
        loader.isHidden = false
        loader.startAnimating()
        
        let Url = String(format: "\(DEVELOPMENT_BASE_URL + REQUEST_CHARGING_STOP_API)")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let header = [
            
            
            "Authorization": Token_ID,
            "Content-Type": "application/json"
            
            
        ]
        
        
        
        let parameters: [String: Any] = [
           
                "mobile" : mobile,
                "chargeboxid" : chargeboxid,
                "connectortype" : connectortype,
                "connectorno" : connectorno
                
                
                
          
        ]
        print("header   \(header)")
        print("parameters  \(parameters)")
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = header
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
//            if let data = data {
//                do {
            if let response = response {
              //  print("The response is : ",String(data: data!, encoding: .utf8)!)
                DispatchQueue.main.async { [self] in
                loader.isHidden = true
                loader.stopAnimating()
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                    vc!.DetailsData =  String(data: data!, encoding: .utf8)!
                    vc!.title = "Stop Charging Request"
               
                self.navigationController?.pushViewController(vc!, animated: true)
                }
                }
//            } catch {
//                print(error)
//                loader.isHidden = true
//                loader.stopAnimating()
//            }
      //  }
        }.resume()
    }
    
    
    
    
    
    func webservicesAPICalltoGenerateReceipt() {
        loader.isHidden = false
        loader.startAnimating()
        
        
        let Url = String(format: "\(DEVELOPMENT_BASE_URL + GENERATE_RECEIPT_API)")
        guard let serviceUrl = URL(string: Url) else { return }
        
        let header = [
            
            
            "Authorization": Token_ID,
            "Content-Type": "application/json"
            
            
        ]
        
        
        let parameters: [String: Any] = [
           
                "mobile" : mobile,
                "transactionId" : transactionid
             
        ]
        print("header   \(header)")
        print("parameters  \(parameters)")
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = header
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            if let data = data {
                do {
               // print("The response is : ",String(data: data!, encoding: .utf8)!)
                DispatchQueue.main.async { [self] in
                loader.isHidden = true
                loader.stopAnimating()
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController
                    vc!.DetailsData =  String(data: data, encoding: .utf8)!
                    vc!.title = "Receipt"
               
                self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
            } catch {
                print(error)
                loader.isHidden = true
                loader.stopAnimating()
            }
        }
        }.resume()
    }
    
    
}
