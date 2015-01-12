<%@ include file="../template/taglib.jsp" %>

<div class="body">
	<h1>Public files!</h1>

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
						<spring:url value="/files/${file.name}" var="folderUrl" /> <jstl:if
							test="${file.type != 'Folder'}">
							<a href="${fileUrl}"> ${file.name} </a>
						</jstl:if> <jstl:if test="${file.type == 'Folder'}">
							<a href="${folderUrl}"> ${file.name} </a>
						</jstl:if></td>
					<td>${file.type}</td>
				</tr>
			</jstl:forEach>
		</tbody>
	</table>
</div>