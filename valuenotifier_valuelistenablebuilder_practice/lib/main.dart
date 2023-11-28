import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main(){
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inherited Widget Practice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
      routes: {
        'addcontacts': (context) => const AddContactView(),
      }
    );
  }
}



class Contact{
  final String name; final String id;
  Contact({required this.name}): id = const Uuid().v4();
}


class ContactBook extends ValueNotifier<List<Contact>>{
  ContactBook._sharedInstance(): super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  void addContact({required Contact contact}){value.add(contact); notifyListeners();}
  void removeContact({required Contact contact}){
    if (value.contains(contact)){value.remove(contact); notifyListeners();}
  }

  Contact? getContact({required int index}) => value.length > index ? value[index] : null;
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(title: const Text('Contacts List Homepage'), backgroundColor: Colors.blue),
      body: ValueListenableBuilder(
        valueListenable: contactBook,
        builder: (context, valueContacts, child){
          return ListView.builder(
            itemCount: valueContacts.length,
            itemBuilder: (context, index) {
              final contact = valueContacts[index];
              return Dismissible(
                key: ValueKey(contact.id),
                onDismissed: (direction){contactBook.removeContact(contact: contact);},
                child: Material(
                  color: Colors.white, elevation: 6,
                  child: ListTile(
                    title: Text(contact.name,)
                  ),
                ),
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async{await Navigator.of(context).pushNamed('addcontacts');},
        child: const Icon(Icons.add,),
      )
    );
  }
}


class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {

  late final TextEditingController _controller;
  final ContactBook contactBook = ContactBook();

  @override 
  void initState(){super.initState(); _controller = TextEditingController();}

  @override 
  void dispose(){_controller.dispose(); super.dispose();}
  
  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(title: const Text('Add a new Contact'), backgroundColor: Colors.blue),
      body: ValueListenableBuilder(
        valueListenable: contactBook,
        builder: (context, contactValue, child){
          return Column(
            children: [
              Text('You have ${contactValue.length} contacts'),
              const SizedBox(height:10),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter the name of a new contact'
                )
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: (){contactBook.addContact(contact: Contact(name: _controller.text)); Navigator.pop(context);},
                child: const Text('Add Contact')
              )
            ]
          );
        }
      )
    );
  }
}