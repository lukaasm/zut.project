<%@ include file="../template/taglib.jsp" %>

<div class="body">
	<h1>Public files!</h1>

	<form:form class="form-inline" method="POST" servletRelativeAction="/search">		
		<div class="form-group">			
			 <input
				type="text" class="form-control" name="search" id="search"
				placeholder="Search">
			<input type="hidden" name="access" value="a_public"/>
			
		</div>
		<button type="submit" class="btn btn-default">Search</button>
	</form:form>

	<table id="files" class="table table-bordered table-hover">
		<thead>
			<tr>
				<td width="5%">id</td>
				<td>file name</td>
				<td width="30%">content</td>
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