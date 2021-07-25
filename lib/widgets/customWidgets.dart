import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




Widget appBar_Main(BuildContext context , String appBarName, Color appBarColor){
  return AppBar(
    title: Text("$appBarName",style:appBar_Style,),
    centerTitle: true,
    elevation: 10,
    bottomOpacity: 5,
    backgroundColor: appBarColor,
  );
}


TextStyle popStyle() {
  return TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: "Acme",
    fontSize: 15,
    color: Colors.black87,
  );
}

TextStyle appBar_Style = TextStyle(
  fontSize: 31,
  fontWeight: FontWeight.bold,
  fontFamily: "Cinzel",//"Pacifico",
  letterSpacing: 1,
  //decoration: TextDecoration.lineThrough,
  color: CupertinoColors.systemTeal,//Colors.tealAccent
);

TextStyle textFieldStyle = TextStyle(
  color: CupertinoColors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14,
);

InputDecoration textInputDecoration(String hintText , IconData iconData) {
  return InputDecoration(
    contentPadding:EdgeInsets.symmetric(horizontal: 10),
    hintText: "$hintText",
    labelText: "$hintText",
    focusedBorder: UnderlineInputBorder(
      borderSide:BorderSide(color: Colors.greenAccent,
        width: 3.5,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.amberAccent,
      ),
    ),
    hintStyle: textFieldStyle,
    labelStyle: textFieldStyle,
    errorStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
    prefixIcon: Icon(iconData,color: Colors.white,),
  );
}


//
// Color textButtonColor;
// TextStyle buttonStyle = TextStyle(
//   color: textButtonColor,
//   fontSize: 18,
//   fontFamily: "Merriweather"
// );


TextStyle buttonStyle(Color textColor){
  return TextStyle(
    color: textColor,
    fontSize: 20,
    fontFamily: "Merriweather",
    fontWeight: FontWeight.bold,
  );
}

TextStyle IconStyle1 = TextStyle(
    color: Colors.teal,
    fontSize: 20,
    fontFamily: "Acme"
);



TextStyle customStyle(Color color, double size , FontWeight weight , String family ){
  return TextStyle(
    color: color,
    fontSize: size,
    fontWeight: weight,
    fontFamily:family,
  );
}





Widget zoomedImageShower(context , String entryPoint , double  paddedSize){
  return GestureDetector(
    onTap: (){
      showDialog(
          barrierColor: Colors.black87,
          context: context,
          builder: (BuildContext context){
            return Padding(
              padding:  EdgeInsets.all(paddedSize),
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    image: DecorationImage(image:NetworkImage(entryPoint),fit:BoxFit.contain)
                ),
              ),
            );
          }
      );
    },
    child: Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
          image: DecorationImage(image:NetworkImage(entryPoint),fit:BoxFit.cover)
      ),
    ),
  );
}

customDialog(context , String entryPoint ,double top,double bottom,double right,double left) {
  return showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              top: top, bottom: bottom, left: left, right: right),
          child: Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(entryPoint), fit: BoxFit.contain)
            ),
          ),
        );
      }
  );
}

TextStyle mapExpress = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: "Merriweather",
  fontSize: 18,
);