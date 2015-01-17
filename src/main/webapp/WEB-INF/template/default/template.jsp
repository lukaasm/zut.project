<%@ include file="../taglib.jsp" %>

<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Default tiles template</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
</head>
<body>
	<tilesx:useAttribute name="current"/>
	<script src="https://code.jquery.com/jquery.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"> </script>
    <script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.4/js/jquery.dataTables.js"></script>
    <script src = "//cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/3/dataTables.bootstrap.css"></script>
    <script src = "//cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/3/dataTables.bootstrap.js"></script>
    
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