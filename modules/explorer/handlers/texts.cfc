/**
* Manage texts
* It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
*/
component{

	// DI Virtual Entity Service
	property name="textService" inject="TextService@apollo21";

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
		// Get all texts
		rc.texts = textService.getAll();

		// RESTful Switch
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.texts,type=rc.format);
				break;
			}
			// HTML
			default:{
				event.setView("texts/index");
			}
		}
	}

	/**
	* New Form
	*/
	function new(event,rc,prc){

		// get new text
		rc.text = textService.new();

		event.setView("texts/new");
	}

	/**
	* Edit Form
	*/
	function edit(event,rc,prc){

		// get persisted text
		rc.text = textService.get( rc.textID );

		event.setView("texts/edit");
	}

	/**
	* View text mostly used for RESTful services only.
	*/
	function show(event,rc,prc){

		// Get requested entity by id
		rc.text = textService.get( rc.textID );

		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.text,type=rc.format);
				break;
			}
			// HTML
			default:{
				setNextEvent('explorer.texts');
			}
		}
	}

	/**
	* Save and Update
	*/
	function save(event,rc,prc){

		// get text to persist or update and populate it with incoming form
		rc.text = populateModel(model=textService.get( rc.textID ),exclude="textID");

		// Do your validations here

		// Save it
		textService.save( rc.text );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.text,type=rc.format,location="/texts/show/#rc.text.gettextID()#");
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").info("text Created!");
				// Redirect to listing
				setNextEvent('explorer.texts');
			}
		}
	}

	/**
	* Delete
	*/
	function delete(event,rc,prc){

		// Delete record by ID
		var removed = textService.deleteById( rc.textID );

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
				getplugin("MessageBox").warn("text Poofed!");
				// Redirect to listing
				setNextEvent('texts');
			}
		}
	}

}