<%@ include file="../template/taglib.jsp" %>

<script>
$(function(){
	$("button#btnUpload").click(function(){
		//get last parent
		var path = document.URL.split("/");
		document.forms["form"]["parent"].value = path[path.length - 1];
		
		document.forms["form"].submit();
		$("#upload").modal('hide');
	});
});

$(function(){
	$("button#btnCreateFolder").click(function(){
		//get last parent
		var path = document.URL.split("/");
		document.forms["form_createFolder"]["parent"].value = path[path.length - 1];
		
		var name = document.forms["form_createFolder"]["name"].value;
		if(name == '') alert("Name is required");
		else if (!isNaN(name)) alert("Name cannot be a number");
		else{				
			document.forms["form_createFolder"].submit();
			$("#createFolder").modal('hide');
		}
		
	});
});
</script>
<div class="body">
	<h1>Files!</h1>
	<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#upload" >Upload</button>
	<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createFolder" >Create folder</button>
	<br></br>
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
						<spring:url value="/download/${file.id}" var="fileUrl" />
						<spring:url value="/files/${file.name}" var="folderUrl" />							
						<jstl:if test="${file.type != 'Folder'}"><a href="${fileUrl}" > ${file.name} </a></jstl:if>
						<jstl:if test="${file.type == 'Folder'}"><a href="${folderUrl}" > ${file.name} </a></jstl:if>
					</td>
					<td>
						${file.hash}
					</td>
				</tr>
			</jstl:forEach>
		</tbody>
	</table>
</div>

<!-- Dialog for upload files -->
<div class="modal fade" id="upload" tabindex="-1" role="dialog" aria-labelledby="Upload" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="UploadLabel">Upload</h4>
      </div>
      <div class="modal-body">
        <form:form name="form" method="POST" enctype="multipart/form-data" servletRelativeAction="/files/upload">
          <div class="form-group">
            <label for="choose-file" class="control-label">Choose file:</label>
            <input type="file"  name="file" multiple>
          </div>
          <div class="form-group">
            <label for="message-text" class="control-label">Description:</label>
            <textarea class="form-control" id="description"></textarea>
          </div>
          <div class="form-group">            
            <input type="hidden" name="parent" id="parent">
          </div>
        </form:form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" id="btnUpload" class="btn btn-primary">Upload</button>
      </div>
    </div>
  </div>
</div>

<!-- Dialog for create folder -->
<div class="modal fade" id="createFolder" tabindex="-1" role="dialog" aria-labelledby="createFolder" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="UploadLabel">Create Folder</h4>
      </div>
      <div class="modal-body">  
      <form:form name="form_createFolder" method="POST" servletRelativeAction="/files/createFolder">      
          <div class="form-group">
            <label for="message-text" class="control-label">Name:</label>
            <input type="text"  class="form-control" id="name" name="name">
          </div>
          <div class="form-group">            
            <input type="hidden" name="parent" id="parent">
          </div>
      </form:form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" id="btnCreateFolder" class="btn btn-primary">OK</button>
      </div>
    </div>
  </div>
</div>
