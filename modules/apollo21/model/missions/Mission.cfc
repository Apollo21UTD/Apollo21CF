/**
* A cool Photo entity
*/
component persistent="true" table="missions"{

	// Primary Key
	property name="missionID" fieldtype="id" column="missionID" generator="native";

	// Properties
	property name="missionNum" ormtype="integer";
	property name="description" ormtype="string";
	property name="createdDate" ormtype="timestamp";


	// Validation
	this.constraints = {
		// Example: age = { required=true, min="18", type="numeric" }
	};

	// Constructor
	function init(){

		return this;
	}
}
