import 'package:flutter/material.dart';

import '../../widget/constant.dart';


class loader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              backgroundColor: Colors.black45,
              color: themeColor1,),
          ),
        ));
  }
}
