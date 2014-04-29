component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	/**
	* Constructor
	*/
	public VideoService function init(){

		// init super class
		super.init(entityName="Video");

	    return this;
	}
}