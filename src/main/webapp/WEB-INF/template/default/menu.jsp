<%@ include file="../taglib.jsp"%>

<ul class="nav nav-tabs nav-justified">
	<li>
		<spring:url
			value="/home" var="homeUrl" htmlEscape="true" /> <a
		href="${homeUrl}"><span class="glyphicon glyphicon-home"> Home </span></a></li>
	<li>
		<spring:url
			value="/about" var="aboutUrl" htmlEscape="true" /> <a
		href="${aboutUrl}"><span class="glyphicon glyphicon-info-sign"> About </span></a>
	</li>
	<li>
		<spring:url value="/files" var="filesUrl" htmlEscape="true" />
		<a href="${filesUrl}"><span class="glyphicon glyphicon-folder-open"> Files </span></a>
	</li>

	<security:authorize access="! isAuthenticated()">
		<li>
			<spring:url value="/register" var="registerUrl" htmlEscape="true" />
			<a href="${registerUrl}"><span class="glyphicon glyphicon-asterisk"> Register </span></a>
		</li>
		<li>
			<spring:url value="/login" var="loginUrl" htmlEscape="true" />
		 	<a href="${loginUrl}"><span class="glyphicon glyphicon-chevron-up"> Login </span></a>
		</li>
	</security:authorize>
	<security:authorize access="isAuthenticated()">
		<security:authorize access="hasRole('ROLE_ADMIN')">
			<li>
				<spring:url value="/users" var="usersUrl" htmlEscape="true" />
				<a href="${usersUrl}"><span class="glyphicon glyphicon-book"> Users </span></a>
			</li>
		</security:authorize>
		<li>
			<spring:url value="/account" var="accountUrl" htmlEscape="true" />
			<a href="${accountUrl}"><span class="glyphicon glyphicon-user"> Account </span></a>
		</li>
		<li>
			<spring:url value="/logout" var="logoutUrl" htmlEscape="true" />
			<a href="${logoutUrl}"><span class="glyphicon glyphicon-chevron-down"> Logout </span></a>
		</li>
	</security:authorize>

</ul>
