<%@ include file="../taglib.jsp"%>

<ul class="nav nav-tabs nav-justified">
	<li class="${current == 'home' ? 'active' : ''}"><spring:url
			value="/home" var="homeUrl" htmlEscape="true" /> <a
		href="${homeUrl}">Home</a></li>
	<li class="${current == 'about' ? 'active' : ''}"><spring:url
			value="/about" var="aboutUrl" htmlEscape="true" /> <a
		href="${aboutUrl}">About</a></li>
	<li class="${current == 'users' ? 'active' : ''}"><spring:url
			value="/users" var="usersUrl" htmlEscape="true" /> <a
		href="${usersUrl}">Users</a></li>

	<li class="${current == 'files' ? 'active' : ''}"><spring:url
			value="/files" var="filesUrl" htmlEscape="true" /> <a
		href="${filesUrl}">Files</a></li>

	<security:authorize access="! isAuthenticated()">
		<li class="${current == 'register' ? 'active' : ''}"><spring:url
				value="/register" var="registerUrl" htmlEscape="true" /> <a
			href="${registerUrl}">Register</a></li>
		<li class="${current == 'login' ? 'active' : ''}"><spring:url
				value="/login" var="loginUrl" htmlEscape="true" /> <a
			href="${loginUrl}">Login</a></li>
	</security:authorize>
	<security:authorize access="isAuthenticated()">
		<li><spring:url value="/logout" var="logoutUrl" htmlEscape="true" />
			<a href="${logoutUrl}">Logout</a></li>
	</security:authorize>

</ul>
