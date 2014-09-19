<!---/**
* This is the bootstrapper Application.cfc for ColdBox Applications.
* It uses inheritance on the CFC, so if you do not want inheritance
* then use the Application_noinheritance.cfc instead.
* @output false
**/--->
<cfcomponent extends="coldbox.system.Coldbox" output="false">
<cfscript>

		// APPLICATION INIT ERROR MESSAGE PROPERTY
		APP_INIT_ERROR = "An error has occurred in initializing your application. Please contact your Support Team representative.";
		// APPLICATION NAME
		APP_NAME = "Apollo21"; //getApplicationName(CGI);
		// APPLICATION CLIENT DATASOURCE
		APP_CLIENT_DATASOURCE = "apollo21DB";// getApplicationDatasource(CGI);
		/*** Application Properties ***/
		this.name = APP_NAME;
		// where should we store client vars, if enabled?
//		this.clientStorage = APP_CLIENT_DATASOURCE;
		// define whether client variables are enabled
		this.clientManagement = true;
		// define whether session variables are enabled
		this.sessionManagement = true;
		// how long the session variables persist?
		this.sessionTimeout = createTimeSpan(0,5,0,0);
		// define whether to set cookies on the browser?
		this.setClientCookies = false;
		//should cookies be domain specific
		//i.e. *.domain.com or www.domain.com
		this.setDomainCookies = false;
		// define where cflogin information should persist
		this.loginStorage = "session";
		// should we try to block cross-site scripting?
		this.scriptProtect = true;
		// should we secure our JSON calls?
		this.secureJSON = false;
		// use a prefix in front of JSON strings?
		this.secureJSONPrefix = "";


		// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
		COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
		// The web server mapping to this application. Used for remote purposes or static purposes
		COLDBOX_APP_MAPPING = "";
		// COLDBOX PROPERTIES
		COLDBOX_CONFIG_FILE = "";
		// COLDBOX APPLICATION KEY OVERRIDE
		COLDBOX_APP_KEY = "";

		// Module Mappings
		this.mappings["/explorer"] = COLDBOX_APP_ROOT_PATH & "modules/explorer";
		this.mappings["/apollo21"]       = COLDBOX_APP_ROOT_PATH & "modules/apollo21";

		// Set up ORM - Note: hibernate version = 3.5.2-Final
		this.ormenabled = true;
		this.ormsettings = {
			datasource = APP_CLIENT_DATASOURCE,
			// FILL OUT: IF YOU WANT CHANGE SECONDARY CACHE, PLEASE UPDATE HERE
			secondarycacheenabled = false,
			cacheprovider = "ehCache",
			cfclocation = ["/apollo21/model"],
			flushAtRequestEnd 	= false,
			autoManageSession	= false,
			logsql = true,
			eventHandling = true
			//eventHandler = "apollo21.model.EventHandler"
		};

		/**
		* Set app name in an MSOC environment
		* @output true
		*/

		private string function getApplicationName(required cgiScope)
		{

			/*try
			{
				// We need to append some string to the client name so it is different from the Current-Gen application name.  i.e. Current-Gen="cahSouthernCross", Next-Gen="cahSouthernCrossX"
				return server.platformService.getClientName(arguments.cgiScope.HTTP_HOST) & "X";
			}
			catch(any e)
			{
				// TODO: Add error log entry
				writeOutput("<h1>" & APP_INIT_ERROR & "</h1>");
				abort;
			}*/
		}

		/**
		* Set datasource in an MSOC environment
		* @output true
		*/
		private string function getApplicationDatasource(required cgiScope)
		{

			/*try
			{
				// TODO: Add error log entry
				return server.platformService.getDatasource(arguments.cgiScope.HTTP_HOST);
			}
			catch(any e)
			{
				writeOutput("<h1>" & APP_INIT_ERROR & "</h1>");
				abort;
			}*/
		}

		/**
		* Function that handles all requests and returns a boolean.
		* @output true
		*/
		boolean function onRequestStart(required targetPage) {

			initClientVars();

			// Reinitialize ORM
			if (structKeyExists(url, "ormreinit"))
			{
					ormReload();
			}
			// End the current session scope so a new one can start
			if (structKeyExists(url, "killSession"))
			{
				killSession();
			}
			// Clear the platformService Cache
			if (structKeyExists(url, "clearclient"))
			{
				structClear(client);
			}
			// Restart application
			if (structKeyExists(url, "restartapp"))
			{
				ApplicationStop();
			}
			// Process A ColdBox Request Only
			if( findNoCase('index.cfm', listLast(arguments.targetPage, '/')) ){
				// Reload Checks
				reloadChecks();
				// Process Request
				processColdBoxRequest();
			}

			// WHATEVER YOU WANT BELOW

			return true;
		}

		public void function onSessionStart(){
			// The sysID inside this struct is specific to the request URL when the session starts
			// special conditions will have to be written for cases like rockbottom and captainds.
			// Stored in cbStorage so that it will be retrievable by SessionStorage plugin
			//session.cbStorage.platformSettings = server.platformService.getRecord(cgi.HTTP_HOST);
		}

		/*public void function onSessionEnd(struct sessionScope, struct appScope){
			//writeDump(var="When does a session end?");
			//writeDump(var=arguments,abort="true");
		}*/


	//}
	</cfscript>

	<cffunction name="killSession" access="private" returntype="void" hint="Invalidates the current session by expiring the session cookies.">
		<cfset session.setMaxInactiveInterval(javaCast( "long", 1 )) />

		<cfloop index="local.cookieName" list="cfid,cftoken,cfmagic">
			<!--- Expire this session cookie. --->
			<cfcookie name="#local.cookieName#" value="" expires="now" />
		</cfloop>

	</cffunction>

	<cffunction name="initClientVars" access="private" returntype="void">

		<cfif !structKeyExists(cookie, "cfid")>
			<cfcookie name="cfid" value="#client.cfid#">
			<cfcookie name="cftoken" value="#client.cftoken#">
		</cfif>

	</cffunction>

<!---	<cffunction name="onError" access="public" returntype="void">
		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" required="true" />
<cfdump var="#arguments#">
		<!--- prep for log error --->
		<cfset todayDateTime = Now()>
		<cfset logDate = DateFormat(todayDateTime, "mm/dd/yyyy")>
		<cfset logTime = TimeFormat(todayDateTime, "HH:mm:ss")>

		<!--- remove html for log error--->
		<cfset causeDetailCleaned = REReplace(Arguments.Exception.cause.detail,'<[^>]*>','','all')>

		<!---TODO: Make variable for file log location--->
<!---		<cffile action="append"
		    file="D:/WebRoot/coldbox/cah_logs/cahlog.log"
		    output="""ERROR"",""CAHAPP"",""#logDate#"",""#logTime#"",""#Arguments.Exception.detail# #causeDetailCleaned#""">
--->
		<!---<cfdump VAR="#exception#">--->

		<!--- display generic error template --->
		<cfinclude template="/includes/templates/errorTemplate.cfm" />


	</cffunction>--->

</cfcomponent>
