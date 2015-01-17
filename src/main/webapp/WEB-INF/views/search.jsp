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

$(function() {
	$("button#btnDelete").click(function() {
		var id = this.value;
		
		$.post("${pageContext.request.contextPath}/files/delete", {
			filesToDelete : id
		}, function() {
			window.location.replace("${pageContext.request.contextPath}/files/");
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
		var name = document.forms["form_editName"]["name"].value;
		if(name == '') alert("Name is required");
		else if (!isNaN(name)) alert("Name cannot be a number");
		else{				
			document.forms["form_editName"].submit();
			$("#editName").modal('hide');
		}		
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
				<jstl:if test="${access == 'a_private' }">
					<th width="10%">access</th>
					<th width="10%">edit</th>
					<th width="10%">delete</th>
				</jstl:if>
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
						 	<a href="${albumUrl}"> <span
								class="glyphicon glyphicon-picture"></span>  ${file.name} </a>
						 </jstl:when>
 						<jstl:when test="${file.type == 'Folder' }">
 							<a href="${folderUrl}"> <span
								class="glyphicon glyphicon-folder-close"></span>  ${file.name} </a>
						 </jstl:when>
						 <jstl:otherwise>
						 	<a href="${fileUrl}"> <span class="glyphicon glyphicon-file"></span> ${file.name} </a>
						 </jstl:otherwise>							
						</jstl:choose>
					<td>${file.type}</td>
					<jstl:if test="${access == 'a_private'}">
					<td><security:authentication
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
					<button value="${file.id}" id="btnDelete" type="button"
						class="btn btn-primary" 
						>Delete</button>
					</td>
					<td>
					<button value="${file.id}" id="btnedit" type="button"
						class="btn btn-primary" 
						>Edit</button>
					</td>
					</jstl:if>
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
	
<!-- Dialog for edit name -->

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
