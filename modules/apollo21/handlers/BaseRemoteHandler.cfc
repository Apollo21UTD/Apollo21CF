/**

*
* Base remote handler for the platform. Should be extended by remote handlers within modules for standard marshaling of data and error handling.
*/
component {

	// Dependency Injection
	property name="clientStorage" inject="coldbox:plugin:ClientStorage";
	property name="antiSamy" 	  inject="coldbox:plugin:AntiSamy";

	/**
	* preHandler action builds the standard results structure
	*/
	public void function preHandler(event, rc, prc)
	{
		// Set up the standard results structure
		prc.results = {
			status = 200,
			data = {},
			message = "OK",
			detail = ""
		};

		// Sanitize the entire request collection
		for(key in rc){
		  if( isSimpleValue(rc[key]) ){
		    rc[key] = antiSamy.HtmlSanitizer(rc[key]);
		  }
		}

		// Validate the client token
		if ( !structKeyExists(rc, "pt") OR ( structKeyExists(rc, "pt") AND URLDecode(rc.pt) NEQ clientStorage.getVar("CFTOKEN") ) )
		{
			throw(message="Invalid Request",
				  detail="You do not have authorization to access this gateway.  Please contact the system administrator for further information.",
				  type="candidate.applicationProcess.nearbyLocations.InvalidRequest");
		}

	}

	/**
	* onError action populates the results structure with error info and hands it off to the logger and the renderer for marshalling according to the requested format
	*/
	public any function onError(event, faultAction, exception, eventArguments)
	{
		// Populate the results structure with error info
		prc.results.status = 	500; // generic error
		prc.results.message = 	arguments.exception.message;
		prc.results.detail = 	arguments.exception.detail;

		// Populate a data structure with internal error info to be handed off to the logger
		var logErrorData = {
			expection = arguments.exception,
			faultAction = arguments.faultAction
		};

		// log error here by announcing an asynchronous interception point
		announceInterception("logError", logErrorData, true);

		// hand off to renderer for data marshalling
		//writeDump(var=arguments.exception, abort=true);
		renderResults(event, prc.results);
	}

	/**
	* postHandler action hands off the results to the renderer for marshalling according to the requested format
	*/
	public any function postHandler(event, rc, prc)
	{
		renderResults(event, prc.results);
	}

/*************************************** Private Methods **********************************************/

	/**
	* Params the properties expected by the given constraints and then validates the model
	*/
	private void function validateRequest(event, rc, required struct constraints, struct params={})
	{
		// Param each of the constraints because they are not guaranteed to exist in a RESTful call
		for ( property in constraints )
		{
			event.paramValue(property, structKeyExists(params, property) ? params[property] : "");
		}

		// Validate the data
		var validationResults = validateModel(target=rc, constraints=constraints);

		// Throw the validation error to be caught by BaseRemoteHandler.onError()
		if ( validationResults.hasErrors() )
		{
			throw(message="Invalid Request",
				  detail=arrayToList(validationResults.getAllErrors()),
				  type=event.getEventName() & ".InvalidRequest");
		}
	}

	/**
	* Determines how to format the data (marshalling) and then renders it
	*/
	private any function renderResults(event, results)
	{
		if( event.isProxyRequest() ){
			return results;
		}

		var format = event.getValue("format", "json");

		switch(format){
			case "xml": {
				// render out an xml packet according to specs status codes and messages
				event.renderData(data=results, type="xml", statusCode=results.status, statusMessage=results.message);
				break;
			}
			default:{
				// render out a json packet according to specs status codes and messages
				event.renderData(data=results, type="json", statusCode=results.status, statusMessage=results.message);
			}
		}
	}

}
