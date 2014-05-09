<cfoutput>
	<!--- Just some inline css. This is typically bad practice, but fine for a demo --->
	<style>
		.slider{
		    width:100%;
		    float:left;
		    overflow-x:scroll;
		    white-space:nowrap;
		}

		.contents{
			width:360px;
		    height:360px;
		    //border:1px solid black;
		    display:inline-block;
		    *dsplay:inline;/* For IE7*/
		    *zoom:1;/* For IE7*/
		    white-space:normal;
		}

	</style>
	<h1>#prc.event.getDescription()#<h2>

	<br><br>
	<h3>Photos</h3>
	<div class="row slider">
		<cfloop array="#prc.photos#" index="photo">
		  <div class="contents">
		    <span class="thumbnail">
		      <img src="#photo.getFilePath()#" alt="...">
		    </span>
		  </div>
		</cfloop>
	</div>

	<br><br>
	<h3>Videos</h3>
	<div class="row slider">
		<cfloop array="#prc.videos#" index="video">
		  <div class="contents">
		    <span class="thumbnail">
		      <!--- Note: Video tag does not work on IE 8 and lower --->
			  <video width="350" height="350" controls>
		      	<source src="#video.getFilePath()#" type="video/mp4">
			  </video>
		    </span>
		  </div>
		</cfloop>
	</div>

</cfoutput>