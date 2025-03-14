import 'package:flutter/material.dart'; 
//https://www.geeksforgeeks.org/flutter-scrollable-text/

void main() { 
runApp(MaterialApp( 
	home: Scaffold( 
		
	// adding App Bar 
	appBar: AppBar( 
		backgroundColor: Color.fromRGBO(15, 157, 88, 1), 
		title: Text( 
		"GeeksForGeeks", 
		style: TextStyle( 
			color: Colors.white, 
		), 
		), 
	), 
	body: MyApp(), 
	), 
)); 
} 

class MyApp extends StatelessWidget { 
@override 
Widget build(BuildContext context) { 
	return Center( 
	child: Container( 
		
		// adding margin 
		margin: const EdgeInsets.all(15.0), 
		
		// adding padding 
		padding: const EdgeInsets.all(3.0), 
		
		// height should be fixed for vertical scrolling 
		height: 80.0, 
		decoration: BoxDecoration( 
			
		// adding borders around the widget 
		border: Border.all( 
			color: Colors.blueAccent, 
			width: 5.0, 
		), 
		), 
		// SingleChildScrollView should be 
		// wrapped in an Expanded Widget 
		child: Expanded( 
			
		// SingleChildScrollView contains a 
		// single child which is scrollable 
		child: SingleChildScrollView( 
			
			// for Vertical scrolling 
			scrollDirection: Axis.vertical, 
			child: Text( 
			"GeeksForGeeks is a good platform to learn programming."
				" It is an educational website.", 
			style: TextStyle( 
				color: Colors.green, 
				fontWeight: FontWeight.bold, 
				fontSize: 20.0, 
				letterSpacing: 3, 
				wordSpacing: 3, 
			), 
			), 
		), 
		), 
	), 
	); 
} 
} 
