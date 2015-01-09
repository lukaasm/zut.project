<%@ include file="../template/taglib.jsp" %>

<script>
$(function(){
	$("button#btnUpload").click(function(){
		document.forms["form"].submit();
		$("#upload").modal('hide');
	});
});
</script>
<div class="body">
	<h1>Files!</h1>
	<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#upload" >Upload</button><br></br>
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<td>id</td><td>file name</td><td>hash</td>
			</tr>
		</thead>
		<tbody>
			<jstl:forEach items="${files}" var="file">
				<tr>
					<td>
						${file.id}
					</td>
					<td>
						<spring:url value="/files/${file.id}" var="fileUrl" />
						<a href="${fileUrl}" > ${file.name} </a>
					</td>
					<td>
						${file.hash}
					</td>
				</tr>
			</jstl:forEach>
		</tbody>
	</table>
</div>

<div class="modal fade" id="upload" tabindex="-1" role="dialog" aria-labelledby="Upload" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="UploadLabel">Upload</h4>
      </div>
      <div class="modal-body">
        <form name="form" method="POST" enctype="multipart/form-data" action="upload">
          <div class="form-group">
            <label for="choose-file" class="control-label">Choose file:</label>
            <input type="file"  name="file" multiple>
          </div>
          <div class="form-group">
            <label for="message-text" class="control-label">Description:</label>
            <textarea class="form-control" id="description"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" id="btnUpload" class="btn btn-primary">Upload</button>
      </div>
    </div>
  </div>
</div>
