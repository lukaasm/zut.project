<%@ include file="../template/taglib.jsp" %>

<div class="container">
	<form:form commandName="createUser" cssClass="form-horizontal">
	
	<jstl:if test ="${param.success eq true}">
		<div class="alert alert-success">Registration successfull!</div>
	</jstl:if>
	
		<div class ="form-group">
			<label for="name" class="col-sm-2 control-label">Username:</label>
			<div class="col-sm-10">
				<form:input path="name" cssClass=" form-control" />
			</div>
		</div>
		<div class ="form-group">
			<label for="email" class="col-sm-2 control-label">Email:</label>
			<div class="col-sm-10">
				<form:input path="email" cssClass=" form-control" />
			</div>
		</div>
		<div class ="form-group">
			<label for="password" class="col-sm-2 control-label">Password:</label>
			<div class="col-sm-10">
				<form:password path="password" cssClass=" form-control" />
			</div>
		</div>
		<div class ="form-group">
			<div class="col-sm-10">
				<input type="submit" value="Register" class="btn btn-lg btn-primary" />
			</div>
		</div>
	</form:form>
</div>