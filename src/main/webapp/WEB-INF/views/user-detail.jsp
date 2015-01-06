<%@ include file="../template/taglib.jsp" %>

<div class="form-group">
    <label for="username">Username:</label>
    <input type="text" class="form-control" value="${user.name}" id="username" disabled>
</div>
  
<div class="form-group">
    <label for="email">Email:</label>
    <input type="text" class="form-control" value="${user.email}" id="email" disabled>
</div>

<div class="form-group">
	<spring:url value="/users/deleteself" var="deleteUrl" htmlEscape="true" />
     <a href="${deleteUrl}" class="btn btn-lg btn-primary"><span class="glyphicon glyphicon-remove"> Delete </span></a>
</div>