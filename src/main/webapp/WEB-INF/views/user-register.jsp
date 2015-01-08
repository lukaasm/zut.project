<%@ include file="../template/taglib.jsp" %>

<script> 
function validateForm(){ 
	var error = "";
	var name = document.forms["form"]["name"].value;
   	var email = document.forms["form"]["email"].value; 
   	var password = document.forms["form"]["password"].value;
   	
   	if(name == '') error += "Username is required\n";
   	if(email == '') error += "Email is required\n";
   	else if (!/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/.test(email)) error += "Email has wrong format\n";
   	if(password == '') error += "Password is required\n";
      	
   	if (error != ""){
   		alert(error);
   		return false;
   	}
   		
} 
</script>

<div class="container">
	<form:form name="form" commandName="createUser" cssClass="form-horizontal"  onsubmit="return validateForm();">
	

		<div class ="form-group">
			<label for="name" class="col-sm-2 control-label">Username:</label>
			<div class="col-sm-10">
				<form:input path="name" cssClass=" form-control" type="text"/>				
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
				<form:password path="password" cssClass=" form-control"/>
			</div>
		</div>
		<div class ="form-group">
			<div class="col-sm-10">
				<input type="submit" value="Register" class="btn btn-lg btn-primary" />
			</div>
		</div>
	</form:form>
</div>