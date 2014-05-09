<!---
	This import handler is not user friendly. But you will find that it is well commented, and provides a good groundwork for some automated import functions
 --->
<cfcomponent>

	<cffunction name="init">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfscript>

		</cfscript>
	</cffunction>


	<!---
		Parse through an "events.txt" file and create corresponding records in the db
		Note: You need to run the "metFinish()" to write the correct metFinish value to each record
	 --->
	<cffunction name="importEvents">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfscript>
			// These values could be aquired from an HTML form
			rc.filePath = "/Users/benknox/Downloads/a15/lists/events.txt";
			rc.missionNum = 15;

			//Create a query object for later
			var q = new Query();
			q.setDatasource("apollo21DB");

			/*Reading a file can be done natively in CF, but I am using actual java objects because its a little bit more efficient*/
			//Create java FileReader
			fileReader = createObject("java", "java.io.FileReader").init(rc.filePath);
			//Create java BufferedReader
			reader = createObject("java", "java.io.BufferedReader").init(fileReader);

			/*CFScript doesn't let us do assignments in a condition statement... so I have to get a little funky here... just read it through and it'll make sense*/
			var line = reader.readLine();
			if ( !isNull(line) )
			{
				do
				{
					/*Parse the line, then we'll create our SQL string*/
					// Note: the deliminator is two spaces, and by default listToArray will jump to the next token if it sees two delims in a row
					var tokens = listToArray(list=line, delimiters="  ", multiCharacterDelimiter=true);
					// Convert MET to seconds. Met = hhh:mm:ss
					var met = listToArray(list=trim(tokens[2]), delimiters=":");
					// Hours to seconds
					metInSeconds = met[1] * 3600;
					// Minutes to seconds
					metInSeconds += met[2] * 60;
					metInSeconds += met[3];

					/*Create the SQL string, and insert the data*/
					var sql = "INSERT INTO events
								(
								`metStart`,
								`description`,
								`missionID`,
								`createdDate`)
								VALUES
								(
								" & metInSeconds & ",
								'" & trim(tokens[1]) & "',
								(select missionID from missions where missionNum = " & rc.missionNum & "),
								now())";
					q.setSQL(sql);
					q.execute();

					//Get the next line... rinse and repeat
					line = reader.readLine();
				}
				while ( !isNull(line) );
			}

			event.setView("import/success");
		</cfscript>
	</cffunction>

	<!---
		Parse through a photo list and create corresponding records in the db

		To calculate the offset for the photo we would have to have a recursive function to
		put the sql statements on a stack until we parsed the config file far enough to find another
		MET. Then once we calculate the difference between the first and second MET, we can recurse
		back down the stack, set the offset, and execute the query... but who has time to write
		recursive functions? A clever SQL hack after the import will get the job done. See "cleverSQLHack()" function below
	 --->
	<cffunction name="importPhotos">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfscript>
			// I essentially just changed this file path for each individual photo.txt
			// Ideally it could be written to process a batch of them all at once
			rc.filePath = "/Users/benknox/Downloads/a15/lists/cdrphotos.txt";
			rc.missionNum = 15;
			rc.photoType = "cdr";

			//Create a query object for later
			var q = new Query();
			q.setDatasource("apollo21DB");

			/*Reading a file can be done natively in CF, but I am using actual java objects because its a little bit more efficient*/
			//Create java FileReader
			fileReader = createObject("java", "java.io.FileReader").init(rc.filePath);
			//Create java BufferedReader
			reader = createObject("java", "java.io.BufferedReader").init(fileReader);

			/*CFScript doesn't let us do assignments in a condition statement... so I have to get a little funky here... just read it through and it'll make sense*/
			var line = reader.readLine();
			if ( !isNull(line) )
			{
				// Keep track of the previous met
				var previousMET = "";
				do
				{
					/*Parse the line, then we'll create our SQL string*/
					var tokens = listToArray(list=line, delimiters=" ");

					// Convert the MET if it exists. If it doesn't, then use the previousMET
					if ( arrayIsDefined(tokens, 2) )
					{
						// Convert MET to seconds. Met = hhh:mm:ss
						var met = listToArray(list=trim(tokens[2]), delimiters=":");
						// Hours to seconds
						var metInSeconds = met[1] * 3600;
						// Minutes to seconds
						metInSeconds += met[2] * 60;
						metInSeconds += met[3];

						// Its not really previous yet... but it will be soon
						previousMET = metInSeconds;
					}
					else
					{
						var metInSeconds = previousMET;
					}

					/*Create the SQL string, and insert the data*/
					var sql = "INSERT INTO photos
								(
								`missionID`,
								`description`,
								`photoType`,
								`filePath`,
								`fileSize`,
								`url`,
								`met`,
								`offset`,
								`createdDate`)
								VALUES
								(
								'" & rc.missionNum & "',
								'" & trim(tokens[1]) & "',
								'" & rc.photoType & "',
								'modules/apollo21/includes/photo/" & rc.missionNum & "/" & trim(tokens[1]) & "',
								0,
								'',
								" & metInSeconds & ",
								0,
								now())";

					q.setSQL(sql);
					q.execute();

					//Get the next line... rinse and repeat
					line = reader.readLine();
				}
				while ( !isNull(line) );
			}

			event.setView("import/success");

		</cfscript>
	</cffunction>

	<!---
		This method is going to give the very last set of photos a negative offset, because there
		aren't any MET's after the last one, so account for the presence of a negative in the
		business logic
	 --->
	<cffunction name="cleverSQLHack">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset rc.photoType = "cdr">
		<cfset rc.missionNum = 15>
		<!---
			Note the "order by met desc". That means we will be looping from largest to smallest
		 --->
		<cfquery name="q" datasource="apollo21DB">
			SELECT * FROM
			photos JOIN (
			  SELECT met, MAX(photoID) photoID
			  FROM photos
			  GROUP BY met
			  ) some_table USING (met, photoID)
			WHERE photoType = '#rc.photoType#'
			AND missionID = '#rc.missionNum#'
			ORDER BY met desc;
		</cfquery>

		<cfset var previousMET = 0>

		<!--- cfoutput acts like a loop when you feed it a query result --->
		<cfoutput query="q">
			<!---
				Set the offset equal to the difference of the current MET minus the previous
				MET (remember we are moving backwards). Do this for every record that has the
				same MET
			 --->
			<cfquery name="updater" datasource="apollo21DB">
				UPDATE photos
				SET offset = #previousMET# - #met#
				WHERE met = #met#
				AND missionID = '#rc.missionNum#'
				AND photoType = '#rc.photoType#'
			</cfquery>

			<cfset previousMET = #met#>

		</cfoutput>

		<cfset event.setView("import/success")>

	</cffunction>

	<cffunction name="metFinish">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset rc.missionNum = 15>

		<cfquery name="q" datasource="apollo21DB">
			SELECT * FROM events
			WHERE missionID = #rc.missionNum#
			ORDER BY metStart desc
		</cfquery>

		<cfset previousMET = 0>
		<cfoutput query="q">
			<cfquery name="p" datasource="apollo21DB">
				UPDATE events
				SET metFinish = #previousMet#
				WHERE eventID = #eventID#
				AND missionID = #rc.missionNum#
			</cfquery>

			<cfset previousMET = #metStart#>
		</cfoutput>

		<cfset event.setView("import/success")>
	</cffunction>


	<cffunction name="importVideos">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfscript>
			// I essentially just changed this file path for each individual photo.txt
			// Ideally it could be written to process a batch of them all at once
			rc.filePath = "/Users/benknox/Downloads/a15/lists/video.txt";
			rc.missionNum = 15;

			//Create a query object for later
			var q = new Query();
			q.setDatasource("apollo21DB");

			/*Reading a file can be done natively in CF, but I am using actual java objects because its a little bit more efficient*/
			//Create java FileReader
			fileReader = createObject("java", "java.io.FileReader").init(rc.filePath);
			//Create java BufferedReader
			reader = createObject("java", "java.io.BufferedReader").init(fileReader);

			/*CFScript doesn't let us do assignments in a condition statement... so I have to get a little funky here... just read it through and it'll make sense*/
			var line = reader.readLine();
			if ( !isNull(line) )
			{
				// Keep track of the previous met
				var previousMET = "";
				do
				{
					/*Parse the line, then we'll create our SQL string*/
					var tokens = listToArray(list=line, delimiters=" ");

					/*
					array index...
					1 = start met
					2 = end met
					3 = file name
					*/

					// We only care about the mpg files
					if ( right( trim(tokens[3]), 3 ) EQ "mpg" )
					{
						// Convert MET to seconds. Met = hhh:mm:ss
						var met = listToArray(list=trim(tokens[2]), delimiters=":");
						// Hours to seconds
						var metInSeconds = met[1] * 3600;
						// Minutes to seconds
						metInSeconds += met[2] * 60;
						metInSeconds += met[3];


						// I converted all the videos from mpg to mp4 (cause html natively plays mp4). So we have to change the file extensions
						tokens[3] = replace( trim(tokens[3]), "mpg", "mp4" );
						/*Create the SQL string, and insert the data*/
						var sql = "INSERT INTO videos
									(
									`missionID`,
									`description`,
									`filePath`,
									`met`,
									`createdDate`)
									VALUES
									(
									'" & rc.missionNum & "',
									'" & trim(tokens[3]) & "',
									'modules/apollo21/includes/video/" & rc.missionNum & "/" & trim(tokens[3]) & "',
									'" & metInSeconds & "',
									now())";

						q.setSQL(sql);
						q.execute();
					}

					//Get the next line... rinse and repeat
					line = reader.readLine();
				}
				while ( !isNull(line) );
			}

			event.setView("import/success");
		</cfscript>
	</cffunction>

	<cffunction name="scribble">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfscript>
			/*
			ex: met = 524698 seconds
			524698 / 3600 = 145.74944444
			=> 145 hours
			.74944444 hours * 60 = 44.9666664
			=> 44 minutes
			.9666664 * 60 = 57.999984
			~> 58 seconds

			145:44:58
		*/
		var total = 524698;
		var hours = int(total/3600); // 145
		total = ( (total/3600) - int(total/3600) ) * 60; // 44.9666664
		var minutes = int(total); // 44
		total = ( total - int(total) ) * 60; // 57.999984
		var seconds = round(total); // 58

		</cfscript>
	</cffunction>
</cfcomponent>