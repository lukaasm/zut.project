<%@ include file="../template/taglib.jsp" %>

<div class="form-group">
    <label for="username">Username:</label>
    <input type="text" class="form-control" value="${user.name}" id="username" disabled>
</div>
  
<div class="container">
<spring:url value="/account/update" var="url"/>

<form:form commandName="updateUser" action="${url}" method="POST" cssClass="form-horizontal" >
    <form:hidden value="${user.name}" path="username"/>
	<div class="form-group">
	    <label for="email">Email:</label>
	    <form:input cssClass="form-control" value="${user.email}" path="email"/>
	</div>
	<div class="form-group">
	    <label for="password">Password:</label>
		<form:password path="password" cssClass="form-control"/>
	</div>
	<div class ="form-group">
		<div class="col-sm-10">
			<input type="submit" value="Update" class="btn btn-lg btn-primary" />
		</div>
	</div>
</form:form>

<div class="form-group">
	<spring:url value="/users/deleteself" var="deleteUrl" htmlEscape="true" />
     <a href="${deleteUrl}" class="btn btn-lg btn-primary"><span class="glyphicon glyphicon-remove"> Delete </span></a>
</div>

</div>