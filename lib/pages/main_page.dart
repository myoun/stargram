import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stargram/user.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user =
        (ModalRoute.of(context)!.settings.arguments as MainPageArgument).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Stargram",
            style: TextStyle(
                fontFamily: "SillyHandScript",
                fontSize: 30,
                color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: () => {},
            icon: Icon(
              CupertinoIcons.camera,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: () => {},
              icon: Icon(CupertinoIcons.paperplane, color: Colors.black))
        ],
      ),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
          child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => {},
              icon: Icon(Icons.home),
            ),
            IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
            // SizedBox(
            //     child: IconButton(
            //       onPressed: () => {},
            //       icon: SvgPicture.asset(
            //         "icons/add_icon.svg",
            //         semanticsLabel: "Upload Image",
            //       ),
            //     ),
            //     width: 60,
            //     height: 60),
            IconButton(
                onPressed: () => {}, icon: Icon(CupertinoIcons.add_circled)),
            IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.heart)),
            IconButton(onPressed: () => {}, icon: Icon(CupertinoIcons.person))
          ],
        ),
      )),
    );
  }
}

class MainPageArgument {
  final User user;
  const MainPageArgument(this.user);
}
