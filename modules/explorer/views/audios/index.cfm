<cfoutput>
<h1>Audios</h1>

<!--- MessageBox --->
#getPlugin("MessageBox").renderIt()#

<!--- Create Button --->
#html.href(href="explorer.audios.new", text="Create Audio", class="btn btn-primary")#
#html.br(2)#

<!--- Listing --->

<table class="table table-hover table-striped">
	<thead>
		<tr>

			<th>description</th>



			<th>filePath</th>



			<th>fileSize</th>



			<th>url</th>



			<th>met</th>



			<th>length</th>



			<th>createdDate</th>


			<th width="150">Actions</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#rc.audios#" index="thisRecord">
		<tr>


					<td>#thisRecord.getDescription()#</td>



					<td>#thisRecord.getfilePath()#</td>



					<td>#thisRecord.getfileSize()#</td>



					<td>#thisRecord.geturl()#</td>



					<td>#thisRecord.getmet()#</td>



					<td>#thisRecord.getLength()#</td>



					<td>#thisRecord.getcreatedDate()#</td>



			<td>
				#html.startForm(action="explorer.audios.delete")#
					#html.hiddenField(name="audioID", bind=thisRecord)#
					#html.submitButton(value="Delete", onclick="return confirm('Really Delete Record?')", class="btn btn-danger")#
					#html.href(href="explorer.audios.edit", queryString="audioID=#thisRecord.getaudioID()#", text="Edit", class="btn btn-info")#
				#html.endForm()#
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

</cfoutput>