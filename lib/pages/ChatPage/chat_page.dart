import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/models/group_message.dart';
import 'package:pippips/models/hive_models/chat_message.dart';
import 'package:pippips/models/hive_models/conversation.dart';
import 'package:pippips/models/quote_model.dart';
import 'package:pippips/models/request_quote_model.dart';
import 'package:pippips/models/send_messsage.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/services/get_chat_text.dart';
import 'package:pippips/services/get_group_chat.dart';
import 'package:pippips/services/send_message.dart';
import 'package:pippips/utils/boxChat.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';
import 'package:pippips/utils/icons.dart';
import 'package:pippips/utils/index.dart';
import 'package:pippips/utils/prompts.dart';
import 'package:pippips/pages/ChatPage/widgets/answer_text_box.dart';
import 'package:pippips/widgets/custom_app_bar.dart';
import 'package:pippips/widgets/custom_text_field.dart';
import 'package:pippips/widgets/loading_widget.dart';
import 'package:pippips/widgets/user_menu_widget.dart';
import '../../services/get_quote.dart';
import '../../widgets/horizonal_listview.dart';
import '../../widgets/microphone.dart';

class ChatPage extends StatefulWidget{
  final int totalConv;
  final String? conversationId;
  final String? quoteCode;
  const ChatPage({
    super.key,
    this.totalConv = 0,
    this.conversationId,
    this.quoteCode,
  });
  @override
  State createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  bool? isTabletShow;
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  List<Widget> mess_ui_list = [];
  List<ChatMessage> chat_list = [];
  bool hasTyped = false; //Kiem tra nguoi dung da nhap gi chua
  bool mic = false;
  String? convId;
  bool hasReponsed = false; //Kiem tra bot da response lai hay chua
  int step = 1, upload = 0;
  RequestQuoteModel? requestQuoteModel;
  @override
  void initState() {
    super.initState();
    convId = widget.conversationId;
    chat_list.clear();
    mess_ui_list.clear();
    addBotChatUI(AppPrompts.firstBotMess);
    hasReponsed = true;
    requestQuoteModel = RequestQuoteModel();
    _focusNode.addListener(() {
      setState(() {
        isTabletShow = _focusNode.hasFocus;
      });
      if (_focusNode.hasFocus && mic) {
        setState(() {
          mic = false;
        });
      }
    });
    if(widget.conversationId != null){
      loadDataChat();
    }else{
      hasReponsed = true;
      getMessage(step);
    }
  }

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    requestQuoteModel = RequestQuoteModel();
    if (widget.conversationId != oldWidget.conversationId) {
      convId = widget.conversationId;
      chat_list.clear();
      mess_ui_list.clear();
      hasReponsed = false;
      addBotChatUI(AppPrompts.firstBotMess);
      hasReponsed = true;
      if (convId != null) {
        loadDataChat();
      } else {
        getMessage(step);
      }
    }
  }


  @override
  void dispose() {
    _focusNode.dispose();
    textEditingController.dispose();
    _scrollController.dispose();
    chat_list.clear();
    mess_ui_list.clear();
    step = 0;
    super.dispose();
  }


  Future<void> getMessage(int step) async{
    if(step < 8){
      addLoadingScreen();
      final msg = await GetChatMessage().getChatfromStep(step);
      setState(() {
        mess_ui_list.removeLast();
      });
      if (msg != null) {
        addBotMessage(msg);
      } else {
        addBotMessage(AppPrompts.errorMess);
      }
      //thay doi bien upload
      setState(() {
        upload = 0;
      });
    }
  }

  Future<void> loadDataChat() async{
    bool hasLink = false;
    final x = await GetGroupChat().getgroupDetail(convId!);
    GroupDetailModel groupDetailModel = GroupDetailModel.fromJson(x);
    List<ListMessage> messages = groupDetailModel.listMessage!;
    setState(() {
      step = groupDetailModel.groupStep!;
    });
    if(messages != null){
      for(ListMessage mess in messages){
        String message = mess.message!;
        bool isHuman = (mess.sender == 1)? true : false;
        if(!isHuman){
          addBotChatUI(message);
        }else {
          addSenderChatUI(message);
        }
        //Lay link cho data
        if(mess.messStep == 6 && isHuman){
          await getMessage(7);
          await getQuoteLink();
          hasLink = true;
        }
      }
    }
    //Cap nhat trang thai cho Hive
    ListMessage lstmess = messages.last;
    String mess = lstmess.message!;
    if(!hasLink || step > 7) {
      if (lstmess.sender == 0) {
        lstmess = messages[messages.length - 2];
      }
      await AppBoxChat.updateHasRead(convId!, lstmess.message, mess, null);
    }
    if(lstmess.sender != 0) {
      _answerMessage();
    }
    setState(() {
      hasTyped = false;
    });

  }


  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void addBotChatUI(String message, {VoidCallback? onTap}){
    setState(() {
      mess_ui_list.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasReponsed)
              Container(
                margin: const EdgeInsets.only(left: 42, bottom: 8),
                child: Text(
                  AppPrompts.BotName,
                  style: AppFonts.beVietnamRegular12.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasReponsed)
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      AppIcons.PippipLogo_Path,
                      width: 32,
                      height: 32,
                    ),
                  ),
                const SizedBox(width: 8),
                Container(
                  margin: (hasReponsed)?  const EdgeInsets.only(left: 32) : null,
                  child: AnswerTextBox(
                    onTap: onTap,
                    isHuman: false,
                    text: message,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }



  void addBotMessage(String message, {VoidCallback? onTap}) async{
    addBotChatUI(message, onTap: onTap);
    if(convId != null){
      await AppBoxChat.updateHasRead(convId!, null, message, null);
    }
    setState(() {
      hasTyped = false;
    });
    if (!hasReponsed) hasReponsed = true;
    scrollToBottom();
  }

  void _answerMessage() async {
    step += 1;
    await getMessage(step);
    if(step == 7){
      await getQuoteLink();
    }
  }

  Future<void> getQuoteLink() async {
    if(widget.quoteCode == null) {
      final quote = await GetQuote().getQuote(requestQuoteModel!);
      String quoteLink = quote["link"].toString();
      String quoteCode = quote["code"].toString();
      await AppBoxChat.updateHasRead(convId!, quoteLink, null, quoteCode);
      addBotMessage(quoteLink,
          onTap: (){
            if (quoteLink != null) {
              AppIndex.openLink(context, quoteLink);
            }
          }
      );
    } else {
      if(convId != null) {
        final quoteLink = await GetQuote().getQuoteById(widget.quoteCode!);
        await AppBoxChat.updateHasRead(convId!, quoteLink, null, null);
        addBotMessage(quoteLink ?? "Báo giá không tồn tại hoặc đã hết hạn.",
            onTap: (){
              if (quoteLink != null) {
                AppIndex.openLink(context, quoteLink);
              }
            }
        );
      }
    }
  }


  void addSenderChatUI(String newMessage){
    setState(() {
      hasTyped = true;
      mess_ui_list.add(AnswerTextBox(
        isHuman: true,
        text: newMessage,
      ));
      hasReponsed = false;
    });
  }

  void addLoadingScreen(){
    setState(() {
      mess_ui_list.add(const Align(
        alignment: Alignment.centerLeft,
        child: LoadingScreen(color: AppColors.warning, size: 32),
      ));
    });
  }

  Future<void> _handlerSaveChat(String newMessage) async{
    final pack = await AppBoxChat.getConversationById(convId!);
    if(pack == null) {
      Conversation conv = Conversation(
        id: convId!,
        title: newMessage,
        lastMessage: newMessage,
        hasRead: true,
      );
      await AppBoxChat.saveConversation(conv);
    }else{
      await AppBoxChat.updateHasRead(convId!, newMessage, newMessage, null);
    }
  }


  void _addMessage() async{
    final newMessage = textEditingController.text.trim();
    if (newMessage.isNotEmpty) {
      addSenderChatUI(newMessage);
      //Tao Body cho request
      UpdateBodyRequest(newMessage);
      SendMessageModel send = SendMessageModel(
          groupid: convId,
          message: newMessage,
          step: step,
          sender: 1
      );
      final group = await SendMessageService().sendMessage(send);
      if(group["success"] == true){
        setState(() {
          convId = group["groupid"];
          _handlerSaveChat(newMessage);
        });
        _answerMessage();
      }else{
        addBotMessage(group["message"]);
      }
      textEditingController.clear();
      scrollToBottom();
      /// Delay để đảm bảo ListView đã build xong rồi mới cuộn
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void UpdateBodyRequest(String mess){
    switch(step){
      case 1:
        {
          break;
        }
      case 2:
        {
          requestQuoteModel!.pickupTime = mess;
          break;
        }
      case 3:
        {
          requestQuoteModel!.pickupAddress = mess;
          break;
        }
      case 4:
        {
          requestQuoteModel!.destination = mess;
          break;
        }
      case 5:
        {
          requestQuoteModel!.returnTime = mess;
          break;
        }
      case 6:
        {
          var strong = AppIndex.getPhoneNumber(mess);
          requestQuoteModel!.customerName =
          (strong["name"] != null && strong["name"]!.trim().isNotEmpty)
              ? strong["name"]
              : "A";
          requestQuoteModel!.customerPhone = strong["phone"];

        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: CustomAppBar(
        title: "Chats",
        goBack: false,
        leftscr: GestureDetector(
            onTap: () => context.pushNamed(
                AppRoutes.chat_history.name,
                extra: {'prevPage' : AppRoutes.chat.name}
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
              clipBehavior: Clip.antiAlias,
              child: AppIcons.MenuIcon,
            )
        ),
        rightscr: Container(
          margin: const EdgeInsets.only(right: 16),
          child: const UserMenuWidget(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: mess_ui_list.length,
                itemBuilder: (context, index) => mess_ui_list[index],
              ),
            ),
            const SizedBox(height: 16,),
            // if(step >= 1 && !hasTyped)
            //   AnimatedSwitcher(
            //     duration: const Duration(milliseconds: 1000),
            //     transitionBuilder: (Widget child, Animation<double> animation) {
            //       return FadeTransition(
            //         opacity: animation,
            //         child: child,
            //       );
            //     },
            //     child: Horizional_Listview(
            //       edtcontroller: textEditingController,
            //       choice_prompt: AppPrompts.asking_prompt,
            //     ),
            //   ),
            // const SizedBox(height: 8,),
            CustomTextField(
                controller: textEditingController,
                // readOnly: hasTyped,
                hintText: "Input something",
                maxLines: 4,
                focusNode: _focusNode,
                onSubmitted: (value) {
                  if(!hasTyped == true && upload == 0){
                    setState(() {
                      upload = 1;
                    });
                    _addMessage();
                  }
                },
                suffixIcon: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // constraints: const BoxConstraints(
                  //   maxWidth: 80,
                  //   minWidth: 40
                  // ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: (){
                          if (_focusNode.hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          setState(() {
                            mic = !mic;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AppIcons.TalkMessage,
                        ),
                      ),
                      const SizedBox(width: 8,),
                      GestureDetector(
                        onTap: (hasTyped && upload != 0)? null : (){
                          setState(() {
                            upload = 1;
                          });
                          _addMessage();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AppIcons.SendMessage,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            if(mic) MicroPhone(controller: textEditingController),
          ],
        ),
      ),
    );



  }
}