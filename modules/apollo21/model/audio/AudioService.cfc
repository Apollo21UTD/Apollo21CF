component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	/**
	* Constructor
	*/
	public AudioService function init(){

		// init super class
		super.init(entityName="Audio");

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
		var total = arguments.met;
		var hours = int(total/3600); // 145
		total = ( (total/3600) - int(total/3600) ) * 60; // 44.9666664
		var minutes = int(total); // 44
		total = ( total - int(total) ) * 60; // 57.999984
		var seconds = round(total); // 58

		return hours & ":" & minutes & ":" & seconds;
	}
}