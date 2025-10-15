import 'dart:io';
import 'package:agenda_de_contatos/database/helper/contact_helper.dart';
import 'package:agenda_de_contatos/database/model/contact_model.dart';
import 'package:agenda_de_contatos/view/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum Orderoptions { orderAz, orderZa }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];
  @override
  void initState() {
    super.initState();
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agenda de Contatos",
          style: TextStyle(color: const Color.fromARGB(255, 252, 254, 255)),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Orderoptions>(
            itemBuilder: (context) => <PopupMenuEntry<Orderoptions>>[
              PopupMenuItem(
                value: Orderoptions.orderAz,
                child: Text("Ordernar de A-Z"),
              ),
              PopupMenuItem(
                value: Orderoptions.orderZa,
                child: Text("Ordernar de Z-A"),
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 252, 254, 255),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsetsGeometry.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img!))
                        : AssetImage("assets/imgs/avatar.png") as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      launch("tel: ${contacts[index].phone}");
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ligar",
                      style: TextStyle(color: Colors.green, fontSize: 20.0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                    child: Text(
                      "Editar",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _deleteContact(index, context);
                    },
                    child: Text(
                      "Excluir",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteContact(int index, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Deseja mesmo deletar esse contato?",
                    style: TextStyle(color: Colors.redAccent, fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      if (contacts[index].id != null) {
                        Navigator.pop(context);
                        helper.deleteContact(contacts[index].id!);
                        setState(() {
                          contacts.removeAt(index);
                        });
                      }
                    },
                    child: Text("Sim"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Não"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactPage({Contact? contact}) async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );
    if (updatedContact != null) {
      setState(() {
        helper.getAllContacts().then((list) {
          setState(() {
            contacts = list;
          });
        });
      });
    }
  }

  void _orderList(Orderoptions result) {
    switch (result) {
      case Orderoptions.orderAz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case Orderoptions.orderZa:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
