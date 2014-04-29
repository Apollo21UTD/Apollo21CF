component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{

	/**
	* Constructor
	*/
	public MissionService function init(){

		// init super class
		super.init(entityName="Mission");

	    return this;
	}
}