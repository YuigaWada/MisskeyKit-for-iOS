//
//  AuthViewController.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/07.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import SafariServices
import UIKit

public protocol AuthViewControllerDelegate {
    func resultApiKey(_ apiKey: String?)
}

public class AuthViewController: UIViewController, SFSafariViewControllerDelegate {
    private var callback: ((String?) -> Void)?
    
    public var delegate: AuthViewControllerDelegate? // You can choose whether to use callback pattern or delegate pattern.
    
    private var authHandler: MisskeyKit.Auth?
    func setup(from auth: MisskeyKit.Auth) {
        authHandler = auth
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        
        guard let appSecret = authHandler?.appSecret else { return }
        openAuthPage(appSecret)
    }
    
    public func resultApiKey(_ completion: @escaping (String?) -> Void) {
        callback = completion
    }
    
    private func openAuthPage(_ appSecret: String) {
        authHandler?.startSession(appSecret: appSecret) { auth, error in
            guard let auth = auth, error == nil else { return }
            
            guard let url = URL(string: auth.token!.url) else { /* Error */ return }
            DispatchQueue.main.async {
                let vc = SFSafariViewController(url: url)
                
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
        
        guard let authHandler = authHandler else { return }
        DispatchQueue.main.async {
            authHandler.getAccessToken { auth, _ in
                guard let _ = auth else { return }
                
                if let callback = self.callback {
                    callback(authHandler.getAPIKey())
                    return
                } else if let delegate = self.delegate {
                    delegate.resultApiKey(authHandler.getAPIKey())
                    return
                }
                
                fatalError("YOU MUST SET DELEGATE OR CALLBACK.")
            }
        }
    }
}
