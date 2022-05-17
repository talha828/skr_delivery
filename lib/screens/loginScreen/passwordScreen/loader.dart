import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../widget/constant.dart';

class loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: Container(
              alignment: Alignment.center,
              child: SpinKitSpinningLines(
                color: themeColor1,
                lineWidth: 4,
                itemCount: 10,
                duration: Duration(milliseconds: 2000),
              )
          ),
        ));
  }
}
