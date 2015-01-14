<%@ include file="../template/taglib.jsp"%>

<div class="body">
	<h1>Album: '${name}'</h1>
	 
	<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
  <!-- Indicators -->
  <ol class="carousel-indicators">
  	<jstl:set var="i" scope="session" value="${0}"/>
  <jstl:forEach items="${files}" var="file">
  		<jstl:choose>
  			<jstl:when test= "${i == 0}">  			
  				<li data-target="#carousel-example-generic" data-slide-to="${i}" class="active"></li>
  			</jstl:when>
  			<jstl:otherwise>
  				<li data-target="#carousel-example-generic" data-slide-to="${i}"></li>
  			</jstl:otherwise>
	  	</jstl:choose> 
	  	<jstl:set var="i" value="${ i + 1 }" />
	</jstl:forEach>
   </ol>

  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">
  	<jstl:set var="i"  value="${0}"/>
  	<jstl:forEach items="${files}" var="file">
  		<jstl:choose>
  			<jstl:when test= "${i == 0}">
  			<jstl:set var="i" value="${ 1 }" />
  			<div class="item active" >
  			</jstl:when>
  			<jstl:otherwise>
  			<div class="item" >
  			</jstl:otherwise>
	  	</jstl:choose> 
		    <img src="${pageContext.request.contextPath}/image/${file.id}">		      
		    </div>
	</jstl:forEach> 
		
  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
	
</div>