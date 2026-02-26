<%-- 
    Document   : home
    Created on : Feb 26, 2026, 10:52:23 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            model.UserDTO user
                    = (model.UserDTO) session.getAttribute("LOGIN_USER");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <h2>Welcome <%= user.getFullName()%></h2>
    </body>
</html>
