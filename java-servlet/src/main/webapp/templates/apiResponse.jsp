<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>oAuth2 demo results</title>

    <link href="https://oauth-demo.sequencing.com/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://oauth-demo.sequencing.com/style.css" rel="stylesheet" />

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<div class="container">
    <div class="row"><div class="col-xs-12"><a href="/"><img src="https://oauth-demo.sequencing.com/images/logo.png" alt="Sequencing.com" /></a></div></div>
    <div class="row"><div class="col-xs-12"><h1 class="page-title">Thank you for using Sequencing.com's oAuth2 demo.</h1></div></div>
    <div class="row"><div class="col-xs-12">
        <p>If you see a list of file names below then the oAuth2 demo has completed successfully.</p>
        <ul>
            <li>The list contains genetic data files that can be accessed from your Sequencing.com account.</li>
            <li>This includes fun sample files accessible by all apps that use Real-Time Personalization (RTP).</li>
            <li>Sample files allow app users to experience RTP even if they don't yet have their own genetic data.</li>
        </ul>
        <p>Please visit the <a href="https://sequencing.com/developer-center/">Developer Center</a> to access developer resources and information.</p>
    </div></div>
    <div class="row"><div class="col-xs-12">
        <div class="table-responsive"><table class="table table-striped table-hover sample-files">
            <thead><tr>
                <th>File name</th>
            </tr></thead>
            <tbody>
            <c:set var="Name" value="Name"/>
            <c:forEach var="file" items="${response_json.iterator()}">
            	<c:set var="name" value="${file.getAsJsonObject().get('Name')}"/>
            	<c:set var="fd1" value="${file.getAsJsonObject().get('FriendlyDesc1')}"/>
            	<c:set var="fd2" value="${file.getAsJsonObject().get('FriendlyDesc2')}"/>
            	<tr><td>
            		<c:out value="${name.getAsString()}: "/>
            		<c:choose>
            			<c:when test="${not empty fd1 and not empty fd2}">
            				<c:out value="${fd1.getAsString()}, "/><c:out value="${fd2.getAsString()}"/>
           				</c:when>
           				<c:when test="${not empty fd1}">
           					<c:out value="${fd1.getAsString()}"/>
           				</c:when>
           				<c:when test="${not empty fd2}"> 
           					<c:out value="${fd2.getAsString()}"/> 
           				</c:when>
            		</c:choose>
            	</td></tr>
            </c:forEach>
            </tbody>
        </table></div>
    </div></div>
</div>

<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="https://oauth-demo.sequencing.com/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>