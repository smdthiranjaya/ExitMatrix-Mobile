import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exitmatrix/common/auth/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SignInProvider class to manage user sign-in and profile information
class SignInProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _role;
  String? get role => _role;

  String? _doctorId;
  String? get doctorId => _doctorId;

  String? _age;
  String? get age => _age;

  String? _address;
  String? get address => _address;

  String? _gender;
  String? get gender => _gender;

  String? get imageUrl => _imageUrl;
  String? _imageUrl;

  String? _userName;
  String? get newReminderTitle => _userName;

  String? _userID;
  String? get newUserId => _userID;

  String? _fname;
  String? get fuser_name => _fname;

  String? _fid;
  String? get fuser_id => _fid;

  // Constructor: initializes the provider and checks user sign-in status
  SignInProvider() {
    checkSignInUser();
  }

  // Function: checks and updates user sign-in status
  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  // Function: sets user sign-in status
  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  set name(String? newName) {
    _name = newName;
    notifyListeners();
  }

  // Function: updates user age in Firestore
  Future<void> updateAge(String newAge, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"age": newAge});
      _age = newAge.toString();
      notifyListeners();
    } catch (e) {
      // Handle errors if any
    }
  }

  // Function: updates user address in Firestore
  Future<void> updateAddress(String newAddress, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"address": newAddress});
      _address = newAddress.toString();
      notifyListeners();
    } catch (e) {
      // Handle errors if any
    }
  }

  Future<void> updateRole(String newRole, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"role": newRole});
      _role = newRole.toString();
      notifyListeners();
    } catch (e) {
      // Handle errors if any
    }
  }

  Future<void> updateDoctorId(String newDoctorId, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"doctorId": newDoctorId});
      _doctorId = newDoctorId.toString();
      notifyListeners();
    } catch (e) {
      // Handle errors if any
    }
  }

  // Function: updates user gender in Firestore
  Future<void> updateGender(String newGender) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({"gender": newGender});
        _gender = newGender;
        notifyListeners();
      } catch (e) {
        // Handle errors if any
      }
    }
  }

  // Function: adds a new user in Firestore
  Future<void> addNewUser(String newUserName, String newUserID,
      String newUserType, String newUserAge) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Reference the user's document
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Reference the "users" subcollection under the user's document
        final usersCollectionRef = userDocRef.collection('userids');

        // Add a new user document using the specified newUserID as the document ID
        await usersCollectionRef.doc(newUserID).set({
          "user_name": newUserName,
          "user_id": newUserID,
          "user_type": newUserType,
          "user_age": newUserAge,
        });
      } catch (e) {
        // Handle errors if any
        print("Error adding a new user: $e");
      }
    }
  }

  Future<void> addNewPet(
      String newPetName,
      String newPetID,
      String newPetType,
      String newPetAge,
      String newPetGender,
      String newEnergylvl,
      String newPetHealthC,
      String newPetWeight) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Reference the user's document
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Reference the "pets" subcollection under the user's document
        final petsCollectionRef = userDocRef.collection('petids');

        // Add a new pet document using the specified newPetID as the document ID
        await petsCollectionRef.doc(newPetID).set({
          "pet_name": newPetName,
          "pet_id": newPetID,
          "pet_type": newPetType,
          "pet_age": newPetAge,
          "pet_Gender": newPetGender,
          "pet_Energylvl": newEnergylvl,
          "pet_HealthC": newPetHealthC,
          "pet_Weight": newPetWeight,
        });

        // Notify listeners to rebuild UI with new pet data
        notifyListeners();
      } catch (e) {
        // Handle errors if any
        print("Error adding a new pet: $e");
      }
    }
  }

  // Function: updates user profile picture in Firestore
  Future<void> updateProfilePicture(String imageUrl, String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'image_url': imageUrl});

    // Update the profile picture URL in the provider
    _imageUrl = imageUrl;
    notifyListeners();
  }

  // Function: updates user name in Firestore
  Future<void> updateName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(newName);
        name =
            newName; // Use the setter to update the name in the SignInProvider state
        await saveDataToFirestore(); // Save the updated data to Firestore
      } catch (e) {
        // Handle errors if any
      }
    }
  }

  // Function: updates user email in Firestore
  Future<void> updateEmail(String newEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({"email": newEmail});
        _email = newEmail;
        notifyListeners();
      } catch (e) {
        // Handle errors if any
      }
    }
  }

  // Function: signs in with Google
  Future<void> signInWithGoogle() async {
    _errorCode = '';

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential? userCredential =
            await firebaseAuth.signInWithCredential(credential);

        if (userCredential != null) {
          final User userDetails = userCredential.user!;

          // Save user details
          _name = userDetails.displayName;
          _email = userDetails.email;
          _imageUrl = userDetails.photoURL;
          _provider = "GOOGLE";
          _uid = userDetails.uid;
          _hasError = false;
          notifyListeners();
        } else {
          // Handle null userCredential (error case)
          _hasError = true;
          _errorCode = "Failed to sign in with Google";
          notifyListeners();
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // Function: retrieves user data from Firestore
  Future<void> getUserDataFromFirestore(uid) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      _uid = data['uid'];
      _name = data['name'];
      _email = data['email'];
      _doctorId = data['doctorId'];
      _role = data['role'];
      _age = data['age'];
      _gender = data['gender'];
      _address = data['address'];
      _imageUrl = data['image_url'];
      _provider = data['provider'];
    } else {
      // Handle the case when the document doesn't exist
      // You might want to initialize the fields to default values here
      _uid = null;
      _name = null;
      _email = null;
      _role = null;
      _doctorId = null;
      _age = null;
      _gender = null;
      _address = null;
      _imageUrl = null;
      _provider = null;
    }
  }

  // Function: saves user data to Firestore
  Future<void> saveDataToFirestore([DateTime? selectedTime]) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = {
        "name": name,
        "uid": uid,
        "age": age,
        "role": role,
        "doctorId": doctorId,
        "gender": gender,
        "address": address,
        "image_url": imageUrl,
        "email": email,
        "provider": provider,
        // Add the 'selectedTime' to the userData map only if it's not null
        if (selectedTime != null) "sleep_timer": selectedTime.toUtc(),
      };
      // Save the user data to Firestore
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData, SetOptions(merge: true));
      } catch (e) {
        // Handle errors if any
      }
    }
  }

  // Function: saves user data to SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    if (_name != null) await s.setString('name', _name!);
    if (_email != null) await s.setString('email', _email!);
    if (_role != null) await s.setString('role', _role!);
    if (_doctorId != null) await s.setString('doctorId', _doctorId!);
    if (_uid != null) await s.setString('uid', _uid!);
    if (_provider != null) await s.setString('provider', _provider!);
    if (_imageUrl != null) await s.setString('image_url', _imageUrl!);

    notifyListeners();
  }

  // Function: retrieves user data from SharedPreferences
  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _role = s.getString('role');
    _doctorId = s.getString('doctorId');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _age = s.getString('age');
    _gender = s.getString('gender');
    _address = s.getString('address');
    // _sleepTimer = s.getString('sleep_timer') as DateTime?;
    notifyListeners();
  }

  // Function: checks if user exists in Firestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      // ignore: avoid_print
      print("EXISTING USER");
      return true;
    } else {
      // ignore: avoid_print
      print("NEW USER");
      return false;
    }
  }

  // Function: signs out the user
  Future userSignOut() async {
    firebaseAuth.signOut;
    await googleSignIn.signOut();
    LogoutEvent();
    _isSignedIn = false;
    notifyListeners();
    // clear all storage information
    clearStoredData();
  }

  // Function: clears stored data
  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  // Function: placeholder for selecting profile picture from the gallery
  selectProfilePictureFromGallery() {}
}
