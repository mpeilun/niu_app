import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
class ClubActivity extends StatefulWidget {

  const ClubActivity({Key? key}) : super(key: key);

  @override
  _ClubActivityState createState() => _ClubActivityState();
}

class _ClubActivityState extends State<ClubActivity> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Image> list(){
    List<Image> re = [] ;
    for(int i = 0;i < 4;i++)
      re.add(Image.asset(
        'assets/sempleIMG/img$i.jpg',
        fit: BoxFit.cover,
      ));
    return re;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('社團活動'),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.width*0.9,
            alignment: Alignment.center,
            child: ImageSlideshow(

              /// Width of the [ImageSlideshow].
              width: double.infinity,

              /// Height of the [ImageSlideshow].
              height: double.infinity,

              /// The page to show when first creating the [ImageSlideshow].
              initialPage: 0,

              /// The color to paint the indicator.
              indicatorColor: Colors.blue,

              /// The color to paint behind th indicator.
              indicatorBackgroundColor: Colors.grey,

              /// The widgets to display in the [ImageSlideshow].
              /// Add the sample image file into the images folder
              children: list(),

              /// Called whenever the page in the center of the viewport changes.
              onPageChanged: (value) {
                print('Page changed: $value');
              },

              /// Auto scroll interval.
              /// Do not auto scroll with null or 0.
              autoPlayInterval: 3000,

              /// Loops back to first slide.
              isLoop: true,
            ),
          ),
        ),
      );
  }
}
