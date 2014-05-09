/*
	I am a handler (also commonly known as a controller)!
	All web requests are piped through me based on an event
	Events are defined through the URL in the web browser
	    ex: localhost:8081/explorer/demo/playground
						     |       |     |
					         |       |     | The "function". Also synonomous with an "action"
				 	         |       |The "handler" (or "controller")
					         |The module (modules are just logical division of code to promote good modularity and flexibility)

		The whole URL together makes up our event. Sometimes a single action might call another action. In that case our event would execute multiple actions
*/
component {

	function playGround(event,rc,prc)
	{
		// ColdBox GUI's by convention!
		// The framework knows we are in the "demo" handler. Therefore by convention it is going to look for a "demo" folder in the "views" folder
		// We also haven't told it the specific name of our view file, therefore ColdBox is going to look for a view that matches our function name
		// Ex: our action= /explorer/handler/demo/playGround
		//    corresponding view= /explorer/views/demo/playGround

		// We can also set an explicit view file if we want (as seen below)
			//event.setView("demo/playground");
			//event.setView("playgound");
	}

	function demo(event,rc,prc)
	{
		event.setView("demo/demo");
		//event.setView("demo");
	}

	function video()
	{

	}
}