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

	String userID = null;
	if(session.getAttribute("userID")!=null){
		userID = (String) session.getAttribute("userID");
	}
	TimeDAO timeDAO = new TimeDAO();
	String result = timeDAO.whoseat(seat);
	String getlimit = timeDAO.getlimit(userID);
%>
<span style=" display: flex;
			  justify-content: center;
			  align-items: center;"><%=seat %></span>
	<%
	//본인 자리
	if(result.equals(userID)){
	%>
	<div style="  display: flex;
				  justify-content: center;
				  align-items: center;">
	<a href="endAction.jsp" type="button">종료</a> &nbsp;
	<a href="extendAction.jsp" type="button">연장</a>	
	</div>
	<%=getlimit %> 까지 사용 가능
	<%}
	//다른사람이 사용중일 때
	else if(result.equals("2")){
	%>
	<div style="  display: flex;
				  justify-content: center;
				  align-items: center;">
	<a href="startAction.jsp?seat=<%=seat %>" type="button">시작</a>
	</div>
	<%} 
	else{
	//비어있는 자리
	%>
	<div style="  display: flex;
				  justify-content: center;
				  align-items: center;">
	사용중
	</div>
	<%
	}
	%>

</body>
</html>