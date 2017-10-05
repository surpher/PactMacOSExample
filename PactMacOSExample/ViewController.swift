import Cocoa

class ViewController: NSViewController {

  @IBOutlet weak var sendRequestButton: NSButton!
  @IBOutlet weak var responseTextView: NSTextView!
  @IBOutlet var idStepper: NSStepper!
  @IBOutlet var idTextField: NSTextField!
  @IBOutlet var urlLabel: NSTextField!
  
  var swapiClient = SwapiClient(baseUrl: "https://swapi.co/api")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateLabels()
  }

  override var representedObject: Any? {
    didSet { }
  }

  @IBAction func sendRequest(_ sender: Any) {
    self.responseTextView.textStorage?.mutableString.setString("fetching...")
    
    self.swapiClient.fetchStarWarsCharacter(id: Int(self.idStepper.intValue)) { (response, statusCode) -> Void in
      self.responseTextView.textStorage?.mutableString.setString("STATUS: \(statusCode)\n\n\(response)")
    }
  }
  
  @IBAction func stepperAction(_ sender: NSStepper) {
    self.updateLabels()
  }
  
  fileprivate func updateLabels() {
    self.idTextField.stringValue = "\(self.idStepper.intValue)"
    self.urlLabel.stringValue = "https://swapi.co/people/\(self.idStepper.intValue)/"
  }
  
}

