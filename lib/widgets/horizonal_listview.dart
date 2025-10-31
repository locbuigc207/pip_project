import 'package:flutter/material.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';
import 'package:pippips/utils/prompts.dart';


class Horizional_Listview extends StatefulWidget {

  final TextEditingController edtcontroller;
  final List<String> choice_prompt;


  const Horizional_Listview({
    super.key,
    required this.edtcontroller,
    required this.choice_prompt,
  });

  @override
  State createState() => Horizional_ListviewState();
}

class Horizional_ListviewState extends State<Horizional_Listview> {
  String? askin_text;

  Widget box_asking(String text){
    return GestureDetector(
      onTap: (){
        setState(() {
          askin_text = text;
          widget.edtcontroller.text = text;
        });
      },
       child: Container(
         constraints: const BoxConstraints(
           maxWidth:  160,
         ),
         decoration: BoxDecoration(
           color: AppColors.backgroundMain,
           borderRadius: BorderRadius.circular(10),
           border: Border.all(width: 2, color: AppColors.greyBorder)
         ),
         padding: const EdgeInsets.all(8),
         margin: const EdgeInsets.symmetric(horizontal: 4),
         child: Center(
           child: Text(
             text, style: AppFonts.beVietnamRegular12.copyWith(color: AppColors.textPrimary),
             textAlign: TextAlign.start,
             maxLines: 2,
             softWrap: true,
             overflow: TextOverflow.visible,
           ),
         ),
       ), 
    );
  }


  @override
  Widget build(BuildContext context){
    final ask_prompts = widget.choice_prompt;
    return Container(
      height: 60,
      child: (askin_text == null)?
          ListView.builder(
              itemCount: ask_prompts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return box_asking(ask_prompts[index]);
              }
          ) : const SizedBox(),
    );
  }


}