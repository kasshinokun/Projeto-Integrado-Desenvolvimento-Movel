import 'package:flutter/material.dart'; 

void main() { 
runApp(MaterialApp(home: RunMyApp(),debugShowCheckedModeBanner: false, 
	theme: ThemeData(primarySwatch: Colors.green),)); 
} 

class RunMyApp extends StatelessWidget { 
RunMyApp({super.key}); 
	
@override 
Widget build(BuildContext context) { 
	return Scaffold( 
		appBar: AppBar( 
		title: Text('Home Page'), 
		), 
		body: Center( 
		child: 
			
			ElevatedButton( 
				onPressed: () { 
					
					Navigator.push( 
						context, 
						MaterialPageRoute( 
							builder: (context) => 
								NextPage())); 
				}, 
				child: Text('Goto Next Page')),	 
		), 
		
	); 
} 
} 

class NextPage extends StatelessWidget { 
	
const NextPage({super.key}); 

@override 
Widget build(BuildContext context) { 
	return Scaffold( 
	appBar: AppBar(title: Text('Next Page'),), 
	body: Center( 
		child: Text('GeeksForGeeks'), 
	), 
	); 
} 
}
