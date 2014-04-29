<cfoutput>
	<h1>#prc.event.getDescription()#<h2>

<div class="row">
	<cfloop array="#prc.photos#" index="photo">
	  <div class="col-xs-6 col-md-3">
	    <a href="" class="thumbnail">
	      <img src="#photo.getFilePath()#" alt="...">
	    </a>
	  </div>
	</cfloop>
</div>

</cfoutput>