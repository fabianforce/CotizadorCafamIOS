//
//  ViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 15/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import MSAL

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {
    
    // Update the below to your client ID you received in the portal. The below is for running the demo only
    let kClientID = "774eca1e-f63b-4a93-9cd3-64743f2d3361"
    
    // Additional variables for Auth and Graph API
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
    let kAuthority = "https://login.microsoftonline.com/common"
    
    var accessToken = String()
    var applicationContext : MSALPublicClientApplication?
    var webViewParamaters : MSALWebviewParameters?
    
    var loggingText: UITextView!
    var signOutButton: UIButton!
    var callGraphButton: UIButton!
    var imageCafam:UIImageView!
    
    /**
     Setup public client application in viewDidLoad
     */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initUI()
        
        do {
            try self.initMSAL()
        } catch let error {
            self.updateLogging(text: "Unable to create Application Context \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.updateSignOutButton(enabled: !self.accessToken.isEmpty)
    }
}


// MARK: Initialization

extension ViewController {
    
    func initMSAL() throws {
        
        guard let authorityURL = URL(string: kAuthority) else {
            self.updateLogging(text: "Unable to create authority URL")
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        
        self.webViewParamaters = MSALWebviewParameters(parentViewController: self)
    }
    
    func initWebViewParams() {
        self.webViewParamaters = MSALWebviewParameters(parentViewController: self)
    }
}

extension ViewController {
    @objc func callGraphAPI(_ sender: UIButton) {
        
        guard let currentAccount = self.currentAccount() else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            acquireTokenInteractively()
            return
        }
        
        acquireTokenSilently(currentAccount)
    }
    
    func acquireTokenInteractively() {
        
        guard let applicationContext = self.applicationContext else { return }
        guard let webViewParameters = self.webViewParamaters else { return }
        
        let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount;
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            if let error = error {
                
                self.updateLogging(text: "Could not acquire token: \(error)")
                return
            }
            
            guard let result = result else {
                
                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }
            
            self.accessToken = result.accessToken
            self.updateLogging(text: "Access token is \(self.accessToken)")
            self.updateSignOutButton(enabled: true)
            self.getContentWithToken()
        }
    }
    
    func acquireTokenSilently(_ account : MSALAccount!) {
        
        guard let applicationContext = self.applicationContext else { return }
        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
        
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            
            if let error = error {
                
                let nsError = error as NSError
                if (nsError.domain == MSALErrorDomain) {
                    
                    if (nsError.code == MSALError.interactionRequired.rawValue) {
                        
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                
                self.updateLogging(text: "Could not acquire token silently: \(error)")
                return
            }
            
            guard let result = result else {
                
                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }
            
            self.accessToken = result.accessToken
            self.updateLogging(text: "Refreshed Access token is \(self.accessToken)")
            self.updateSignOutButton(enabled: true)
            self.getContentWithToken()
        }
    }
    
    
    func getContentWithToken() {
        
        // Specify the Graph API endpoint
        let url = URL(string: kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                self.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }
            
            /*guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else {
             
             self.updateLogging(text: "Couldn't deserialize result JSON")
             return
             }*/
            do {
                let allContacts = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                self.updateLogging(text: "DATA: \(allContacts)")
                //let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                DispatchQueue.main.async {
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SoapView") as! SoapViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
                
                
                
            }
            catch {
                
            }
            
            
        }.resume()
    }
    
}


extension ViewController {
    func currentAccount() -> MSALAccount? {
        
        guard let applicationContext = self.applicationContext else { return nil }
        
        do {
            
            let cachedAccounts = try applicationContext.allAccounts()
            
            if !cachedAccounts.isEmpty {
                return cachedAccounts.first
            }
            
        } catch let error as NSError {
            
            self.updateLogging(text: "Didn't find any accounts in cache: \(error)")
        }
        
        return nil
    }
    
    @objc func signOut(_ sender: UIButton) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        guard let account = self.currentAccount() else { return }
        
        do {
            try applicationContext.remove(account)
            self.updateLogging(text: "")
            self.updateSignOutButton(enabled: false)
            self.accessToken = ""
            
        } catch let error as NSError {
            
            self.updateLogging(text: "Received error signing account out: \(error)")
        }
    }
}


// MARK: UI Helpers
extension ViewController {
    
    func initUI() {
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        //stackView.distribution  = NSLayoutConstraint.Axis.
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 0
        
        imageCafam = UIImageView(frame: CGRect(x: 1, y: 1, width: 123, height: 123))
        imageCafam.image = UIImage(named:"logocafa.png")
        
        // Add call Graph button
        callGraphButton  = UIButton()
        callGraphButton.translatesAutoresizingMaskIntoConstraints = false
        callGraphButton.setTitle("Ingresar Directorio Activo", for: .normal)
        callGraphButton.setTitleColor(.blue, for: .normal)
        callGraphButton.addTarget(self, action: #selector(callGraphAPI(_:)), for: .touchUpInside)
        callGraphButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        callGraphButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // Add sign out button
        signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Salir", for: .normal)
        signOutButton.setTitleColor(.blue, for: .normal)
        signOutButton.setTitleColor(.gray, for: .disabled)
        signOutButton.addTarget(self, action: #selector(signOut(_:)), for: .touchUpInside)
        
        // Add logging textfield
        loggingText = UITextView()
        loggingText.widthAnchor.constraint(equalToConstant: 400.0).isActive = true
        loggingText.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        
        
        stackView.addArrangedSubview(imageCafam)
        stackView.addArrangedSubview(callGraphButton)
        stackView.addArrangedSubview(signOutButton)
        stackView.addArrangedSubview(loggingText)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        //loggingText.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 5.0).isActive = true
        
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func updateLogging(text : String) {
        
        if Thread.isMainThread {
            self.loggingText.text = text
        } else {
            DispatchQueue.main.async {
                self.loggingText.text = text
            }
        }
    }
    
    func updateSignOutButton(enabled : Bool) {
        if Thread.isMainThread {
            self.signOutButton.isEnabled = enabled
        } else {
            DispatchQueue.main.async {
                self.signOutButton.isEnabled = enabled
            }
        }
    }
}

