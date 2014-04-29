/**
* Manage videos
* It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
*/
component{

	// DI Virtual Entity Service
	property name="videoService" inject="VideoService@apollo21";

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
		// Get all videos
		rc.videos = videoService.getAll();

		// RESTful Switch
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.videos,type=rc.format);
				break;
			}
			// HTML
			default:{
				event.setView("videos/index");
			}
		}
	}

	/**
	* New Form
	*/
	function new(event,rc,prc){

		// get new video
		rc.video = videoService.new();

		event.setView("videos/new");
	}

	/**
	* Edit Form
	*/
	function edit(event,rc,prc){

		// get persisted video
		rc.video = videoService.get( rc.videoID );

		event.setView("videos/edit");
	}

	/**
	* View video mostly used for RESTful services only.
	*/
	function show(event,rc,prc){

		// Get requested entity by id
		rc.video = videoService.get( rc.videoID );

		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.video,type=rc.format);
				break;
			}
			// HTML
			default:{
				setNextEvent('explorer.videos');
			}
		}
	}

	/**
	* Save and Update
	*/
	function save(event,rc,prc){

		// get video to persist or update and populate it with incoming form
		rc.video = populateModel(model=videoService.get( rc.videoID ),exclude="videoID");

		// Do your validations here

		// Save it
		videoService.save( rc.video );

		// RESTful Handler
		switch(rc.format){
			// xml,json,jsont,wddx are by default.  Add your own or remove
			case "xml" : case "json" : case "jsont" : case "wddx" :{
				event.renderData(data=rc.video,type=rc.format,location="/videos/show/#rc.video.getvideoID()#");
				break;
			}
			// HTML
			default:{
				// Show a nice messagebox
				getplugin("MessageBox").info("video Created!");
				// Redirect to listing
				setNextEvent('explorer.videos');
			}
		}
	}

	/**
	* Delete
	*/
	function delete(event,rc,prc){

		// Delete record by ID
		var removed = videoService.deleteById( rc.videoID );

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
				getplugin("MessageBox").warn("video Poofed!");
				// Redirect to listing
				setNextEvent('videos');
			}
		}
	}

}