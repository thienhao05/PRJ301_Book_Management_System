package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.UserDAO;
import dto.UserDTO;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("Login".equals(action)) {

            String email = request.getParameter("txtEmail");
            String password = request.getParameter("txtPassword");

            UserDAO dao = new UserDAO();
            UserDTO user = dao.login(email, password);

            if (user != null) {
                request.getSession().setAttribute("LOGIN_USER", user);
                response.sendRedirect("home.jsp");
            } else {
                request.setAttribute("ERROR", "Invalid email or password");
                request.getRequestDispatcher("login.jsp")
                        .forward(request, response);
            }
        }
    }
}
