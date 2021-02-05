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

### Setting up PactMacOSExampleTests test target
#### Build Phases

Link the `PactConsumerSwift.framework` in Build Phases step. Drag it from the `/Carthage/Build/Mac/` folder onto the list.

![build-phase](Support/images/build-phase-link-binary.png)

#### Build Settings

Add `$(PROJECT_DIR)/Carthage/Build/Mac` to `Framework Search Paths`

![Framework Search Paths](Support/images/framework-search-paths.png)

Add `$(FRAMEWORK_SEARCH_PATHS)` to `Runpath Search Paths`

![Runpath Search Paths](Support/images/runpath-search-paths.png)

#### Test pre-actions and post-actions

Update test pre-actions to start the mock-server before tests are run.

![pre-actions](Support/images/test-pre-actions.png)

Update test post-actions to stop the mock-server when tests finish.

![post-actions](Support/images/test-post-actions.png)
### Where are the Pact contracts?

Once the tests pass you can find them in `${SRCROOT}/tmp/pacts-ssl/thisapp-swapi.json`.
