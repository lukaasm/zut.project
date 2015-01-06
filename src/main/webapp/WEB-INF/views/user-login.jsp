<%@ include file="../template/taglib.jsp"%>

<spring:url value="/j_spring_security_check" var="actionUrl"/>
<form class="form-signin" role="form" action="${actionUrl}" method="post">
	<label for="name" class="sr-only">Username</label> <input type="text"
		name="j_username" class="form-control" placeholder="Username"
		required autofocus> <label for="inputPassword" class="sr-only">Password</label>
	<input type="password" name="j_password" class="form-control"
		placeholder="Password" required>
	<button class="btn btn-lg btn-primary btn-block" type="submit">Sign
		in</button>
</form>
