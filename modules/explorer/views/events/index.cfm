<cfoutput>
<h1>Events</h1>

<!--- MessageBox --->
#getPlugin("MessageBox").renderIt()#

<!--- Create Button --->
#html.href(href="explorer.events.new", text="Create Event", class="btn btn-primary")#
#html.br(2)#

<!--- Listing --->

<table class="table table-hover table-striped">
	<thead>
		<tr>

			<th>metStart</th>



			<th>metFinish</th>



			<th>description</th>



			<th>mission</th>



			<th>createdDate</th>


			<th width="150">Actions</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#rc.events#" index="thisRecord">
		<tr>


					<td>#thisRecord.displayMET( thisRecord.getMetStart() )#</td>



					<td>#thisRecord.displayMET( thisRecord.getMetFinish() )#</td>



					<td>#thisRecord.getDescription()#</td>



					<td>#thisRecord.getMission().getMissionID()#</td>



					<td>#thisRecord.getcreatedDate()#</td>



			<td>
				#html.startForm(action="explorer.events.delete")#
					#html.hiddenField(name="eventID", bind=thisRecord)#
					#html.submitButton(value="Delete", onclick="return confirm('Really Delete Record?')", class="btn btn-danger")#
					#html.href(href="explorer.events.edit", queryString="eventID=#thisRecord.getEventID()#", text="Edit", class="btn btn-info")#
				#html.endForm()#
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

</cfoutput>