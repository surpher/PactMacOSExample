# PactMacOSExample
[![Build](https://github.com/surpher/PactMacOSExample/workflows/Build/badge.svg)](https://github.com/surpher/PactMacOSExample/actions?query=workflow%3ABuild)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An example macOS app demonstrating the use of PactConsumerSwift (https://github.com/DiUS/pact-consumer-swift) framework using Carthage with a macOS project.

## Versions

- macOS 11.0 BigSur
- Xcode 12.4
- Carthage 0.37.0
- pact-ruby-standalone

## Installation

### pact-ruby-standalone

```shell
brew tap pact-foundation/pact-ruby-standalone
brew install pact-ruby-standalone
```

### Dependencies

```shell
carthage update --platform macos
```
### Starting and stopping the MockServer (pact-ruby-standalone)

[ IMAGE MISSING ]

### Where are the Pact contracts?

Once the tests pass you can find them in `${SRCROOT}/tmp/pacts/_your_provider-your_client.json`.
