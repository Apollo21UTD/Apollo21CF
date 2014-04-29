<cfoutput>

	<script type="javascript/text">
		$('input[type=file]').bootstrapFileInput();
	</script>

	#html.startForm(id="importForm", name="importForm", action=event.buildLink("apollo21/import/scribble"), method="post", role="form")#
		<div class="form-group">
			<h6>Select the desired directory location</h6>
			<a class="file-input-wrapper btn btn-default btn-primary" data-filename-placement="">
				<span>browse</span>
				<input type="file" class="btn-primary" title="browse" >
			</a>
		</div>

		<br><br>
		<button type="submit" class="btn-submit">Submit</button>
	#html.endForm()#
</cfoutput>