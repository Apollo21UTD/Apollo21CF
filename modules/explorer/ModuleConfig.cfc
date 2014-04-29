/**
* CONFIG ModuleConfig.cfc
* Configure the genesis module used for all of the standard models
* @output false
*/
component {

	// Module Properties
	this.title 				= "explorer";
	this.author 			= "ben knox";
	this.webURL 			= "";
	this.description 		= "Contains all of the standard UI Components";
	this.version			= "0.0.1";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "explorer";

	/**
	* Configure genesis Module
	*
	* @returnType void
	*/
	function configure(){

		// Layout Settings
		//layoutSettings = { defaultLayout = "Main.cfm" };

		// Module Settings
		settings = {
		};

		// SES Routes
		routes = [
			{pattern="/", handler="main", action="index" },
			{pattern="/:handler/:action?"}
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
