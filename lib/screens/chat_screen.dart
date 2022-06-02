import 'dart:typed_data';
import 'package:blabla/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'welcome_screen.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _mAuth = FirebaseAuth.instance;
  late String messageText;
  late final String documentId;
  final messageTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  CollectionReference messages = _firestore.collection('messages');
  late String fileType;
  late String fileName;
  late int fileSize;
  late Uint8List? fileBytes;
  FirebaseStorage storage = FirebaseStorage.instance;
  late SnackBar snackBar;

  void getCurrentUser() async {
    try {
      final User? user = _mAuth.currentUser;

      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  uploadImageFile() async {
    FilePickerResult? result;
    snackBar = const SnackBar(
      content: Text('Sending Attachment..'),
      duration: Duration(milliseconds: 2000),
      backgroundColor: kTitleTextColor,
    );
    final storageRef = storage.ref();
    try {
      result = await FilePicker.platform
          .pickFiles(withData: true, type: FileType.image);
      Navigator.pop(context);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        fileName = result.files.first.name;
        fileBytes = result.files.first.bytes!;
        fileType = result.files.first.extension!;
        fileSize = result.files.first.size;
        var image = await FlutterImageCompress.compressWithList(
          fileBytes!,
          quality: 60,
        );
        await storageRef.child('images/$fileName').putData(image);
        var storedImage =
            await storageRef.child('images/$fileName').getDownloadURL();

        messages.add({
          'userId': loggedInUser.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'sender': loggedInUser.email,
          'text': storedImage,
          'type': fileType,
          'name': fileName,
          'size': fileSize
        });
      } else
        return;
    } catch (e) {
      print(e);
    }
  }

  uploadFile() async {
    FilePickerResult? result;
    snackBar = const SnackBar(
      content: Text('Sending Attachment..'),
      duration: Duration(milliseconds: 2000),
      backgroundColor: kTitleTextColor,
    );
    final storageRef = storage.ref();
    try {
      result = await FilePicker.platform
          .pickFiles(withData: true, type: FileType.any);
      Navigator.pop(context);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        fileName = result.files.first.name;
        fileBytes = result.files.first.bytes!;
        fileSize = result.files.first.size;
        fileType = result.files.first.extension!;
        await storageRef.child('files/$fileName').putData(fileBytes!);
        var storedFile = result.files.first.path;
        // await storageRef.child('files/$fileName').getDownloadURL();
        if (storedFile != 0) {
          messages.add({
            'userId': loggedInUser.uid,
            'timestamp': FieldValue.serverTimestamp(),
            'sender': loggedInUser.email,
            'text': storedFile,
            'name': fileName,
            'size': fileSize,
            'type': fileType,
          });
        }
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        shadowColor: kLogoColor,
        backgroundColor: Colors.white,
        foregroundColor: kTitleTextColor,
        actions: [
          IconButton(
            onPressed: () {
              _mAuth.signOut();
              Navigator.pushReplacementNamed(context, WelcomeScreen.id);
            },
            icon: const Icon(
              FontAwesomeIcons.xmark,
              color: kTitleTextColor,
            ),
          ),
        ],
        title: Text(
          'Bla Bla',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
                color: kTitleTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 24),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MessagesStream(),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    onSubmitted: (value) {
                      messageTextController.clear();
                      messages.add({
                        'userId': loggedInUser.uid,
                        'timestamp': FieldValue.serverTimestamp(),
                        'sender': loggedInUser.email,
                        'text': messageText,
                        'type': 'txt',
                        'size': 0,
                        'name': '',
                      });
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kMainColor,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AttachmentButton(
                                      color: Colors.indigoAccent,
                                      icon: FontAwesomeIcons.solidImage,
                                      onPressed: () => uploadImageFile()),
                                  AttachmentButton(
                                      color: Colors.redAccent,
                                      icon: FontAwesomeIcons.solidFile,
                                      onPressed: () => uploadFile()),
                                  // AttachmentButton(
                                  //     color: Colors.teal,
                                  //     icon: FontAwesomeIcons.locationArrow,
                                  //     onPressed: () {}),
                                  // AttachmentButton(
                                  //     color: Colors.deepOrangeAccent,
                                  //     icon: FontAwesomeIcons.camera,
                                  //     onPressed: () {})
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}

class AttachmentButton extends StatelessWidget {
  AttachmentButton(
      {required this.color, required this.icon, required this.onPressed});
  final Color color;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;
  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return const Center(
            heightFactor: 5,
            child: CircularProgressIndicator(
              color: kLogoColor,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        for (var message in messages) {
          final time = message.get('timestamp');
          try {
            final currentTime =
                DateFormat.Hm().format(time!.toDate()).toString();
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final fileType = message.get('type');
            final fileName = message.get('name') ?? '';
            final fileSize = message.get('size') ?? 0;
            final currentUser = loggedInUser.email;
            final messageWidget = MessageBubble(
              sender: messageSender,
              messageText: messageText,
              messageTime: currentTime,
              type: fileType,
              isMe: currentUser == messageSender,
              fileName: fileName,
              fileSize: fileSize,
            );
            messageWidgets.add(messageWidget);
          } catch (e) {
            print(e);
          }
          _needsScroll = true;
        }
        if (_needsScroll) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
          _needsScroll = false;
        }
        return Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender,
      required this.messageText,
      required this.messageTime,
      required this.type,
      required this.isMe,
      this.fileName,
      this.fileSize});
  final String sender;
  final String messageText;
  final String messageTime;
  final bool isMe;
  final String type;
  final String? fileName;
  final int? fileSize;

  void openFile(file) {
    OpenFile.open('$file');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: isMe ? kMainColor : kTitleTextColor,
            borderRadius: BorderRadius.only(
                topLeft: isMe
                    ? const Radius.circular(18.0)
                    : const Radius.circular(2.0),
                bottomLeft: const Radius.circular(18.0),
                bottomRight: isMe
                    ? const Radius.circular(2.0)
                    : const Radius.circular(18.0),
                topRight: const Radius.circular(18.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isMe
                      ? const SizedBox.shrink()
                      : Text(
                          isMe ? '' : sender,
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 10,
                              color: kLogoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (type == 'txt')
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 1.5),
                            child: Text(
                              messageText,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (type == 'jpg' || type == 'png' || type == 'gif')
                        Flexible(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image(
                              width: MediaQuery.of(context).size.width / 2,
                              image: NetworkImage(
                                messageText,
                              ),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  widthFactor: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: CircularProgressIndicator(
                                      color: isMe
                                          ? Colors.white
                                          : kLogInButtonColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      else
                        TextButton(
                          onPressed: () => openFile(messageText),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.solidFile,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              const SizedBox(
                                width: 2.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fileName!,
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(fileSize! / 1000).toStringAsFixed(2)} kB',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        messageTime,
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
