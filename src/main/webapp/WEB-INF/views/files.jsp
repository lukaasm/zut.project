<%@ include file="../template/taglib.jsp"%>

<script>


$(document).ready(function() {
    $('#files').DataTable({
    	"searching": false,
    	"ordering" : true,
    });
} );


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


$(function() {
	$("button#btnDelete").click(function() {
		var id = getSelectedId();
		
		$.post("${pageContext.request.contextPath}/files/delete", {
			filesToDelete : id
		}, function() {
			window.location.replace(document.URL);
		});					
	});
});

$(function() {
	$("button#btnedit").click(function() {		
		var val = this.value;
		
		$.ajax({
			url : "${pageContext.request.contextPath}/files/getName",
			type : 'POST',
			data : { id : val}, 
			success : function(name) {
				document.forms["form_editName"]["id"].value = val;				
				document.forms["form_editName"]["name"].value = name;				
				$("#editName").modal('show');
			}
		});			
	});
});

$(function(){
		$('#changeAccess').on(
				'show.bs.modal',
				function(e) {
					document.forms["changeAccess"]["file_id"].value = $(
				e.relatedTarget).attr("value");
});
});

$(function() {
		$("button#btnChangeAccess").click(function() {
			document.forms["changeAccess"].submit();
			$("#changeAccess").modal('hide');
		});
	});
	
$(function() {
	$("button#btnEditName").click(function() {
		document.forms["form_editName"].submit();
		$("#editName").modal('hide');
	});
});


$(function(){
	$("button#btnCreateAlbum").click(function(){
		//get last parent
		var path = document.URL.split("/");
		document.forms["form_createAlbum"]["parent"].value = path[path.length - 1];
		
		var name = document.forms["form_createAlbum"]["name"].value;
		if(name == '') alert("Name is required");
		else if (!isNaN(name)) alert("Name cannot be a number");
		else{				
			document.forms["form_createAlbum"].submit();
			$("#createAlbum").modal('hide');
		}
		
	});
});



// selecting rows
onload = function() {
	var rowSelected = 0;
	if (!document.getElementsByTagName || !document.createTextNode)
			return;
		var rows = document.getElementById('files').rows;
		
		for (i = 1; i < rows.length; i++) {
			rows[i].onclick = function() {				
				if (this.style.backgroundColor == ""){
					this.style.backgroundColor = "lightblue";
					rowSelected++;
				}
				else{
					this.style.backgroundColor = "";
					rowSelected--;
				
				}
				if(rowSelected > 0){
					document.getElementById('rowSelected').innerHTML = rowSelected;
					document.getElementById('btnDelete').style.display = '';
					document.getElementById('btnMoveTo').style.display = '';
					
					if(rowSelected == 1){
						document.getElementById('btnEditName').style.display = '';						
					}
				}
				else{
					document.getElementById('btnDelete').style.display = 'none';
					document.getElementById('btnMoveTo').style.display = 'none';									
				}
			}
		}
	}

var selectedFileName;

function getSelectedId(){
	var id = "";
	
	var rows = document.getElementById('files').rows;
	for (i = 1; i < rows.length; i++) {
		
		if(rows[i].style.backgroundColor != ""){				
			id += $.trim(rows[i].cells[0].innerHTML) + ",";
			selectedFileName = $.trim(rows[i].cells[1].innerHTML);
		}
	}	
	
	return id;
}


function setElementsToMove(folderId){
	var elements = getSelectedId();
	
	
	$.post("${pageContext.request.contextPath}/files/move", {
			folder : folderId,
			elements : elements
		}, function() {
			window.location.replace(document.URL);
		});
	}


</script>

<div class="body">
	<h1>Files!</h1>
	
	<form:form class="form-inline" method="POST" servletRelativeAction="/search">		
		<div class="form-group">			
			 <input
				type="text" class="form-control" name="search" id="search"
				placeholder="Search">
			<input type="hidden" name="access" value="_"/>
			<input type="hidden" name="fileTypes"/>
			
		</div>
		<button type="submit" class="btn btn-default">Search</button>
	</form:form>
	
	<div>
		<ul class="nav nav-pills" role="tablist">
			<li><button type="button" class="btn btn-primary"
					data-toggle="modal" data-target="#upload">Upload</button></li>
			<li><button type="button" class="btn btn-primary"
					data-toggle="modal" data-target="#createFolder">Create
					folder</button></li>
			<li><button type="button" class="btn btn-primary"
					data-toggle="modal" data-target="#createAlbum">Create
					album</button></li>
			<li><button id="btnDelete" class="btn btn-primary" type="button"
					style="display: none">
					Delete <span id="rowSelected" class="badge">#</span>
				</button></li>

			<li class="dropdown">
				<button id="btnMoveTo" type="button" style="display: none"
					class="btn btn-primary" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false">
					Move to ... <span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
					<jstl:forEach items="${files}" var="file">
						<spring:url value="/files/move/${file.id}" var="folderUrl" />
						<jstl:if test="${file.type == 'Folder' || file.type == 'Album'}">
							<li role="presentation"><a id="${file.id}" role="menuitem"
								tabindex="-1" href="javascript:;"
								onclick="setElementsToMove(this.id);"> ${file.name}</a></li>
						</jstl:if>
					</jstl:forEach>
				</ul>
			</li>
			<li><button type="button" id="btnEditName" class="btn btn-primary"
					data-toggle="modal" data-target="#editName">Change name</button></li>
			<li><button type="button" id="btnEditAlbum" class="btn btn-primary">Edit album</button></li>
		</ul>
	</div>	
	<br>
	<table id="files" class="table table-bordered table-hover">
		<thead>
			<tr>
				<th width="5%">id</th>
				<th>file name</th>
				<th width="30%">content</th>
				<th width="30%">access</th>
				<th width="30%">edit</th>
			</tr>
		</thead>
		<tbody>
			<jstl:forEach items="${files}" var="file">
				<tr>
					<td>${file.id}</td>
					<td><spring:url value="/download/${file.id}" var="fileUrl" />
						<spring:url value="/files/${file.name}" var="folderUrl" />
						<spring:url value="/albums/${file.id}" var="albumUrl" /> 
						<jstl:if
							test="${file.type != 'Folder' && file.type != 'Album'}">
							<a href="${fileUrl}"><span class="glyphicon glyphicon-file"></span>
								${file.name} </a>
						</jstl:if> <jstl:if test="${file.type == 'Folder'}">
							<a href="${folderUrl}"><span
								class="glyphicon glyphicon-folder-close"></span> ${file.name} </a>
						</jstl:if>
						 <jstl:if test="${file.type == 'Album'}">
							<a href="${albumUrl}"><span
								class="glyphicon glyphicon-picture"></span> ${file.name} </a>
						</jstl:if></td>
					<td>${file.type}</td>					<td><security:authentication
							property="principal.username" var="currentUser" /> <security:authorize
							access="isAuthenticated()">
							<security:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin" />
							<jstl:choose>
								<jstl:when test="${pageContext.request.userPrincipal.name == file.user.name || isAdmin}">
									<button value="${file.id}" type="button"
										class="btn btn-primary" data-toggle="modal"
										data-target="#changeAccess">${file.access}</button>
								</jstl:when>
								<jstl:otherwise>
									<button value="${file.id}" type="button"
										class="btn btn-primary" data-toggle="modal"
										data-target="#changeAccess" disabled>${file.access}</button>
								</jstl:otherwise>
							</jstl:choose>
						</security:authorize>
						<jstl:if test="${file.access == 'a_link'}">
						<jstl:choose>
							<jstl:when test="${file.type == 'Album' }">
								<a href="${albumUrl}"><span class="glyphicon glyphicon-download"></span>
								${albumUrl} </a>
							</jstl:when>
							<jstl:when test="${file.type == 'Folder' }">
								<a href="${folderUrl}"><span class="glyphicon glyphicon-download"></span>
								${folderUrl} </a>
							</jstl:when>
							<jstl:otherwise>
								<a href="${fileUrl}"><span class="glyphicon glyphicon-download"></span>
								${fileUrl} </a>	
							</jstl:otherwise>
						</jstl:choose>
							
						</jstl:if>
					</td>
					<td>
					<button value="${file.id}" id="btnedit" type="button"
						class="btn btn-primary" 
						>Change name</button>
					</td>
				</tr>
			</jstl:forEach>
		</tbody>
	</table>
</div>

<!-- Dialog for upload files -->
<div class="modal fade" id="upload" tabindex="-1" role="dialog"
	aria-labelledby="Upload" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="UploadLabel">Upload</h4>
			</div>
			<div class="modal-body">
				<form:form name="form" method="POST" enctype="multipart/form-data"
					servletRelativeAction="/files/upload">
					<div class="form-group">
						<label for="choose-file" class="control-label">Choose
							file:</label> <input type="file" name="file" multiple>
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
<div class="modal fade" id="createFolder" tabindex="-1" role="dialog"
	aria-labelledby="createFolder" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="UploadLabel">Create Folder</h4>
			</div>
			<div class="modal-body">
				<form:form name="form_createFolder" method="POST"
					servletRelativeAction="/files/createFolder">
					<div class="form-group">
						<label for="message-text" class="control-label">Name:</label> <input
							type="text" class="form-control" id="name" name="name">
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


<div class="modal fade" id="changeAccess" tabindex="-1" role="dialog"
	aria-labelledby="changeAccess" aria-hidden="true">				
		
		<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>						
				<h4 class="modal-title" id="UploadLabel">Create Album</h4>
			</div>
			<div class="modal-body">
				<form:form name="changeAccess" method="POST"
					servletRelativeAction="/files/updateAccess">
					<div class="form-group">
						<label for="message-text" class="control-label">Sharing
							mode:</label> <select class="form-control" id="access" name="access">
							<option>a_public</option>
							<option>a_private</option>
							<option>a_link</option>
						</select>
					</div>
					<div class="form-group">
						<input type="hidden" name="file_id">
					</div>
				</form:form>
				</div>
					<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>	
					<button type="button" id="btnChangeAccess" class="btn btn-primary">OK</button>			
				</div>
			</div>
			</div>
	</div>		
	
		
<!-- Dialog for create album -->
<div class="modal fade" id="createAlbum" tabindex="-1" role="dialog"
	aria-labelledby="createAlbum" aria-hidden="true">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>						
				<h4 class="modal-title" id="UploadLabel">Create Album</h4>
			</div>
			<div class="modal-body">
				<form:form name="form_createAlbum" method="POST"
					servletRelativeAction="/files/createAlbum">
					<div class="form-group">
						<label for="message-text" class="control-label">Name:</label> <input
							type="text" class="form-control" id="name" name="name">
					</div>
					<div class="form-group">
						<input type="hidden" name="parent" id="parent">
					</div>
				</form:form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>	
				
				<button type="button" id="btnCreateAlbum" class="btn btn-primary">OK</button>
			</div>
		</div>
	</div>
</div>


<!-- Dialog for edit folder/album name -->

<div class="modal fade" id="editName" tabindex="-1" role="dialog"
	aria-labelledby="editName" aria-hidden="true">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>						
				<h4 class="modal-title" id="UploadLabel">Change name:</h4>
			</div>
			<div class="modal-body">
				<form:form name="form_editName" method="POST"
					servletRelativeAction="/files/editName">
					<div class="form-group">
						<label for="message-text" class="control-label">Name:</label> <input
							type="text" class="form-control" id="name" name="name">
					</div>	
					<div class="form-group">
						<input type="hidden" name="id">
					</div>				
				</form:form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>	
				
				<button type="button" id="btnEditName" class="btn btn-primary">OK</button>
			</div>
		</div>
	</div>
</div>