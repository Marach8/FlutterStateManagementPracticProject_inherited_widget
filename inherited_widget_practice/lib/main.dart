import 'package:flutter/material.dart';

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
  final String name;
  Contact({required this.name});
}


class ContactBook{
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = [Contact(name: 'Ajah Emmanuel Nnanna')];
  int get numberOfContacts => _contacts.length;

  void addContact({required Contact contact}) => _contacts.add(contact);
  void removeContact({required Contact contact}) => _contacts.remove(contact);

  Contact? getContact({required int index}) => numberOfContacts > index ? _contacts[index] : null;
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(title: const Text('Contacts List Homepage'), backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: contactBook.numberOfContacts,
        itemBuilder: (context, index) {
          final contact = contactBook.getContact(index: index)!;
          return ListTile(
            title: Text(contact.name,)
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
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(title: const Text('Add a new Contact'), backgroundColor: Colors.blue),
      body: Column(
        children: [
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
      )
    );
  }
}