The software in the `Interface Adapters` layer is a set of adapters that convert data from the
format most convenient for the use cases and entities, to the format most convenient for some
external agency such as the database or the web.
The presenters, views, and controllers all belong in the interface adapters layer.
No code inward of this circle should know anything at all about the database.

## Features

`gateways` and `ui`

## Getting started

### To create generated files run:

```
flutter pub run build_runner build --delete-conflicting-outputs
```

## Usage

The low-level details of the `construct_pm_interface_adapters` are relegated to plugin modules that
can be deployed and developed independently from the modules that contain high-level policies.
`ui` could be replaced with any other kind of interface—and the business rules would not care.
If the `ui` plugs in to the business rules, then changes in the `ui` cannot affect those business
rules.

To plugin `main` to `ui` you should use an `App` class from the `app.dart` file.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  LocalizationDelegate localizationDelegate = await LocalizationDelegate.create(
    fallbackLocale: Language.en.name,
    supportedLocales: <String>[Language.en.name],
  );
  runApp(LocalizedApp(localizationDelegate, App()));
}
```

## Additional information

### A TYPICAL SCENARIO

If the `app` wants to display money on the screen, it might pass a Currency object to the
`Presenter`. The `Presenter` will format that object with the appropriate decimal places and
currency markers, creating a string that it can place in the `ViewModel`. If that currency value
should be turned red if it is negative, then a simple boolean flag in the `ViewModel` will be set
appropriately.

Anything and everything that appears on the screen, and that the application has some kind of
control over, is represented in the `ViewModel` as a string, or a boolean, or an enum. Nothing is
left for the `View` to do other than to load the data from the `ViewModel` into the screen.

If the `app` needs to know the last names of all the users who logged in yesterday, then the
`UserGateway` interface will have a method named `getLastNamesOfUsersWhoLoggedInAfter` that takes
a `Date` as its argument and returns a list of last names.

When the developers working on the Presenters component would like to run a test of that component,
they just need to build their version of `construct_pm_interface_adapters` with the versions of
the `construct_pm_use_cases` and `Entities` components that they are currently using. None of the
other components in the system need be involved. This is nice. It means that the developers working
on Presenters have relatively little work to do to set up a test, and that they have relatively few
variables to consider.
