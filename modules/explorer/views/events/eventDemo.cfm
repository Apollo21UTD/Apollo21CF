<cfoutput>
	#html.startForm(action="explorer.events.eventDemo")#
		<select class="clearfix" name="missionNum" style="float:left;">
			<cfloop array="#prc.missions#" index="item">
				<option value="#item.getMissionNum()#"
					<cfif item.getMissionNum() EQ rc.missionNum>selected="true"</cfif>
					>
					#item.getDescription()#
				</option>
			</cfloop>
		</select>
		#html.submitButton(value="Submit", class="btn btn-submit")#
	#html.endForm()#

	<cfloop array="#prc.events#" index="thisEvent">
		<div style="height:200px; width:200px;border: 1px solid gray;border-radius: 4px;box-shadow: 0 1px 3px rgba(0, 0, 0, 0.055); padding:10px; display:inline-block; position:relative; float:left;" >
			<h3>#thisEvent.getDescription()#</h3>
			<p>Cras justo odio, dapibus ac facilisis in, egestas eget quam.</p>
	           #html.href(href="explorer.events.exploreEvent", queryString="mission=#rc.missionNum#&eventID=#thisEvent.getEventID()#", text="Explore", class="btn btn-info")#
		</div>
		<!---<div class="col-sm-6 col-md-4" style="width:200px;">
	        <div class="thumbnail">
	          <img alt="300x200" data-src="holder.js/300x200" style="width: 300px; height: 200px;" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMDAiIGhlaWdodD0iMjAwIj48cmVjdCB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgZmlsbD0iI2VlZSIvPjx0ZXh0IHRleHQtYW5jaG9yPSJtaWRkbGUiIHg9IjE1MCIgeT0iMTAwIiBzdHlsZT0iZmlsbDojYWFhO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zaXplOjE5cHg7Zm9udC1mYW1pbHk6QXJpYWwsSGVsdmV0aWNhLHNhbnMtc2VyaWY7ZG9taW5hbnQtYmFzZWxpbmU6Y2VudHJhbCI+MzAweDIwMDwvdGV4dD48L3N2Zz4=">
	          <div class="caption">
	            <h3>#event.getDescription()#</h3>
	            <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus.</p>
	            <p><a role="button" class="btn btn-primary" href="">Explore</a></p>
	          </div>
	        </div>
	      </div>--->
	</cfloop>


</cfoutput>