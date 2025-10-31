import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';
import 'package:pippips/utils/icons.dart';
import 'package:pippips/utils/prompts.dart';
import '../../routes/app_routes.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();


    Timer(const Duration(seconds: 4), () {
      context.go(AppRoutes.chat_history.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      body: Stack(
         children: [
           Center(
             child: Container(
               width: size.width * 0.5,
               height: size.width * 0.5,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(16),
               ),
               clipBehavior: Clip.antiAlias,
               child: AppIcons.PippipLogo,
             ),
           ),
           Align(
             alignment: Alignment.bottomCenter,
             child: Container(
               margin: const EdgeInsets.only(bottom: 50),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   AppIcons.buildSpinningWidget(child: AppIcons.LoadingIcon,),
                   Text(
                     AppPrompts.loading,
                     style: AppFonts.beVietnamRegular14.copyWith(color: AppColors.textSecondary),
                   )
                 ],
               ),
             ),
           )

         ],
      )



    );
  }
}
