/**
* Manage events
* It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
*/
component{

	// DI Virtual Entity Service
	property name="eventService" inject="EventService@apollo21";
	property name="photoService" inject="PhotoService@apollo21";

	// HTTP Method Security
	this.allowedMethods = {
		index = "GET", new = "GET", edit = "GET", delete = "POST,DELETE", save = "POST,PUT"
	};

	/**
	* preHandler()
	*/
	function preHandler(event,rc,prc){
		event.paramValue("format","html");
	}

	/**
	* Listing
	*/
	function index(event,rc,prc){
		// Get all events
		rc.events = eventService.getAll();

		// RESTful Switch
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.events,type=rc.format);
				break;
			}
			// HTML
			default:{
				event.setView("events/index");
			}
		}
	}

	/**
	* New Form
	*/
	function new(event,rc,prc){

		// get new event
		rc.event = eventService.new();

		event.setView("events/new");
	}

	/**
	* Edit Form
	*/
	function edit(event,rc,prc){

		// get persisted event
		rc.event = eventService.get( rc.eventID );

		event.setView("events/edit");
	}

	/**
	* View event mostly used for RESTful services only.
	*/
	function show(event,rc,prc){

		// Get requested entity by id
		rc.event = eventService.get( rc.eventID );

		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.event,type=rc.format);
				break;
			}
			// HTML
			default:{
				setNextEvent('explorer.events');
			}
		}
	}

	/**
	* Save and Update
	*/
	function save(event,rc,prc){

		// get event to persist or update and populate it with incoming form
		rc.event = populateModel(model=eventService.get( rc.eventID ),exclude="eventID");

		// Do your validations here

		// Save it
		eventService.save( rc.event );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.event,type=rc.format,location="/events/show/#rc.event.geteventID()#");
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").info("event Created!");
				// Redirect to listing
				setNextEvent('explorer.events');
			}
		}
	}

	/**
	* Delete
	*/
	function delete(event,rc,prc){

		// Delete record by ID
		var removed = eventService.deleteById( rc.eventID );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				var restData = {deleted=removed};
				event.renderData(data=restData,type=rc.format);
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").warn("event Poofed!");
				// Redirect to listing
				setNextEvent('events');
			}
		}
	}

	/**
	* THe name of the function and the first argument are completely unrelated
	*/
	function eventDemo(event,rc,prc)
	{
		// Hardcoded for demo
		rc.missionNum = 14;

		var c = eventService.newCriteria();
		c.isEQ("missionID", javaCast( "int", rc.missionNum) )
			.order("metStart", "asc");
		prc.events = c.list();

	}

	function exploreEvent(event,rc,prc)
	{
		prc.event = eventService.get(id=rc.eventID);

		var c = photoService.newCriteria();
		c.between("met", javaCast("int", prc.event.getMetStart()), javaCast("int", prc.event.getMetFinish()));
		prc.photos = c.list();
		/*writeDump(prc.event.getMetStart());
		writeDump(prc.event.getMetFinish());
		writeDump(var=prc.photos ,abort=true); // benswritedump*/
	}

}