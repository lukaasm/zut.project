<%@ include file="../template/taglib.jsp" %>

<script>


$(document).ready(function() {
    $('#files').DataTable({
    	"searching": false,
    	"ordering" : true,
    });
} );


$(function() {
	$("button#btnSearch").click(function() {
		document.forms["form_advanced"].submit();
		$("#advanced").modal('hide');
	});
});

</script>

<div class="body">
	<h1>Public files!</h1>

	
	<form:form class="form-inline" method="POST" servletRelativeAction="/search">		
		<div class="form-group">			
			 <input
				type="text" class="form-control" name="search" id="search"
				placeholder="Search">
			<input type="hidden" name="access" value="${access}"/>
			<input type="hidden" name="fileTypes" value=""/>
			
		</div>
		<button type="submit" class="btn btn-default">Search</button>
		<button type="button" class="btn btn-default"
					data-toggle="modal" data-target="#advanced">Advanced search</button>
	</form:form>	
	
	
	<table id="files" class="table table-bordered table-hover">
		<thead>
			<tr>
				<th width="5%">id</th>
				<th>file name</th>
				<th width="30%">content</th>
			</tr>
		</thead>
		<tbody>
			<jstl:forEach items="${files}" var="file">
				<tr>
					<td>${file.id}</td>
					<td><spring:url value="/download/${file.id}" var="fileUrl" />
						<spring:url value="/files/${file.name}" var="folderUrl" />
						<spring:url value="/albums/${file.id}" var="albumUrl" />
						 <jstl:choose>
						 <jstl:when test="${file.type == 'Album' }">
						 	<a href="${albumUrl}"> ${file.name} </a>
						 </jstl:when>
 						<jstl:when test="${file.type == 'Folder' }">
 							<a href="${folderUrl}"> ${file.name} </a>
						 </jstl:when>
						 <jstl:otherwise>
						 	<a href="${fileUrl}"> ${file.name} </a>
						 </jstl:otherwise>							
						</jstl:choose>
					<td>${file.type}</td>
				</tr>
			</jstl:forEach>
		</tbody>
	</table>

</div>

<div class="modal fade" id="advanced" tabindex="-1" role="dialog"
	aria-labelledby="createFolder" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="UploadLabel">Advanced search</h4>
			</div>
			<div class="modal-body">
				<form:form name="form_advanced" method="POST"
					servletRelativeAction="/search">
					<div class="form-group">
						<label for="message-text" class="control-label">Search:</label> <input
							type="text" class="form-control" id="name" name="search">
							<ul >
								<li><label class="checkbox">
								  	<input type="checkbox" name="fileTypes" value="Folder">Folders
								</label></li>
								<li><label class="checkbox">
								  	<input type="checkbox" name="fileTypes" value="Album">Albums
								</label></li>
								<li><label class="checkbox">
								  	<input type="checkbox" name="fileTypes" value="image/%">Images
								</label></li>
								<li><label class="checkbox">
								  	<input type="checkbox" name="fileTypes" value="audio/%">Audio
								</label></li>
								<li><label class="checkbox">
								  	<input type="checkbox" name="fileTypes" value="application/%">Documents
								</label></li>
							</ul>
					</div>
					<div class="form-group">
						<input type="hidden" name="access" value="${access}">
						<input type="hidden" name="fileTypes" value="">
					</div>
				</form:form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" id="btnSearch" class="btn btn-primary">Search</button>
			</div>
		</div>
	</div>
</div>

