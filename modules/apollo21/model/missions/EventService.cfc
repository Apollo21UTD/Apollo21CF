component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	/**
	* Constructor
	*/
	public EventService function init(){

		// init super class
		super.init(entityName="Event");

	    return this;
	}
}