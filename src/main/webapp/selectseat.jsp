<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="time.TimeDAO" %>
<%@ page import="time.Time" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

</head>
<body>
<%
	String seat = null;
	seat = request.getParameter("seat");
%>
<p><%=seat %></p>
	<div>
	<a href="startAction.jsp" type="button">시작</a>
	<a href="endAction.jsp" type="button">종료</a>
	</div>
</body>
</html>