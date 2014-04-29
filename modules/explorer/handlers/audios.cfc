/**
* Manage audios
* It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
*/
component{

	// DI Virtual Entity Service
	property name="audioService" inject="AudioService@apollo21";

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
		// Get all audios
		rc.audios = audioService.getAll();

		// RESTful Switch
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.audios,type=rc.format);
				break;
			}
			// HTML
			default:{
				event.setView("audios/index");
			}
		}
	}

	/**
	* New Form
	*/
	function new(event,rc,prc){

		// get new audio
		rc.audio = audioService.new();

		event.setView("audios/new");
	}

	/**
	* Edit Form
	*/
	function edit(event,rc,prc){

		// get persisted audio
		rc.audio = audioService.get( rc.audioID );

		event.setView("audios/edit");
	}

	/**
	* View audio mostly used for RESTful services only.
	*/
	function show(event,rc,prc){

		// Get requested entity by id
		rc.audio = audioService.get( rc.audioID );

		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.audio,type=rc.format);
				break;
			}
			// HTML
			default:{
				setNextEvent('explorer.audios');
			}
		}
	}

	/**
	* Save and Update
	*/
	function save(event,rc,prc){

		// get audio to persist or update and populate it with incoming form
		rc.audio = populateModel(model=audioService.get( rc.audioID ),exclude="audioID");

		// Do your validations here

		// Save it
		audioService.save( rc.audio );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.audio,type=rc.format,location="/audios/show/#rc.audio.getaudioID()#");
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").info("audio Created!");
				// Redirect to listing
				setNextEvent('explorer.audios');
			}
		}
	}

	/**
	* Delete
	*/
	function delete(event,rc,prc){

		// Delete record by ID
		var removed = audioService.deleteById( rc.audioID );

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
				getplugin("MessageBox").warn("audio Poofed!");
				// Redirect to listing
				setNextEvent('audios');
			}
		}
	}

}