//
//  PaymentVC.swift
//  Connect
//
//  Created by Subham Padhi on 11/04/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit
import PaymentSDK
import Firebase
import FirebaseDatabase
import CodableFirebase


class PaymentVC: UIViewController {
    
    var checkSum:CheckSumModel?
    var txnController = PGTransactionViewController()
    var serv = PGServerEnvironment()
    var params = [String:String]()
    var order_ID:String?
    var cust_ID:String?
    var groupId : String?
    var capitalToRaise: String?
    var isReady = false
    var amount = 0
    
    var enterAmountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 16)
        label.text = "Enter Amount"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var capitalToRaiseLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 24)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        textField.layer.borderWidth = 2
        textField.textAlignment = .center
        return textField
    }()
    
    var payButton: UIButton = {
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Pay using Paytm", for: UIControl.State())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
        sendButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        sendButton.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return sendButton
    }()
    
    func getValues() {
        
        let ref = Database.database().reference()
        
        ref.child("Payment").child(groupId!).observeSingleEvent(of: .value , with: { (snapshot) in
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Payment.self, from: value)
                self.capitalToRaise =  model.Capital_To_Raise ?? "0"
                self.isReady = true
                
                DispatchQueue.main.async {
                    self.setupViews()
                }
                
            } catch let error {
                print(error)
            }
            
        })
    }
    
    
    
    @objc func handlePay() {
        
        guard let amount = inputTextField.text , amount != ""  else {
            Utils.showAlert(title: "Oops", message: "Please enter the amount", presenter: self)
            return
        }
        self.amount = Int(amount)!
        params = ["MID": PaytmConstants.MID,
                  "ORDER_ID": order_ID,
                  "CUST_ID": cust_ID,
                  "MOBILE_NO": "7777777777",
                  "EMAIL": "username@emailprovider.com",
                  "CHANNEL_ID":PaytmConstants.CHANNEL_ID,
                  "INDUSTRY_TYPE_ID":PaytmConstants.INDUSTRY_TYPE_ID,
                  "WEBSITE": PaytmConstants.WEBSITE,
                  "TXN_AMOUNT": "\(amount).00",
                  "CALLBACK_URL" :PaytmConstants.CALLBACK_URL+order_ID!
            ] as! [String : String]
        getCheckSumAPICall()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       // setupViews()
        getValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        order_ID = randomString(length: 5)
        cust_ID = randomString(length: 6)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func getCheckSumAPICall(){
        let apiStruct = ApiStruct(url: "http://172.20.10.4:8888//PHP/generateChecksum.php", method: .post, body: params)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (checkSumModel: CheckSumModel) in
            self.setupPaytm(checkSum: checkSumModel.CHECKSUMHASH!, params: self.params)
        }) { (error) in
            print("error")
            Utils.showAlert(title: "Oops", message: error.localizedDescription, presenter: self)
        }
    }
    
    private func setupPaytm(checkSum:String,params:[String:String]) {
        
        
        
        serv = serv.createStagingEnvironment()
        let type :ServerType = .eServerTypeStaging
        let order = PGOrder(orderID: "", customerID: "", amount: "", eMail: "", mobile: "")
        order.params = params
        //"CHECKSUMHASH":"oCDBVF+hvVb68JvzbKI40TOtcxlNjMdixi9FnRSh80Ub7XfjvgNr9NrfrOCPLmt65UhStCkrDnlYkclz1qE0uBMOrmu
        order.params["CHECKSUMHASH"] = checkSum
        self.txnController =  (self.txnController.initTransaction(for: order) as? PGTransactionViewController)!
        self.txnController.title = "Paytm Payments"
        self.txnController.setLoggingEnabled(true)
        
        if(type != ServerType.eServerTypeNone) {
            self.txnController.serverType = type;
        } else {
            return
        }
        self.txnController.merchant = PGMerchantConfiguration.defaultConfiguration()
        self.txnController.delegate = self
        self.navigationController?.pushViewController(self.txnController, animated: true)
    }
    
    func setupViews() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(payButton)
        view.addSubview(enterAmountLabel)
        view.addSubview(inputTextField)
        
        if isReady {
            if capitalToRaise != "0"  || capitalToRaise != nil {
                
                view.addSubview(capitalToRaiseLabel)
                
                capitalToRaiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
                capitalToRaiseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
                if #available(iOS 11.0, *) {
                    capitalToRaiseLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
                } else {
                    capitalToRaiseLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
                }
                
                capitalToRaiseLabel.text = "Amount left to be raised - \(capitalToRaise ?? "0") INR"
                capitalToRaiseLabel.numberOfLines = 0
                capitalToRaiseLabel.textAlignment = .center
                
            }
            
        }
        
        if #available(iOS 11.0, *) {
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        enterAmountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enterAmountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
        inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        inputTextField.topAnchor.constraint(equalTo: enterAmountLabel.bottomAnchor, constant: 10).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
}

extension PaymentVC : PGTransactionDelegate {
    
    func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
        let msg : String = responseString
        var titlemsg : String = ""
        if let data = responseString.data(using: String.Encoding.utf8) {
            do {
                if let jsonresponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] , jsonresponse.count > 0{
                    titlemsg = jsonresponse["STATUS"] as? String ?? ""
                }
            } catch {
                print("Something went wrong")
            }
        }
        let actionSheetController: UIAlertController = UIAlertController(title: titlemsg , message: msg.localizedLowercase, preferredStyle: .alert)
        let reference = Database.database().reference().child("Payment").child(groupId!)
        if capitalToRaise != "0"  || capitalToRaise != nil
        {
            let value = Int(self.capitalToRaise!)! - Int(self.amount)
            reference.updateChildValues(["Capital_To_Raise": "\(value)"])
        }
        
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            action -> Void in
            controller.navigationController?.popViewController(animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    //this function triggers when transaction gets cancelled
    func didCancelTrasaction(_ controller : PGTransactionViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    //Called when a required parameter is missing.
    func errorMisssingParameter(_ controller : PGTransactionViewController, error : NSError?) {
        controller.navigationController?.popViewController(animated: true)
    }
}
