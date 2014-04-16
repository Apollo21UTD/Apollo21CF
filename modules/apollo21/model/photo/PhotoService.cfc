component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	/**
	* Constructor
	*/
	public PhotoService function init(){

		// init super class
		super.init(entityName="Photo");

	    return this;
	}
}