import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/models/group_name.dart';
import 'package:pippips/models/hive_models/conversation.dart';
import 'package:pippips/pages/ChatHistoryPage/widgets/chat_history_item.dart';
import 'package:pippips/pages/splash_page.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/services/get_group_chat.dart';
import 'package:pippips/utils/boxChat.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/icons.dart';
import 'package:pippips/utils/prompts.dart';
import 'package:pippips/widgets/custom_app_bar.dart';
import 'package:pippips/widgets/user_menu_widget.dart';

import '../../utils/fonts.dart';
import '../../widgets/loading_widget.dart';



class ChatHistoryPage extends StatefulWidget{
  final String? prevPage;


  const ChatHistoryPage({
    super.key,
    this.prevPage
  });

  @override
  State createState() => ChatHistoryState();
}

class ChatHistoryState extends State<ChatHistoryPage>{
  List<Conversation> conversations = [];
  int totalConversations = 0;
  List<Widget> historyList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllConversations();
  }



  void getAllConversations() async {
    setState(() {
      historyList.clear();
      historyList.add(const Align(
        alignment: Alignment.center,
        child: LoadingScreen(color: AppColors.warning, size: 32),
      ));
    });

    conversations = AppBoxChat.getAllConversations();
    List<Widget> tempList = [];

    if (conversations.isNotEmpty) {
      totalConversations = conversations.length;
      final results = await Future.wait(
        conversations.map((conv) async {
          final x = await GetGroupChat().getGroupChat(conv.id);
          GroupNameModel model = GroupNameModel.fromJson(x);
          final lastMessage = conv.lastMessage;
          return ChatHistoryItem(
            title: conv.title,
            hasRead: (lastMessage == model.groupName), //Sua lai de cap nhat
            onTap: () {
              context.goNamed(
                AppRoutes.chat.name,
                extra: {
                  'totalConv': totalConversations,
                  'conversationId': conv.id,
                  'quoteCode': conv.codeQuote
                },
              );
            },
          );
        }),
      );
      tempList.addAll(results);
    } else {
      setState(() {
        historyList.add(
          Center(
              child: Column(
                children: [
                  AppIcons.NotFound,
                  // const SizedBox(height: 8,),
                  Text( "No Data",
                    style: AppFonts.beVietnamRegular14.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              )
          ),
        );
      });
    }
    setState(() {
      historyList = tempList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.prevPage != null,
      onPopInvoked: (didPop) async {
        if (!didPop && widget.prevPage == null) {
          final shouldExit = await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(AppPrompts.exit, style: AppFonts.beVietnamMedium12.copyWith(color: AppColors.textPrimary)),
              content: Text(AppPrompts.sureExit, style: AppFonts.beVietnamMedium14.copyWith(color: AppColors.textPrimary)),
              actions: [
                CupertinoDialogAction(
                  child: Text(AppPrompts.decline, style: AppFonts.beVietnamMedium12.copyWith(color: AppColors.textPrimary)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  child: Text(AppPrompts.sure, style: AppFonts.beVietnamMedium12.copyWith(color: AppColors.textPrimary)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );

          if (shouldExit == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundMain,
        appBar: CustomAppBar(
          title: AppPrompts.chatHistory,
          goBack: false,
          rightscr: Container(
            margin: const EdgeInsets.only(right: 16),
            child: const UserMenuWidget(),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16,0,16,16),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                    children: historyList,
                  )
              ),
              GestureDetector(
                onTap: () => context.pushNamed(
                    AppRoutes.chat.name,
                    extra:{
                      'totalConv' : totalConversations,
                    }
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textPrimary,
                  ),
                  child: Center(
                    child: Text(
                      AppPrompts.datXeMess,
                      style: AppFonts.robotoMedium16.copyWith(color: AppColors.textWhite),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );




  }


}