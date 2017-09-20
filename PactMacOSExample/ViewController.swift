//
//  ViewController.swift
//  PactMacOSExample
//
//  Created by Marko Justinek on 20/9/17.
//  Copyright © 2017 DiUS. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var sendRequestButton: NSButton!
  @IBOutlet weak var responseTextView: NSTextView!
  
  var swapiClient = SwapiClient(baseUrl: "https://swapi.co/api")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.responseTextView.isEditable = false
  }

  override var representedObject: Any? {
    didSet { }
  }

  @IBAction func sendRequest(_ sender: Any) {
    self.responseTextView.textStorage?.mutableString.setString("fetching...")
    
//    self.swapiClient.fetchStarWarsCharacter(id: 3) { (response, statusCode) -> Void in
//      self.responseTextView.textStorage?.mutableString.setString("STATUS: \(statusCode)\n\(response)")
//    }
    
    self.swapiClient.fetchStarWarsSpacecraft { (response, statusCode) -> Void in
      self.responseTextView.textStorage?.mutableString.setString("STATUS: \(statusCode)\n\(response)")
    }
  }
  
}

