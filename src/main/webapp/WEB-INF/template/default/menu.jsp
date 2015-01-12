<%@ include file="../taglib.jsp"%>

<ul class="nav nav-pills">
	<li>
		<spring:url
			value="/home" var="homeUrl" htmlEscape="true" /> <a
		href="${homeUrl}"><span class="glyphicon glyphicon-home" /> Home </a></li>
	<security:authorize access="! isAuthenticated()">
		<li>
			<spring:url value="/register" var="registerUrl" htmlEscape="true" />
			<a href="${registerUrl}"><span class="glyphicon glyphicon-asterisk" /> Register </a>
		</li>
		<li>
			<spring:url value="/login" var="loginUrl" htmlEscape="true" />
		 	<a href="${loginUrl}"><span class="glyphicon glyphicon-chevron-up" /> Login </a>
		</li>
	</security:authorize>
	
	<security:authorize access="isAuthenticated()">
		<security:authorize access="hasRole('ROLE_ADMIN')">
			<li class="dropdown">
			    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="glyphicon glyphicon-cog" /> Admin <span class="caret"></span></a>
			    <ul class="dropdown-menu" role="menu">
					<spring:url value="/users/all" var="usersUrl" htmlEscape="true" />
			    
				   <li><a href="${usersUrl}">All users</a></li>
				   <security:authentication property="principal.username" var="currentUser"/>
				   <spring:url value="/files/all" var="filesUrl" htmlEscape="true" />

				   <li><a href="${filesUrl}">All files</a></li>
			    </ul>
		    </li>
	</security:authorize>
			<li class="dropdown">
			    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="glyphicon glyphicon-info-sign" /> Account<span class="caret"></span></a>
			    <ul class="dropdown-menu" role="menu">
	    			<spring:url value="/account" var="accountUrl" htmlEscape="true" />
			    
				   <li><a href="${accountUrl}">Details</a></li>
				   <spring:url value="/account/files" var="filesUrl2" htmlEscape="true" />
				   <li><a href="${filesUrl2}">My files</a></li>
			    </ul>
		    </li>
    		<li>
			<spring:url value="/logout" var="logoutUrl" htmlEscape="true" />
			<a href="${logoutUrl}"><span class="glyphicon glyphicon-chevron-down"/> Logout</a>
		</li>
</security:authorize>
	<li>
		<spring:url
			value="/about" var="aboutUrl" htmlEscape="true" /> <a
		href="${aboutUrl}"><span class="glyphicon glyphicon-info-sign" /> About</a>
	</li>
</ul>
