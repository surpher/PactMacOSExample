# PactMacOSExample
[![Build](https://github.com/surpher/PactMacOSExample/workflows/Build/badge.svg)](https://github.com/surpher/PactMacOSExample/actions?query=workflow%3ABuild)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An example macOS app demonstrating the use of PactConsumerSwift (https://github.com/DiUS/pact-consumer-swift) framework using Carthage with a macOS project.

## Versions

- macOS 10.15+
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

### Setting up PactMacOSExampleTests test target
#### Build Phases

Link the `PactConsumerSwift.framework` in Build Phases step. Drag it from the `/Carthage/Build/Mac/` folder onto the list.

![build-phase][build-phase-link-binary]
#### Build Settings

Add `$(PROJECT_DIR)/Carthage/Build/Mac` to `Framework Search Paths`

![Framework Search Paths][framework-search-paths]

Add `$(FRAMEWORK_SEARCH_PATHS)` to `Runpath Search Paths`

![Runpath Search Paths][runpath-search-paths]

#### Test pre-actions and post-actions

Update test pre-actions to start the mock-server before tests are run.

![pre-actions][pre-actions]

Update test post-actions to stop the mock-server when tests finish.

![post-actions][post-actions]
### Where are the Pact contracts?

Once the tests pass you can find them in `${SRCROOT}/tmp/pacts-ssl/thisapp-swapi.json`.

[build-phase-link-binary]: https://raw.githubusercontent.com/surpher/PactMacOSExample/main/Support/Images/build-phase-link-binary.png
[framework-search-paths]: https://raw.githubusercontent.com/surpher/PactMacOSExample/main/Support/Images/framework-search-paths.png
[runpath-search-paths]: https://raw.githubusercontent.com/surpher/PactMacOSExample/main/Support/Images/runpath-search-paths.png
[pre-actions]: https://raw.githubusercontent.com/surpher/PactMacOSExample/main/Support/Images/test-pre-actions.png
[post-actions]: https://raw.githubusercontent.com/surpher/PactMacOSExample/main/Support/Images/test-post-actions.png