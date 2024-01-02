A use case is a description of the way that an automated system is used. It specifies the input to
be provided by the user, the output to be returned to the user, and the processing steps involved in
producing that output. A use case describes application-specific business rules as opposed to the
Critical Business Rules within the Entities.

## Usage

To use `construct_pm_use_cases` you should use a technique called "Ports and Adapters" (also known
as "Hexagonal Architecture" or "Ports and Adapters Architecture"), which is an architectural pattern
that can help to achieve a higher degree of separation between the inner core and the outer layer.
In this pattern, the inner core defines interfaces (ports) that are implemented by the outer
layers (adapters), and the dependencies flow from the inner core to the adapters, without the need
for the inner core to import any specific interface from the outer layer.
Here's an example using the Ports and Adapters pattern:

```dart
class GetContactsResourceUseCaseAdapter extends UseCase<List<Contact>, ContactsFetchCriteria>
    implements GetContactsResourceUseCase {
  const GetContactsResourceUseCaseAdapter(this._contactGateway);

  final ContactsGateway _contactGateway;

  @override
  Stream<Resource<List<Contact>>> callAsStream([
    ContactsFetchCriteria input = const ContactsFetchCriteria(),
  ]) =>
      getNetworkBoundResourceAsStream(
        input: input,
        // step 1
        getSavedDataAsStream: _contactGateway.getSavedContactsAsStream,
        // step 2
        shouldUpdate: _contactGateway.shouldUpdate,
        // step 3
        requestData: _contactGateway.requestContacts,
        // step 4
        saveResult: _contactGateway.saveContacts,
      );
//...
}
```

## Additional information
The use cases of the system will be plainly visible within the structure of that system. Those
elements will be classes or functions or modules that have prominent positions within the
architecture, and they will have names that clearly describe their function.
From the use case, it is impossible to tell whether the application is delivered on the web, or on a
thick client, or on a console, or is a pure service.
