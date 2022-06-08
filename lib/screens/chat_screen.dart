import 'dart:ffi';
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

  const ChatScreen({Key? key}) : super(key: key);

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
  FirebaseStorage storage = FirebaseStorage.instance;
  late String fileType;
  late String fileName;
  late int fileSize;
  late Uint8List? fileBytes;

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
        backgroundColor: kAppBarBackgroundColor,
        foregroundColor: kTitleTextColor,
        actions: [
          IconButton(
            onPressed: () {
              _mAuth.signOut();
              Navigator.pushReplacementNamed(context, WelcomeScreen.id);
            },
            icon: kCloseIcon,
          ),
        ],
        title: Text(
          kTitleText,
          style: GoogleFonts.nunito(
            textStyle: kChatTitleTextStyle,
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
            margin: kMessageContainerMargin,
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
                              padding: kModalBottomSheetPadding,
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
                    child: kAddAttachmentIcon)
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
          padding: kAttachmentPadding,
          child: Icon(
            icon,
            color: kAttachmentIconsColor,
            size: kAttachmentIconsSize,
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
        if (snapshot.hasError) {
          return kErrorText;
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return kLoadingState;
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
            final messageId = message.id;
            final currentUser = loggedInUser.email;
            final messageWidget = MessageBubble(
              sender: messageSender,
              messageText: messageText,
              messageTime: currentTime,
              type: fileType,
              isMe: currentUser == messageSender,
              fileName: fileName,
              fileSize: fileSize,
              messageId: messageId,
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
            padding: kListViewPadding,
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
      this.fileSize,
      required this.messageId});
  final String sender;
  final String messageText;
  final String messageTime;
  final bool isMe;
  final String type;
  final String? fileName;
  final int? fileSize;
  final String messageId;

  final CollectionReference messages = _firestore.collection('messages');

  void deleteMessage() {
    messages.doc(messageId).delete();
  }

  void openFile(file) {
    OpenFile.open('$file');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kMessageBubblePadding,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Dismissible(
            key: Key(messageId),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return isMe
                        ? AlertDialog(
                            title: kAlertDeleteTitle,
                            content: kAlertDeleteContent,
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    deleteMessage();
                                    Navigator.of(context).pop(true);
                                  },
                                  child: kDeleteConfirmationText),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: kCancelConfirmationText,
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: kTitleCancelText,
                            content: kContentCancelText,
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: kCancelConfirmationText,
                              ),
                            ],
                          );
                  });
            },
            child: Material(
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
                padding: kMessagesPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isMe
                        ? const SizedBox.shrink()
                        : Text(
                            isMe ? '' : sender,
                            style: GoogleFonts.nunito(
                              textStyle: kSenderTextStyle,
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
                                  textStyle: kMessageTextStyle,
                                ),
                              ),
                            ),
                          )
                        else if (type == 'jpg' ||
                            type == 'png' ||
                            type == 'gif')
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
                                kFileIcon,
                                kFileTextSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName!,
                                      style: GoogleFonts.nunito(
                                        textStyle: kFileMessageTextStyle,
                                      ),
                                    ),
                                    Text(
                                      '${(fileSize! / 1000).toStringAsFixed(2)} kB',
                                      style: GoogleFonts.nunito(
                                        textStyle: kFileMessageSizeStyle,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        kMessageSpaceTime,
                        Text(
                          messageTime,
                          style: GoogleFonts.nunito(
                            textStyle: kMessageTextTimeStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
