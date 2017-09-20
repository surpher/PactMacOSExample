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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.responseTextView.isEditable = false
  }

  override var representedObject: Any? {
    didSet {
      
    }
  }

  @IBAction func sendRequest(_ sender: Any) {
    print("sendRequest clicked...")
  }
  
}

