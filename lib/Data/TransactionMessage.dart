import 'dart:typed_data';
import 'dart:math';
import 'ByteBuffer.dart';
import 'package:crypto/crypto.dart';
import 'package:tweetnacl/tweetnacl.dart';

class TransactionMessage {
  int timestamp;

  int amount;

  Uint8List recipientIdentifier;

  int previousHashHeight;

  Uint8List previousBlockHash;

  Uint8List senderIdentifier;

  Uint8List senderData;

  Uint8List signature;

  TransactionMessage() {
    this.timestamp = DateTime.now().millisecondsSinceEpoch;
    this.amount = 0;
    this.recipientIdentifier = new Uint8List(32);
    this.previousHashHeight = 0;
    this.previousBlockHash = new Uint8List(32);
    this.senderIdentifier = new Uint8List(32);
    this.senderData = new Uint8List(0);
    this.signature = new Uint8List(64);
  }

  setTimestamp(timestamp) {
    this.timestamp = timestamp;
  }

  setAmount(amount) {
    this.amount = amount;
  }

  setRecipientIdentifier(recipientIdentifier) {
    for (var i = 0; i < 32; i++) {
      this.recipientIdentifier[i] = recipientIdentifier[i];
    }
  }

  setPreviousHashHeight(previousHashHeight) {
    this.previousHashHeight = previousHashHeight;
  }

  setPreviousBlockHash(previousBlockHash) {
    for (var i = 0; i < 32; i++) {
      this.previousBlockHash[i] = previousBlockHash[i];
    }
  }

  setSenderData(senderData) {
    this.senderData = new Uint8List(min(senderData.length, 32));
    for (var i = 0; i < this.senderData.length; i++) {
      this.senderData[i] = senderData[i];
    }
  }

  sign(List<int> privKey) {
    KeyPair keyPair = Signature.keyPair_fromSeed(privKey);
    Uint8List pubKey = keyPair.publicKey;
    for (var i = 0; i < 32; i++) {
      this.senderIdentifier[i] = pubKey[i];
    }
    print(this.senderIdentifier.toString());
    Signature s1 = Signature(null, keyPair.secretKey);
    Uint8List signature = s1.detached(this.getBytes(false));
    for (var i = 0; i < this.signature.length; i++) {
      this.signature[i] = signature[i];
    }
  }

  getBytes(bool includeSignature) {
    var forSigning = !includeSignature;

    var buffer = new ByteBuffer(1000);

    buffer.putByte(2);
    buffer.putLong(this.timestamp);
    buffer.putLong(this.amount);
    buffer.putBytes(this.recipientIdentifier);

    if (forSigning) {
      buffer.putBytes(this.previousBlockHash);
    } else {
      buffer.putLong(this.previousHashHeight);
    }
    buffer.putBytes(this.senderIdentifier);

    if (forSigning) {
      buffer.putBytes(doubleSha256(this.senderData));
    } else {
      buffer.putByte(this.senderData.length);
      buffer.putBytes(this.senderData);
    }

    if (!forSigning) {
      buffer.putBytes(this.signature);
    }

    return buffer.toArray();
  }
}

Uint8List hexStringAsUint8Array(String identifier) {
  identifier = identifier.split('-').join('');
  print('identifier after split/join is ' + identifier);

  var array = new Uint8List(int.parse((identifier.length / 2).toString()));
  for (var i = 0; i < array.length; i++) {
    array[i] = int.parse(identifier.substring(i * 2, i * 2 + 2));
  }

  return array;
}

Uint8List sha256Uint8(array) {
  return sha256.convert(array).bytes;
}

Uint8List doubleSha256(Uint8List array) {
  return sha256Uint8(sha256Uint8(array));
}
