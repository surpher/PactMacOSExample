# PactMacOSExample
[![Build Status](https://travis-ci.org/surpher/PactMacOSExample.svg?branch=master)](https://travis-ci.org/surpher/PactMacOSExample)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)  

An example macOS app demonstrating the use of PactConsumerSwift (https://github.com/DiUS/pact-consumer-swift) framework using Carthage.

### Requirements

- Xcode 10 and Swift 4
- Carthage `brew install carthage`
- Download [pact-ruby-standalone](https://github.com/pact-foundation/pact-ruby-standalone) (in this particular example project the binaries were moved to `$PROJ_DIR/tmp/pact/bin` where scheme test _pre-actions_ and _post-actions_ add the path to `$PATH`)

### Workflow
- Create your MacOS app.
- Run `carthage update --platform macOS`
- Link your dependencies to your project targets and `copy-frameworks` in an additional Build Step for each of your targets - you know, the Carthage stuff...
- Add exception to allow http calls to `localhost` by editing your `info.plist`:  
![Info.plist allow access to/from http](images/info-plist-changes.png)
- Add your source code and write your tests.
- Update your scheme's Test stage _pre-_ and _post-action_ by adding a script to start and stop your pact mock service. [How?](https://github.com/DiUS/pact-consumer-swift#install-the-pact-mock_service)
- Run your tests in Xcode (or `xcodebuild`).
- Grab your `./tmp/pacts/_your_provider-your_client.json` pact file to share with developers working on the API provider or submit to a [Pact Broker](https://github.com/pact-foundation/pact_broker).
- Celebrate :tada:
