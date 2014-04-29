/**
* A cool Photo entity
*/
component persistent="true" table="events"{

	// Primary Key
	property name="eventID" fieldtype="id" column="eventID" generator="native";

	// Properties
	property name="metStart" ormtype="integer";
	property name="metFinish" ormtype="integer";
	property name="description" ormtype="string";
	property name="createdDate" ormtype="timestamp";

	// many-to-one
	property name="mission" fkcolumn="missionID" fieldtype="many-to-one" cfc="Mission";
	//property name="missionID" ormtype="integer";

	// Validation
	this.constraints = {
		// Example: age = { required=true, min="18", type="numeric" }
	};

	// Constructor
	function init(){

		return this;
	}

	string function displayMET(required numeric met)
	{
		/*
			ex: met = 524698 seconds
			524698 / 3600 = 145.74944444
			=> 145 hours
			.74944444 hours * 60 = 44.9666664
			=> 44 minutes
			.9666664 / 60 = 57.999984
			~> 58 seconds

			145:44:58
		*/
		if (arguments.met EQ 0 or isNull(arguments.met))
			return "00:00:00";

		var total = arguments.met;

		var hours = int(total / 3600); // 145
		total = ( (total/3600) - int(total/3600) ) * 60; // 44.9666664
		var minutes = int(total); // 44
		total = ( total - int(total) ) * 60; // 57.999984
		var seconds = round(total); // 58

		return hours & ":" & minutes & ":" & seconds;
	}
}
