<%@ include file="../taglib.jsp" %>

<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Default tiles template</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
</head>
<body>
	<tilesx:useAttribute name="current"/>

    <div class="container" style="padding: 15px" >
        <tiles:insertAttribute name="header" />
        <tiles:insertAttribute name="menu" />
        <div class="jumbotron" style="padding: 15px">
            <tiles:insertAttribute name="body" />
        </div>
        <center>
        	<tiles:insertAttribute name="footer" />
        </center>
    </div>
</body>
</html>