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

## Dart Streams

From https://dart.dev/tutorials/language/streams

_Asynchronous programming_ in Dart is characterized by the **Future** and **Stream** classes.

A `Future` represents a computation that doesn’t complete immediately. Where a normal function returns the result, an asynchronous function returns a Future, which will eventually contain the result. The future will tell you when the result is ready.

A `stream` is a sequence of asynchronous events. It is like an asynchronous Iterable—where, instead of getting the next event when you ask for it, the stream tells you that there is an event when it is ready.

`Streams` can be created in many ways.

```dart
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (final value in stream) {
    sum += value;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

void main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // 55
}
```

There are four main classes in Dart's async libraries that are used to manage streams:

- `Stream`: This class represents an asynchronous stream of data. Listeners can subscribe to be notified of the arrival of new data events.
- `EventSink`: A sink is like a stream that flows in the opposite direction. Adding data events to an EventSink funnels that data into a connected stream.
- `StreamController`: A StreamController simplifies stream management, automatically creating a stream and sink, and providing methods for controlling a stream's behavior.
- `StreamSubscription`: Listeners on a stream can save a reference to their subscription, which will allow them to pause, resume, or cancel the flow of data they receive.

#### Two kinds of streams

There are two kinds of streams.

`Single subscription streams`
The most common kind of stream contains a sequence of events that are parts of a larger whole. Events need to be delivered in the correct order and without missing any of them. This is the kind of stream you get when you read a file or receive a web request.

**Such a stream can only be listened to once**. Listening again later could mean missing out on initial events, and then the rest of the stream makes no sense. When you start listening, the data will be fetched and provided in chunks.

`Broadcast streams`
The other kind of stream is intended for individual messages that can be handled one at a time. This kind of stream can be used for mouse events in a browser, for example.

You can start listening to such a stream at any time, and you **get the events that are fired while you listen**. More than one listener can listen at the same time, and you can listen again later after canceling a previous subscription.

#### The listen() method

The listen() method allows you to start listening on a stream. Until you do so, the stream is an inert object describing what events you want to see. When you listen, a `StreamSubscription` object is returned which represents the active stream producing events.

The `stream subscription` allows you to pause the subscription, resume it after a pause, and cancel it completely. You can set callbacks to be called for each data event or error event, and when the stream is closed.

### StreamController

A StreamController gives you a new stream and a way to add events to the stream at any point, and from anywhere. The stream has all the logic necessary to handle listeners and pausing. You return the stream and keep the controller to yourself.

As a rule, streams should wait for subscribers before starting their work. An async\* function does this automatically, but when using a StreamController, you are in full control and can add events even when you shouldn’t. When a stream has no subscriber, its StreamController buffers events, which can lead to a memory leak if the stream never gets a subscriber.

When you create a StreamController, you get the stream and sink for free. Data subscribers listen for updates on a Stream instance, and an EventSink is used to add new data to the stream. Subscribers to the stream can manage their subscription with a StreamSubscription instance.

```dart
import 'dart:async';
void main() {

final controller = StreamController<String>();

final subscription = controller.stream.listen((String data) {
  print('Stream recebida: $data');
});

controller.sink.add("Data!");

// or controller.add("Data!");
// you can use interchangeably

controller.close();
}
```

It should be noted that controllers expose a convenience add() method that handles forwarding any data to the sink:

```dart
controller.add("Data!");
```

You don't need to explicitly use the **sink** reference to add data to the stream, but that's what happens behind the scenes.

If an error occurs and your stream's listeners need to be informed, you can use `addError()` instead of `add()`:

```dart
controller.addError("Error!");
```

Just as with `add()`, the error will be sent over the stream via the sink.

#### Using streams

Typically, a controller and its sink are kept private to the data producer, while the stream is exposed to one or more consumers. If you have a class that needs to communicate with code outside itself, perhaps a data service class of some kind, you might use a pattern like this:

```dart
import 'dart:async';

class MyDataService {
  final _onNewData = StreamController<String>();
  Stream<String> get onNewData => _onNewData.stream;
}
```

You need to import the `dart:async` library to gain access to StreamController. The private `_onNewData` variable represents the stream controller for providing incoming data to any users of the service, and we use generics to specify that all data is expected to be in string form. **The name of the controller variable is deliberately matched to the public getter `onNewData` so that it's clear which controller belongs to which stream**. The getter returns the controller's Stream instance, with which a listener can provide a callback to receive data updates.

```dart
final service = MyDataService();

service.onNewData.listen((String data) {
  print(data);
});
```

You can optionally provide callbacks for errors and to be notified when the stream is closed by the controller:

```dart
import 'dart:async';

class MyDataService {
  final _onNewData = StreamController<String>();
  StreamController<String> get onNewData => _onNewData;

}

void main() {
  final service = MyDataService();

  service.onNewData.stream.listen((String data) {
  print(data);
  },
  onError: (error) {
    print(error);
  },
  onDone: () {
    print("Stream closed!");
  });

  service.onNewData.add('One data');
  service.onNewData.addError('Deu erro!');
  service.onNewData.close();

}
```

#### Multi-user streams

Sometimes a stream's data is intended for a single recipient, but in other cases, you may want to allow any number of recipients. For instance, it's possible that disparate parts of your app could rely on updates from a single data source, both user interface elements or other logic components. If you want to allow multiple listeners on your stream, you need to create a broadcast stream:

```dart
class MyDataService {
  final _onNewData = StreamController<String>.broadcast();
  Stream<String> get onNewData => _onNewData.stream;
}
```

Using the `broadcast()` named constructor for the StreamController will provide a multi-user stream. With this, any number of listeners may register a callback to be notified of new elements on the stream.

#### Using Stream generators

```dart
Stream<int> count(int countTo) async* {
  for (int i = 1; i <= countTo; i++) {
    yield i;
    await Future.delayed(const Duration(seconds: 1));
  }
}

// put this block somewhere
count(10).listen((int value) {
  print(value);
});
```

More on https://dart.academy/streams-and-sinks-in-dart-and-flutter/
