## Getting started

Before starting, used Xcode version `13.1.0`


## `Project Structure`

Below is a Detail of per model implemented. Tried to follow the clean architecture rules and principles.

Settings and extensions were specific to this project for Visual Studio Code. See [the editors doc](editors.md#visual-studio-code) for more.

### `TrueTest`

Main executable target of our application. Here you can implementation for all [Modules](../TrueTest/Modules) and [Application](../TrueTest/Application) as well as setting up the application with `AppDelegate`, `SceneDelegate` and [Dependencies](../TrueTest/Dependencies) setup the main dependency injection environment .

A critical note about modules is that no modules should be able to access the contents of any other modules here. This will allow us to move modules to their own target if needed quickly.

### `Network`

All features and modules are related to the Network and talking with the Server-side. This target should only be used in [Repository](#repository) and nowhere else.

### `Core`

Contain Pure and dummy entities and use-cases:

-  Data models that we use throughout the app such as `Property,` `PropertyList,` etc.
-  Services are the protocols that we make them a concretes one in the Repository Module.

### `Repository`

This module acts like Brain. App talks with Repository for any services need. It feeds the app with modules that it accesses.
For example, for API calls, this module implements the default use-cases, and the only app calls this module for network calls or etc...


