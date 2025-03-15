import 'package:flutter/material.dart';
//https://gist.github.com/Rahiche/26ebe328cc0365de6fa125d83ed59b4d
void main() => runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.tealAccent), home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double sliderValue = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Slider(
          activeColor: Colors.red,
          min: 1.0,
          max: 3.0,
          onChanged: (double value) {
            setState(() {
              sliderValue = value;
            });
            print(sliderValue);
          },
          value: sliderValue,
        ),
      ),
      body: GridView.count(
        crossAxisCount: sliderValue.toInt(),
        childAspectRatio: 16.0 / (sliderValue * 10.0),
        children: <Widget>[
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
          Card(child: Center(child: Text("DATA"))),
        ],
      ),
    );
  }
}
//Teste
Widget carouselGrid(){

   return Scaffold(
      body: CarouselSlider(
        items: [
          Container(
            margin: EdgeInsets.all(2),
            child: StaggeredGridView.countBuilder(
                // physics: NeverScrollableScrollPhysics(), // it can use scollable if upper widget dont cause any issue
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          color: Colors.amber,
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        )
                        // FadeInImage.memoryNetwork(
                        //   // placeholder: kTransparentImage,
                        //   image: imageList[index],
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count(1, index % 3 == 0 ? 2 : 1);
                }),
          ),
          Container(
            color: Colors.deepPurple,
          ),
          Container(
            color: Colors.deepOrange,
          ),
        ],
        options: CarouselOptions(aspectRatio: 1, viewportFraction: 1),
      ),
    );
  }
}
