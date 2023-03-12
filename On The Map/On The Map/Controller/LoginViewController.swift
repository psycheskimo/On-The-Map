//
//  LoginViewController.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var signUpUrl = OTMClient.Endpoints.signUp.url
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        passwordTextField.isSecureTextEntry = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        setLogin(true)
        
        OTMClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        setLogin(true)
        
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogin(false)
        
        if success {
            
            self.performSegue(withIdentifier: "loginComplete", sender: nil)
            
        } else {
            
            showLoginFailure(message: error?.localizedDescription ?? "")
            activityIndicator.isHidden = true

        }
        
    }
    
    func setLogin(_ login: Bool) {
        
            activityIndicator.isHidden = false
        
        if login {
            
            activityIndicator.startAnimating()
        
        } else {
            
            activityIndicator.stopAnimating()

        }

        loginButton.isEnabled = !login
        emailTextField.isEnabled = !login
        passwordTextField.isEnabled = !login
        
    }
    
    func showLoginFailure(message: String) {
        
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        
    }

}

