# flutter3_app

A new Flutter project.

## Testing

### Configuration

- Add Configuration in `launch.json` in `.vscode` folder.
  ```json
  {
    "configurations": [
      {
        "name": "Flutter",
        "type": "dart",
        "request": "launch",
        "program": "lib/main.dart"
      },
      {
        "name": "Dart: Run all Tests",
        "type": "dart",
        "request": "launch",
        "program": "./test/"
      }
    ]
  }
  ```
- Create files followed by `_test`in the `test` folder.
- Add the test dependencies at the `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  faker: ^2.0.0
  mockito: ^5.3.0
```

## Flutter Clean Architecture

Inspired in ideas by [Shady Boukhary & Rafael Monteiro](https://github.com/ShadyBoukhary/flutter_clean_architecture), [Rodrigo Manguinho](https://github.com/rmanguinho/clean-flutter-app) and [Reso Coder](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course).

#### Folders Structure
```
lib/
    app/                          <--- application layer
        pages/                        <-- pages or screens
          login/                        <-- some page in the app
            login_controller.dart         <-- login controller extends `Controller`
            login_presenter.dart          <-- login presenter extends `Presenter`
            login_view.dart               <-- login view, 2 classes extend `View` and `ViewState` resp.
        widgets/                      <-- custom widgets
        utils/                        <-- utility functions/classes/constants
        navigator.dart                <-- optional application navigator
    data/                         <--- data layer
        repositories/                 <-- repositories (retrieve data, heavy processing etc..)
          data_auth_repo.dart           <-- example repo: handles all authentication
        helpers/                      <-- any helpers e.g. http helper
        constants.dart                <-- constants such as API keys, routes, urls, etc..
    device/                       <--- device layer
        repositories/                 <--- repositories that communicate with the platform e.g. GPS
        utils/                        <--- any utility classes/functions
    domain/                       <--- domain layer (business and enterprise) PURE DART
        entities/                   <--- enterprise entities (core classes of the app)
          user.dart                   <-- example entity
          manager.dart                <-- example entity
        usecases/                   <--- business processes e.g. Login, Logout, GetUser, etc..
          login_usecase.dart          <-- example usecase extends `UseCase` or `CompletableUseCase`
        repositories/               <--- abstract classes that define functionality for data and device layers
    main.dart                     <--- entry point

```

### Testing widgets

- Do not forget to envelope the pages in a `MaterialApp`object:

```dart
void main() {

  testWidgets('Objectives of the test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignInScreen()));
```
