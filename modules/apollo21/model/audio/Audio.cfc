/**
* A cool Photo entity
*/
component persistent="true" table="audios"{

	// Primary Key
	property name="audioID" fieldtype="id" column="audioID" generator="native";

	// Properties
	property name="description" ormtype="string";
	property name="filePath" ormtype="string";
	property name="fileSize" ormtype="integer";
	property name="url" ormtype="string";
	property name="met" ormtype="integer";
	property name="length" ormtype="integer";
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
