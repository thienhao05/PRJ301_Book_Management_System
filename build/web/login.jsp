<%-- 
    Document   : login
    Created on : Feb 26, 2026, 10:36:51 PM
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
        <form action="MainController" method="post">
            Email: <input type="text" name="txtEmail" /> <br/>
            Password: <input type="password" name="txtPassword" /> <br/>
            <input type="submit" name="action" value="Login" />
        </form>

        <%
            String error = (String) request.getAttribute("ERROR");
            if (error != null) {
        %>
        <p style="color:red"><%= error%></p>
        <%
            }
        %>
    </body>
</html>
