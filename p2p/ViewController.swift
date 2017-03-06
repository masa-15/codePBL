//
//  ViewController.swift
//  p2p
//
//  Created by I,N on 2017/03/01.
//  Copyright © 2017年 nakarinrin. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import FlatUIKit

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {

    let serviceType = "LCOC-Chat"
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var session: MCSession!
    var peerID: MCPeerID!
    var myName: String = ""
    var myGender: Int = 0
    
    @IBOutlet var chatView: UITextView!
    @IBOutlet var messageField: UITextField!
    @IBOutlet weak var sendButton: FUIButton!
    @IBOutlet weak var BrowseButton: FUIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.nameLabel.text = "\(self.myName)"
        if myGender == 0{
            self.genderLabel.text = "おとこのこのフレンズ"
        }else{
            self.genderLabel.text = "おんなのこのフレンズ"
        }
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        //browserの画面を生成
        self.browser = MCBrowserViewController(serviceType: serviceType, session: self.session)
        self.browser.delegate = self
        self.assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session.self)
        
        self.assistant.start()
        
        button1(BrowseButton)
        button2(sendButton)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let msg = self.messageField.text?.data(using: String.Encoding.utf8, allowLossyConversion: false)
        var error: NSError?
        
        do {
            try self.session.send(msg!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print("Error sending data: \(error.localizedDescription)")
        }
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
        self.updateChat(text: self.messageField.text!, fromPeer: self.peerID)
        self.messageField.text = ""
        }

    func updateChat(text: String, fromPeer peerID: MCPeerID){
        
        var name: String
        //peerIDがローカルのものならMe
        switch peerID{
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
        let message = "\(name): \(text)\n"
        self.chatView.text = self.chatView.text + message
    }
    
    @IBAction func showBrowser(_ sender: Any) {
        self.present(self.browser, animated: true, completion: nil)
    }
    
    //browserViewControllerが却下された時
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //browserViewControllerがキャンセルされた時
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    //だれかがsendしたとき
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            
            var msg = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            self.updateChat(text: msg as! String, fromPeer: peerID)
        }
    }
    
    
    //以下書いておかなきゃいけないものたち
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //textField以外のところをタッチしてキーボードをしまう
        if(self.messageField.isFirstResponder){
            self.messageField.resignFirstResponder()
        }
        if(self.chatView.isFirstResponder){
            self.chatView.resignFirstResponder()
        }
    }
    
    //UI
    func button1(_ btn: FUIButton){
        btn.buttonColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        btn.shadowColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        btn.shadowHeight = 3.0
        btn.cornerRadius = 6.0
        
        self.view.addSubview(btn)
    }
    
    func button2(_ btn: FUIButton){
        btn.buttonColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        btn.shadowColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        btn.shadowHeight = 3.0
        btn.cornerRadius = 6.0
        
        self.view.addSubview(btn)
    }
}

