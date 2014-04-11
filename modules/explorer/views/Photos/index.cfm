<cfoutput>
<h1>Photos</h1>

<!--- MessageBox --->
#getPlugin("MessageBox").renderIt()#

<!--- Create Button --->
#html.href(href="Photos.new", text="Create Photo", class="btn btn-primary")#
#html.br(2)#

<!--- Listing --->

<table class="table table-hover table-striped">
	<thead>
		<tr>




			<th>filePath</th>



			<th>fileSize</th>



			<th>url</th>



			<th>met</th>



			<th>createdDate</th>


			<th width="150">Actions</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#rc.Photos#" index="thisRecord">
		<tr>




					<td>#thisRecord.getfilePath()#</td>



					<td>#thisRecord.getfileSize()#</td>



					<td>#thisRecord.geturl()#</td>



					<td>#thisRecord.getmet()#</td>



					<td>#thisRecord.getcreatedDate()#</td>



			<td>
				#html.startForm(action="Photos.delete")#
					#html.hiddenField(name="photoID", bind=thisRecord)#
					#html.submitButton(value="Delete", onclick="return confirm('Really Delete Record?')", class="btn btn-danger")#
					#html.href(href="Photos.edit", queryString="photoID=#thisRecord.getphotoID()#", text="Edit", class="btn btn-info")#
				#html.endForm()#
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>

</cfoutput>