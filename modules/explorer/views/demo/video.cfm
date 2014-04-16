<cfoutput>

<cfdump var="#event.getModuleRoot('apollo21')#">
	<video width="320" height="240" controls>
		<source src="#event.getModuleRoot('apollo21')#/includes/video/apollo_11_liftoff.mp4" type="video/mp4">
		Your browser does not support the video tag.
	</video>

</cfoutput>