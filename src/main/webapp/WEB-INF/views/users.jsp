<%@ include file="../template/taglib.jsp" %>

<div class="body">
	<h1>USERS!</h1>
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<td>user name</td>
				<td style="width:10px"></td>
			</tr>
		</thead>
		<tbody>
			<jstl:forEach items="${users}" var="user">
				<tr>
					<td>
						<spring:url value="/users/${user.id}" var="userUrl" />
						<a href="${userUrl}" > ${user.name} </a>
					</td>
					
					<td style="width:10px">
					 	<security:authentication property="principal.username" var="currentUser"/>
						<spring:url value="/users/delete/${user.id}" var="deleteUrl" />
						<jstl:if test="${currentUser != user.name}">
						<a href="${deleteUrl}" ><span class="glyphicon glyphicon-remove"></span></a>
						</jstl:if>
					</td>
					
				</tr>
			</jstl:forEach>
		</tbody>
	</table>
</div>
