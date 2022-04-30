import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skr_delivery/screens/child_lock/security_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';

class MessagePinScreen extends StatefulWidget {
  String pin;
  List<String> contactNumbers;
  Function onSuccess;
  Function onFailed;

  MessagePinScreen({Key key, this.pin, this.contactNumbers, this.onSuccess, this.onFailed}) : super(key: key);

  @override
  _MessagePinScreenState createState() => _MessagePinScreenState();
}

class _MessagePinScreenState extends State<MessagePinScreen> {
  TextEditingController txt1,txt2,txt3,txt4;
  String enteredPin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txt1=TextEditingController();
    txt2=TextEditingController();
    txt3=TextEditingController();
    txt4=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;

    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VariableText(text: "Enter the 4-digit code sent to",
                  fontsize: height * 0.025,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  ),
                SizedBox(height: height*0.01),
                Column(
                  children: List.generate(widget.contactNumbers.length, (index){
                    return VariableText(text: widget.contactNumbers[index],
                        fontsize: height * 0.020,
                        textAlign: TextAlign.start,
                        line_spacing: 1,
                        );
                  }),
                ),
                SizedBox(height: height*0.02),
                Row(
                  children: [
                    createCodeField(txt1,txt2),SizedBox(width: 15),
                    createCodeField(txt2,txt3),SizedBox(width: 15),
                    createCodeField(txt3,txt4),SizedBox(width: 15),
                    createCodeField(txt4,null),
                  ],
                ),
                SizedBox(height: height*0.05),
                LoginButton(text: "Verify",onTap: (){
                  if(enteredPin == widget.pin){
                    Navigator.of(context).pop();
                    widget.onSuccess();
                  }else{
                    Fluttertoast.showToast(
                        msg: "Incorrect pin",
                        toastLength: Toast.LENGTH_SHORT);
                  }
                },),
              ],),
          ),));
  }

  Widget createCodeField(TextEditingController cont,TextEditingController next_cont){
    return Expanded(
        child:CodeField(
          cont: cont,
          next_cont: next_cont,
          onComplete: (value){
            setState(() {
              enteredPin = txt1.text+txt2.text+txt3.text+txt4.text;
            });
            print(enteredPin);
          },
        ));
  }

}
