<%@ include file="../template/taglib.jsp" %>

<div class="body">
	<h1>USERS!</h1>
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<td>user name</td>
			</tr>
		</thead>
		<tbody>
			<jstl:forEach items="${users}" var="user">
				<tr>
					<td>
						<spring:url value="/users/${user.id}" var="userUrl" />
						<a href="${userUrl}" > ${user.name} </a>
					</td>
				</tr>
			</jstl:forEach>
		</tbody>
	</table>
</div>
