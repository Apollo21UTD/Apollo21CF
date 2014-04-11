<cfoutput>

<cfscript>
	/*
		Welcome to the demo!
		Below you will see some examples of common and useful code. Feel free to play with it and explor
	*/

	/************* dumps (not the smelly kind) ***************/
	// ColdFusion provides us with a cool function called a "dump".
	// It allows us to output simple or complex data at any point of the request execution (even if we aren't in a view file)
	// This is really handy for debugging, and visualization.
	// http://help.adobe.com/en_US/ColdFusion/9.0/CFMLRef/WS5A998FA0-0173-4be8-9548-680E8F40A5F2.html

	// Since we are in a view file, a dump with these attributes will display with no problem
	writeDump(var="This is just a simple string being dumped", label="dump example");

	// The "abort" attribute is going to abort the execution of any code after this statement.
	// THis is very useful when dumping data that isn't in a view file
	//writeDump(var="Nothing will execute after me" ,abort=true);

	// feel free to create a dump on any variale I have create, then just reload your web browser to see it

	/************* Variable assignment ****************/
	// ColdFusion has no typing. You just assign any datatype to any variable you want
	someStr = "Hello World";
	someNum = 12;
	someDouble = 26.2;
	// This is going to work with complex data types too, as we will see below


	/************* Strings **************/
	// Strings are essentially the same as java. I am pretty sure once you assign a variable as a string,
	// its actually becomes a java String class object, and you can execute String methods on it

	// The main difference to remember is string concatination syntax
	//     Normal java is like this: str3 = str1 + str2;
	//     CF is like this:
	str1 = "Hello ";
	str2 = "World!";
	str3 = str1 & str2;

	// Addition still uses the "+" sign
	int1 = 1;
	int2 = 2;
	int3 = int1 + int2;


	/************* Arrays *****************/
	// Create a new empty array. CF arrays are really java arrayLists, so they grow as needed!
	// https://wikidocs.adobe.com/wiki/display/coldfusionen/Array+functions
	myArray = arrayNew();
	// Cool shorthand to create a new empty array
	myOtherArray = [];
	// Create a pre-filled array
	myFilledArray = ["Hello", "World", "!"];
	writeDump(var=myFilledArray, label="myFilledArray");
	// !!!IMPORTANT!!! Arrays in CF start at index 1, not zero. Ie: myFilledArray[1] -> "Hello"


	/************* For Loops ***************/
	// For loop syntax is really similar to java... but with a couple critical difference:
	//    Comparison operators are different: http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WSc3ff6d0ea77859461172e0811cbec09d55-7ffc.html#WSc3ff6d0ea77859461172e0811cbec09d55-7ff9
	//    Again, array indexes start at 1
	str = "";
	for (var i=1; i lte arrayLen(myFilledArray); i++)
	{
		str &= myFilledArray[i] & " ";
	}
	</cfscript>
		<p>Output from for loop over myFilledArray: #str#</p>
	<cfscript>


	/************ Lists **************/
	// Lists are a lot like arrays, but they can only contain simple data types (no objects)
	// They are comma delimited by default, but you can speficy a custom delimeiter with every list function
	// https://wikidocs.adobe.com/wiki/display/coldfusionen/List+functions

	// Create a new comma delimited list
	myList = "Hello,World,list,style,!";
	writeDump(var=myList, label="myList");

	// Convert a list to an array
	// https://wikidocs.adobe.com/wiki/display/coldfusionen/ListToArray
	myNewArray = listToArray(myList);

	// We don't need a list to be an array though. We can handle it similarly to an array
	// We can get an index of any list with this function: https://wikidocs.adobe.com/wiki/display/coldfusionen/ListToArray
	listIndex1 = listGetAt(myList, 1);

	listString = "";
	for (i = 1; i lte listLen(myList); i++)
	{
		listString &= listGetAt(myList, i) & " ";
	}
	</cfscript>
		<p>Output from for loop over myList: #listString#</p>
	<cfscript>


	/*********** Structures ************/
	// Structures are great. They are essentially just a key/value pairing
	// and they are very frequently used
	// https://wikidocs.adobe.com/wiki/display/coldfusionen/Structure+functions

	// Create an empty struct
	myStruct = structNew();

	// Create an empty struct shorthand
	myStruc2 = {};

	// Create a struct with pre-fulled data. Notice all the different data types in the struct, its great!
	myFilledStruct = {
		someString = "Hello World",
		// Notice the comma after each element
		someNum = 142,
		someArray = [12, 3, 4, 3],
		anotherStruct = {
			ben = "knox",
			blue = "cheese"
			// notice no comma after the last element
		}
		// notice no comma after the last element
	};

	// Now lets look at the thing!
	writeDump(var=myFilledStruct, label="myFilledStruct");

	// Access a single element by its key
	total = 12 + myFilledStruct.someNum;
	total2 = 12 + myFilledStruct["someNum"];
	</cfscript>
	<p> Struct value for key: someString <br> #myFilledStruct.someString# </p>
	<cfscript>

	writeDump(var=myFilledStruct.anotherStruct, label="myFilledStruct.anotherStrcut");

	// We can even access a struct key based on a value inside of a variable
	structIndex = "anotherStruct";
	myFirstName = "ben";
	myLastName = myFilledStruct[structIndex][myFirstName];

	/************* Advanced ***************/

	// If you want to get really funky with it, you can create an array of structures to represent a person
	// Struct
	person1 = {
		firstName = "ben",
		lastName = "Knox",
		email = "bxk112430@utdallas.edu",
		height = "6'9"
	};
	person2 = {
		firstName = "Clay",
		lastName = "McAnally",
		email = "clay@utdallas.edu",
		height = "short"
	};
	person3 = {
		firstName = "Stephan",
		lastName = "Weldon",
		email = "stephan@utdallas.edu",
		height = "short"
	};
	person4 = {
		firstName = "Brian",
		lastName = "Duckplant",
		email = "duckplant@utdallas.edu",
		height = "less short"
	};

	personArray = [person2, person3];
	arrayAppend(personArray, person4);
	arrayPrepend(personArray, person1);

	writeDump(var=personArray, label="personArray");

	// So now I have a business logic need to display every person's email address
	for (i=1; i lte arrayLen(personArray); i++)
	{
		writeDump(var=personArray[i].email, label=personArray[i].firstName);
	}

</cfscript>
</cfoutput>