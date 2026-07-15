# GitHub Users

GitHub Users is a UIKit iOS app for searching GitHub accounts, browsing followers and following lists, and viewing detailed profile information from the public GitHub REST API.

The project is built as a portfolio-focused UIKit codebase: XIB-based screens, MVVM-style view models, RxSwift bindings, protocol-based networking, unit-testable ViewModels, pagination, pull-to-refresh, reusable UI components, and light/dark theme support.

## Highlights

- UIKit app built with XIBs and reusable view/controller helpers.
- MVVM-style presentation logic with RxSwift/RxCocoa `Driver` outputs.
- Real GitHub API integration using Alamofire.
- Profile, followers, following, pagination, empty states, and refresh flows.
- Protocol-based API service abstraction for testable ViewModels.
- Unit tests for `UserSearchViewModel`.
- Light, dark, and system theme support.

## Screenshots

| Search | Profile | Followers | Following |
| --- | --- | --- | --- |
| <img src="Images/Search.png" alt="Search screen with empty state and suggested users" width="180"> | <img src="Images/Profile.png" alt="GitHub profile details screen" width="180"> | <img src="Images/Followers.png" alt="Followers list screen" width="180"> | <img src="Images/Following.png" alt="Following list screen" width="180"> |

## Features

- Search GitHub users through the public GitHub REST API.
- Open a detailed profile screen with avatar, name, bio, repos, followers, following, company, location, website, and GitHub profile link.
- Browse followers and following lists for any user.
- Pull to refresh on search results, followers, and following screens.
- Debounced search input to reduce unnecessary API requests.
- Paginated loading for search and follow lists.
- System, light, and dark appearance modes with persisted theme selection.
- Reusable UIKit table cell, button, spinner, navigation, and styling helpers.
- Polished empty, loading, no-results, and error states.
- Scene lifecycle support for modern iOS SDKs.
- Unit-tested search ViewModel behavior using dependency injection.

## Tech Stack

- UIKit with XIB-based screens
- MVVM-style view models
- RxSwift, RxCocoa, RxDataSources, RxTest, and RxBlocking
- Alamofire
- Kingfisher
- Lottie
- CocoaPods
- XCTest

## Architecture

The app keeps the main responsibilities separated:

- `Network`: GitHub API endpoints, request handling, result parsing, and error mapping.
- `GitHubUsersServicing`: protocol abstraction used to inject real or mocked GitHub API services.
- `UserSearch`: search screen, search result model, reusable user card cell, and search view model.
- `UserFollows`: followers/following list screen and pagination state.
- `UserProfile`: profile model, profile API loading, and detail screen.
- `Utilities`: app strings, colors, fonts, images, logging, and theme management.
- `Helpers`: base view controllers, reusable views, extensions, alerts, and table cell helpers.

The view models expose UI state through Rx `Driver`s so view controllers can bind loading, refresh, table visibility, empty states, and data updates in a predictable way.

`UserSearchViewModel` receives a `GitHubUsersServicing` dependency. The production app uses `NetworkRequest`, while tests inject a mock service to verify behavior without making real network calls.

## Testing

The project includes XCTest coverage for `UserSearchViewModel`.

Current tests verify:

- A successful search publishes the expected users.
- Empty search text clears state without calling the API service.

Run tests from the workspace:

```bash
xcodebuild test \
  -workspace "GitHub Users.xcworkspace" \
  -scheme "GitHub Users" \
  -destination "platform=iOS Simulator,name=iPhone 17,OS=26.0"
```

You can also run the tests directly from Xcode with `Command + U`.

## API

The app uses the public GitHub REST API:

- `GET /search/users`
- `GET /users/{username}`
- `GET /users/{username}/followers`
- `GET /users/{username}/following`

No API key is required. GitHub rate-limits unauthenticated requests, so heavy testing may temporarily return rate-limit errors.

## Requirements

- Xcode 15 or newer
- iOS 15.0 or newer
- CocoaPods
- An available iOS Simulator

## Setup

```bash
git clone https://github.com/YasserGh96/github-users.git
cd github-users
pod install
open "GitHub Users.xcworkspace"
```

Build and run the `GitHub Users` scheme from the workspace. Open the `.xcworkspace`, not the `.xcodeproj`, because dependencies are managed through CocoaPods.

## Portfolio Notes

This project demonstrates practical UIKit maintenance and modernization: cleaning an older UIKit app, improving RxSwift usage, moving repeated UI copy into constants, fixing modern scene lifecycle requirements, adding theme support, extending the app with real API-backed profile details, and introducing unit-testable ViewModel architecture.
