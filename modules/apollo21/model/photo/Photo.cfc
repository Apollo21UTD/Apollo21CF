/**
* A cool Photo entity
*/
component persistent="true" table="Photo"{

	// Primary Key
	property name="photoID" fieldtype="id" column="photoID" generator="native";

	// Properties
	property name="filePath" ormtype="string";
	property name="fileSize" ormtype="integer";
	property name="url" ormtype="string";
	property name="met" ormtype="integer";
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
