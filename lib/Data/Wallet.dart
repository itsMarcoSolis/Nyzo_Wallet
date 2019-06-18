import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:http/http.dart' as http;
import "package:hex/hex.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'Transaction.dart';
import 'NyzoMessage.dart';
import 'dart:typed_data';
import 'TransactionMessage.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:tweetnacl/tweetnacl.dart';
import 'package:flutter_sodium/flutter_sodium.dart' as sodium;
import 'package:nyzo_wallet/Data/Contact.dart';

final _storage = new FlutterSecureStorage();
final crypto = new PlatformStringCryptor();
final r = new Random.secure();

Future<bool> checkWallet() async {
  final prefs = await SharedPreferences.getInstance();
  bool flag;
  String values = prefs.getString('pubKey');
  if (values == null) {
    flag = false;
  } else {
    flag = true;
  }
  return flag;
}

Future createNewWallet(String password) async {
  final prefs = await SharedPreferences
      .getInstance(); //Create a Shared Preferences instance to save balance
  prefs.setDouble('balance', 0.0);
  final privKey = await sodium.RandomBytes.buffer(
      32); //Generates a 64 bytes array to usa as SEED (Crypto Secure)
  print("Private Key as Sodium: " + privKey.toString());
  KeyPair keyPair = Signature.keyPair_fromSeed(
      privKey); //Creates a KeyPair from the generated Seed
  Uint8List pubKey = keyPair.publicKey; //Set the Public Key
  /*here we Store our keys in the device, Secure_storage encrypts adn decrypts the content when reading and saving 
  so we dont need to take care of security, anyhow, Private key is encrypted again using user's password
  */
  final String salt = await crypto.generateSalt(); //Generate the Salt value
  final String key = await crypto.generateKeyFromPassword(
      password, salt); //Get the key to encrypt our Nyzo Private key
  final String encryptedPrivKey = await crypto.encrypt(HEX.encode(privKey),
      key); // We encrypt the private key using password and salt
  //Now we store the values in the device using secure_storage
  await _storage.write(key: "salt", value: salt);
  await _storage.write(key: "privKey", value: encryptedPrivKey);
  // We take the values starting from index 1 to get  rid of the two leading '0's (pubKey)
  prefs.setString('pubKey', HEX.encode(pubKey));
  await _storage.write(key: "Password", value: password);
  addContact(
      [],
      Contact(
          "c660f3c5b662d4632e19bc332afc29a8fa0fb9365bdd53418637323203538944",
          "Donate",
          "Help us develop this wallet."));
  return [HEX.encode(privKey), HEX.encode(pubKey)];
}

Future<bool> importWallet(String privKey, String password) async {
  Uint8List hexStringAsUint8Array(String identifier) {
    identifier = identifier.split('-').join('');
    var array = new Uint8List((identifier.length / 2).floor());
    for (var i = 0; i < array.length; i++) {
      array[i] = HEX.decode(identifier.substring(i * 2, i * 2 + 2))[0];
    }
    return array;
  }

  final prefs = await SharedPreferences
      .getInstance(); //Create a Shared Preferences instance to save balance and pubKey
  prefs.setDouble('balance', 0.0);
  KeyPair keyPair = Signature.keyPair_fromSeed(hexStringAsUint8Array(
      privKey)); //Creates a KeyPair from the generated Seed
  Uint8List pubKey = keyPair.publicKey; //Set the Public Key
  print("Public Key TweetNaCl: " + HEX.encode(pubKey));
  print(
      "Private Key TweetNaCl: " + HEX.encode(keyPair.secretKey.sublist(0, 32)));

  /*here we Store our keys in the device, Secure_storage encrypts adn decrypts the content when reading and saving 
  so we dont need to take care of security, anyhow, Private key is encrypted again using user's password
  */
  final String salt = await crypto.generateSalt(); //Generate the Salt value
  final String key = await crypto.generateKeyFromPassword(
      password, salt); //Get the key to encrypt our Nyzo Private key
  final String encryptedPrivKey = await crypto.encrypt(
      HEX.encode(hexStringAsUint8Array(privKey)),
      key); // We encrypt the private key using password and salt
  //Now we store the values in the device using secure_storage
  await _storage.write(key: "salt", value: salt);
  await _storage.write(key: "privKey", value: encryptedPrivKey);
  // We take the values starting from index 1 to get  rid of the two leading '0's (pubKey)
  prefs.setString('pubKey', HEX.encode(pubKey));
  await _storage.write(key: "Password", value: password);
  addContact(
      [],
      Contact(
          "c660f3c5b662d4632e19bc332afc29a8fa0fb9365bdd53418637323203538944",
          "Donate",
          "Help us develop this wallet."));
  return true;
}

Future getAddress() async {
  final _prefs = await SharedPreferences.getInstance();
  final _address = _prefs.getString('pubKey') ?? '';
  return _address;
}

Future getBalance(String address) async {
  final _prefs = await SharedPreferences.getInstance();
  double _balance = _prefs.getDouble('balance') ?? 70.0;
  String url = "https://nyzo.co/walletRefresh?id=" + address;
  try {
    http.Response response = await http.get(url, headers: {
      "accept": "*/*",
      "Accept-Encoding": 'gzip, deflate, br',
      "Accept-Language":
          "en-GB,en;q=0.9,fr-FR;q=0.8,fr;q=0.7,es-MX;q=0.6,es;q=0.5,de-DE;q=0.4,de;q=0.3,en-US;q=0.2",
      "Connection": "keep-alive",
      "DNT": "1",
      "Referer": "https://nyzo.co/wallet",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36",
    });
    var lmao = await json.decode(response.body)["balanceMicronyzos"];
    _balance = double.parse(lmao.toString());
    return lmao;
  } catch (e) {
    print(e.toString());
  }
  return _balance;
}

Future<String> getPrivateKey(String password) async {
  String salt = await _storage.read(key: "salt");
  String encryptedPrivKey = await _storage.read(key: "privKey");
  //String encryptedPrivKey = prefs.getString("privKey");
  final String key = await crypto.generateKeyFromPassword(
      password, salt); //Get the key to encrypt our Nyzo Private key
  String privKey = await crypto.decrypt(encryptedPrivKey, key);
  return privKey;
}

Future<List> getTransactions(String address) async {
  List<Transaction> transactions = new List();
  final _prefs = await SharedPreferences.getInstance();
  final _address = _prefs.getString('pubKey') ?? '';
  String url = "https://nyzo.co/walletRefresh?id=" + _address;
  try {
    http.Response response = await http.get(url, headers: {
      "accept": "*/*",
      "Accept-Encoding": 'gzip, deflate, br',
      "Accept-Language":
          "en-GB,en;q=0.9,fr-FR;q=0.8,fr;q=0.7,es-MX;q=0.6,es;q=0.5,de-DE;q=0.4,de;q=0.3,en-US;q=0.2",
      "Connection": "keep-alive",
      "DNT": "1",
      "Referer": "https://nyzo.co/wallet",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36",
    });
    var html = await json.decode(response.body)["creditsAndDebits"];
    var document = parse(html);
    List transactionElementList = document.getElementsByTagName("tr");

    for (Element eachTransaction in transactionElementList) {
      if (eachTransaction.text != 'typeblockamountbalance') {
        Transaction transaction = new Transaction();
        if (eachTransaction.text.toString().contains("from")) {
          transaction.type = "from";
        } else {
          transaction.type = "to";
        }
        List transactionSlice = eachTransaction.text.toString().split(" ");
        transaction.address =
            transactionSlice[2].toString().split("(")[0].split("∩")[0];
        List balanceSlice = eachTransaction.text.toString().split("∩");
        transaction.amount = double.parse(
            balanceSlice[1].toString().split(".")[0] +
                "." +
                balanceSlice[1].toString().split(".")[1].substring(0, 6));
        transactions.add(transaction);
      }
    }

    return transactions;
  } catch (e) {
    print(e.toString());
  }
  return transactions;
}

Future<String> send(String password, String account, int amount, int balance,
    String data) async {
//print("Sendinggg-------------------------------------------------------------------------------------------------");
  String encryptedprivKey = await _storage.read(key: "privKey");
  String salt = await _storage.read(key: "salt");
  final String key = await crypto.generateKeyFromPassword(password, salt);
  final String privKey = await crypto.decrypt(encryptedprivKey, key);
  String walletPrivateSeed = await getPrivateKey(password);
  String recipientIdentifier = account;
  int balanceMicronyzos = balance;
  int micronyzosToSend = amount;
  String senderData = data;

  bool specifiedTransactionIsValid() {
    //print("Private Seed length: "+walletPrivateSeed.length.toString());
    //print("recipier Identifier length: "+recipientIdentifier.length.toString());
    //print("micronyzosToSend: "+micronyzosToSend.toString());
    //print("balanceMycronyzos: "+balanceMicronyzos.toString());
    return walletPrivateSeed.length == 64 &&
        recipientIdentifier.length == 64 &&
        micronyzosToSend > 0 &&
        micronyzosToSend <= balanceMicronyzos;
  }

  Uint8List hexStringAsUint8Array(String identifier) {
    identifier = identifier.split('-').join('');
    print('identifier after split/join is ' + identifier);

    var array = new Uint8List((identifier.length / 2).floor());
    for (var i = 0; i < array.length; i++) {
      array[i] = HEX.decode(identifier.substring(i * 2, i * 2 + 2))[0];
    }

    return array;
  }

  Future<NyzoMessage> fetchPreviousHash(senderPrivateSeed) async {
    var message = new NyzoMessage();
    message.setType(NyzoMessage.PreviousHashRequest7);
    message.sign(hexStringAsUint8Array(senderPrivateSeed));
    NyzoMessage result = await message.send(privKey);
    print('got result: ' + result.content.toString());
    return result;
  }

  Uint8List stringAsUint8Array(string) {
    var unescape = new HtmlUnescape();
    String encodedString = unescape.convert(Uri.encodeComponent(string));
    Uint8List array = new Uint8List(encodedString.length);
    for (int i = 0; i < encodedString.length; i++) {
      array[i] = encodedString.codeUnitAt(i);
    }

    return array;
  }

  Future<NyzoMessage> submitTransaction(
      timestamp,
      senderPrivateSeed,
      previousHashHeight,
      previousBlockHash,
      recipientIdentifier,
      micronyzosToSend,
      senderData) async {
    print('need to send transaction');

    var transaction = new TransactionMessage();
    transaction.setTimestamp(timestamp);
    transaction.setAmount(micronyzosToSend);
    transaction
        .setRecipientIdentifier(hexStringAsUint8Array(recipientIdentifier));
    transaction.setPreviousHashHeight(previousHashHeight);
    transaction.setPreviousBlockHash(previousBlockHash);
    transaction.setSenderData(senderData);
    transaction.sign(hexStringAsUint8Array(senderPrivateSeed));
    var message = new NyzoMessage();
    message.setType(NyzoMessage.Transaction5);
    message.setContent(transaction);
    message.sign(hexStringAsUint8Array(senderPrivateSeed));
    NyzoMessage result = await message.send(privKey);
    print('got result: ' + result.content.message);
    return result;
  }

  print("byte array is: " + stringAsUint8Array(senderData).toString());

  if (specifiedTransactionIsValid()) {
    NyzoMessage result = await fetchPreviousHash(walletPrivateSeed);
    if (result == null ||
        result.content == null ||
        result.content.height == null ||
        result.content.hash == null) {
      print(
          'There was a problem getting a recent block hash from the server. Your transaction was not ' +
              'sent, so it is safe to try to send it again.');
    } else {
      if (result.content.height > 10000000000) {
        /* unsigned; a bad value is actually -1 */
        print(
            'The recent block hash sent by the server was invalid. Your transaction was not sent, so ' +
                'it is safe to try to send it again.');
      } else {
        print('previous hash height is ' + result.content.height.toString());
        print('previous block hash is ' + HEX.encode(result.content.hash));
        NyzoMessage result2 = await submitTransaction(
            result.timestamp + 7000,
            walletPrivateSeed,
            result.content.height,
            result.content.hash,
            recipientIdentifier,
            micronyzosToSend,
            utf8.encode(senderData));
        if (result2.content == null) {
          return 'There was a problem communicating with the server. To protect yourself ' +
              'against possible coin theft, please wait to resubmit this transaction. Refer ' +
              'to the Nyzo white paper for full details on why this is necessary, how long ' +
              'you need to wait, and to understand how Nyzo provides stronger protection ' +
              'than other blockchains against this type of potential vulnerability.';
        } else {
          return result2.content.message;
        }
        /* to ensure that the pending item is fetched */

      }
    }
  } else {
    return "Invalid Transaction";
  }
}

Future<List<Contact>> getContacts() async {
  final _prefs = await SharedPreferences.getInstance();
  final _contactListJson = _prefs.getString('contactList');

  if (_contactListJson != null) {
    print("lmaoo" + _contactListJson.toString());
    List<Contact> _contactList = [];
    List<dynamic> _contactListDeserialized = json.decode(_contactListJson);
    int index = _contactListDeserialized.length;
    for (var i = 0; i < index; i++) {
      _contactList.add(Contact.fromJson(_contactListDeserialized[i]));
    }
    return _contactList;
  } else {
    return [];
  }
}

Future<bool> addContact(List<Contact> contactList, Contact contact) async {
  final _prefs = await SharedPreferences.getInstance();
  final _contactListJson = _prefs.getString('contactList');
  List<Contact> _contactList = [];
  if (_contactListJson != null) {
    print("lmaoo" + _contactListJson.toString());
    List<dynamic> _contactListDeserialized = json.decode(_contactListJson);
    int index = _contactListDeserialized.length;
    for (var i = 0; i < index; i++) {
      _contactList.add(Contact.fromJson(_contactListDeserialized[i]));
    }
    _contactList.add(contact);
  } else {
    _contactList.add(contact);
  }
  saveContacts(_contactList);
  return true;
}

Future<bool> saveContacts(List<Contact> contactList) async {
  final _prefs = await SharedPreferences.getInstance();
  List<dynamic> contactsAsJsonList = [];
  for (var eachContact in contactList) {
    contactsAsJsonList.add(json.encode(eachContact.toJson()));
    _prefs.setString('contactList', contactsAsJsonList.toString());
  }
  return true;
}

void deleteWallet() async {
  final pref = await SharedPreferences.getInstance();
  await pref.clear();
  await _storage.deleteAll();
}
