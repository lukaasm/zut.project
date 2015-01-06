<%@ include file="../template/taglib.jsp" %>

<div class="body">
	<h1>Files!</h1>
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
