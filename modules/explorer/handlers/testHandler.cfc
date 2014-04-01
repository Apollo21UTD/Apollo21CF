component {

	function index(event,rc,prc)
	{
		prc.helloWorldMessage = "Hello World";

		event.setView("testHandler/testView");
	}

	function testView(event,rc,prc)
	{
		prc.helloWorldMessage = "Hello World";
	}
}