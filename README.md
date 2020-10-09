# ArchitechtureWorkshops

## Intro

Workshops are designed to give developers who have no experience with Swift an overview of modern iOS-apps development and share with more experienced iOS-developers knowledge about unidirectional architectures and particularly [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).

Workshops require professional programming knowledge. If you have no experience with Swift it's okay. You can drop if at any time they get harder. And vice versa; you can join any time by checking out the latest commit in this repo.

It would be much easier for you to follow if you have some experience in:
 - reactive programming
 - functional programming
 
But it's not required.

## Workshops plan

We'll be building a slightly modified version of Babbel's code challenge. Here's the app interface:

 ![alt-text](https://github.com/AlexShubin/ArchitechtureWorkshops/blob/master/game.gif)

Here's the code of the final application that we're aiming for: https://github.com/AlexShubin/FallingWords2
 
### We'll go through:

 1. Building a basic game app using SwiftUI
 2. Solving UI/Logic separation problems
 3. Introducing the app state and sharing it between different scenes
 4. Introducing the app state reducer
 5. Building and testing service layer using Combine
 6. Introducing side-effects and Composable Architecture
 7. Introducing Reducers composition, using Composable Architecture to modularize the app
 8. Testing the app modules

## Setup

Setup Xcode 11.7 (should be the latest version from the App Store). Make sure you ran it at least once in order to install "Additional Components" (you'll be guided).

## Workshop #1

[Video recording](https://drive.google.com/file/d/1k7AyQ_UbcpecMyPsmvAaa9kntW_z_5n0/view?usp=sharing)

### Achievements

Using SwiftUI we built a single screen game with logic and UI in the View.

### Problems

Game crashes at the end of the rounds. We have no game start/results screen, we have no score screen.
We have tightly coupled UI and game logic in the view which makes it untestable.

## Workshop #2

[Video recording](https://drive.google.com/file/d/1ZUMjISg0_f3GSir5maJ0g0EJZL2GmA5W/view?usp=sharing)

### Achievements

- We successfully separated UI and logic introducing `AppState` and `AppStore`
- We made state read-only accessible for views
- We built `GameStartView`
- We fixed the bugs from the previous session

### Problems

- We still have no score screen and no `TabBar`
- AppStore manages the concrete implementation of the state
- `GameStartView` lacks the results section
- Hardcoded set of words

## Workshop #3

[Video recording](https://drive.google.com/file/d/1d0lqkOJ6xzK9dsYME5QEyWQUeomgD9FZ/view?usp=sharing)

### Achievements

- Fixed the state update on the game start
- Introduced the reducer
- Separated the architectural part from the concrete implementation
- Implemented `ScoreHistoryView` and `TabBar`

### Problems

- Hardcoded set of words (lack of side-effects)
- Modularization problem
- Reducer implicitly creates `Date` and `UUID`
- `ScoreHistoryView` is responsible for formatting dates
- `GameStartView` lacks the results section

Small bugs:
 - New result appends instead of being inserted at 0 position

## Workshop #4

[Video recording](https://drive.google.com/file/d/1fUDkhVDxeY9AxaVhgQ2ZPoUQt6XH_5yt/view?usp=sharing)

### Achievements

- Fixed small bugs
- Implemented a score results section in the `GameStartView`
- Implemented a service layer

### Problems

- Hardcoded set of words (lack of side-effects)
- Modularization problem
- Reducer implicitly creates `Date` and `UUID`
- `ScoreHistoryView` is responsible for formatting dates
- No tests for the service layer

## Workshop #5

[Video recording](https://drive.google.com/file/d/1oqcqs5pvUHTIQor5Qkd-JFDVnC49PbMQ/view?usp=sharing)

### Achievements

- Finished the service layer
- Introduced side-effects

### Problems

- Modularization problem
- Reducer implicitly creates `Date` and `UUID`
- `ScoreHistoryView` is responsible for formatting dates
- Syncronous side-effects in the reducer
