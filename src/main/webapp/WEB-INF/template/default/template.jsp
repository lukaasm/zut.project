<%@ include file="../taglib.jsp" %>

<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>zut.project simple cloud like storage</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
</head>
<body>
	<tilesx:useAttribute name="current"/>
	<script src="https://code.jquery.com/jquery.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"> </script>
    
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