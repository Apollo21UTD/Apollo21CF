/**
* CONFIG ModuleConfig.cfc
* Configure the genesis module used for all of the standard models
* @output false
*/
component {

	// Module Properties
	this.title 				= "apollo21";
	this.author 			= "ben knox";
	this.webURL 			= "";
	this.description 		= "Contains all of the standard models and ORM entities";
	this.version			= "0.0.1";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "apollo21";

	/**
	* Configure genesis Module
	*
	* @returnType void
	*/
	function configure(){

		// Module Settings
		settings = {
		};

		// SES Routes
		routes = [
			{pattern="/", handler="main", action="index" }
		];

		// Interceptors
		interceptors = [
		];

		// Interceptor Settings
		interceptorSettings = {
		};

		// Map Bindings - Services should always be called by their mapped names to reduce possible refactoring efforts
		// Security


	}

	/**
	* Fired when the module is registered and activated.
	*/
	void function onLoad(){

		// Load all resources for the application when the core module loads.

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	void function onUnload(){
	}
}
