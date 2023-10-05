/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import Fascades.AdminsFacade;
import Fascades.CustomersFacade;
import Fascades.SellersFacade;
import Fascades.UsersFacade;
import Model.Customers;
import Model.Admins;
import Model.Users;
import Model.Sellers;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import javax.imageio.ImageIO;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.MultipartConfig;
import java.util.List;
import javax.servlet.http.HttpSession;

/**
 *
 * @author User
 */
@WebServlet("/RegisterServlet")
@MultipartConfig
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @EJB
    private SellersFacade sellersFacade;

    @EJB
    private AdminsFacade adminsFacade;

    @EJB
    private CustomersFacade customersFacade;

    @EJB
    private UsersFacade usersFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Users user = new Users();
        user.setUsername(request.getParameter("username"));
        String email = request.getParameter("email");
        
        if (usersFacade.getUserByEmail(email) != null){
            request.setAttribute("registerStatus", "duplicate-email");
            if (request.getParameter("registerFrom").equals("registration")){
                RequestDispatcher dispatcher = request.getRequestDispatcher("login_and_register.jsp");
                dispatcher.forward(request, response);
            } else if (request.getParameter("registerFrom").equals("adminRegister")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("adminRegister.jsp");
                dispatcher.forward(request, response);
            }
            return;
        } else {
            user.setEmail(email);
        }
        
        user.setPassword(request.getParameter("pswd"));

        String imgUrl = request.getParameter("url");
        user.setProfile_img(imgUrl);
        
        LocalDateTime now = LocalDateTime.now();
        Timestamp timestampNow = Timestamp.valueOf(now);
        user.setCreated_at(timestampNow);
        user.setUpdated_at(timestampNow);
        
        try{
            user.setId(usersFacade.getLatestId() + 1);
        } catch (Exception e){
            user.setId(1L);
        }
        
        if (request.getParameter("registerFrom").equals("registration")){
            String role = request.getParameter("role");
            if (role.equals("None")){
                request.setAttribute("registerStatus", "no-role");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login_and_register.jsp");
                dispatcher.forward(request, response);
                return;
            } else if (role.equals("Customer")){
                user.setRole("customer");
                if (usersFacade.registerNewUser(user)){
                    Customers cust = new Customers();
                    try{
                        cust.setId(customersFacade.getLatestId() + 1);
                    } catch (Exception e){
                        cust.setId(1L);
                    }
                    cust.setUser_id(usersFacade.getUserByEmail(email).getId());
                    cust.setContact_no(request.getParameter("contactCust"));
                    cust.setBilling_address(request.getParameter("billing"));
                    cust.setShipping_address(request.getParameter("shipping"));
                    cust.setDate_of_birth(request.getParameter("dob"));
                    cust.setWallet_balance(0);
                    if (customersFacade.registerNewCustomer(cust)){
                        request.setAttribute("registerStatus", "customer-success");
                    } else {
                        request.setAttribute("registerStatus", "register-fail");
                    }
                } else {
                    request.setAttribute("registerStatus", "register-fail");
                }
            } else if (role.equals("Seller")){
                user.setRole("pending");
                if (usersFacade.registerNewUser(user)){
                    Sellers seller = new Sellers();
                    try{
                        seller.setId(sellersFacade.getLatestId() + 1);
                    } catch (Exception e){
                        seller.setId(1L);
                    }
                    seller.setUser_id(usersFacade.getUserByEmail(email).getId());
                    seller.setContact_no(request.getParameter("contactSeller"));
                    seller.setAddress(request.getParameter("address"));
                    seller.setDescription(request.getParameter("description"));
                    seller.setTotal_items(0);
                    seller.setCredit_points(0);
                    seller.setFollowers(0);
                    if (sellersFacade.registerNewSeller(seller)){
                         request.setAttribute("registerStatus", "seller-success");
                    } else {
                        request.setAttribute("registerStatus", "register-fail");
                    }
                } else {
                    request.setAttribute("registerStatus", "register-fail");
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("login_and_register.jsp");
            dispatcher.forward(request, response);
        } else if (request.getParameter("registerFrom").equals("adminRegister")) {
            user.setRole("admin");
            if (usersFacade.registerNewUser(user)){
                List<Users> userArr = usersFacade.findAll();
                HttpSession s = request.getSession();
                s.setAttribute("userList", userArr);
                Admins admin = new Admins();
                try{
                    admin.setId(adminsFacade.getLatestId() + 1);
                } catch (Exception e){
                    admin.setId(1L);
                }
                admin.setUser_id(usersFacade.getUserByEmail(email).getId());
                if (adminsFacade.registerNewAdmin(admin)){
                    request.setAttribute("registerStatus", "admin-success");
                } else {
                    request.setAttribute("registerStatus", "register-fail");
                }
            } else {
                request.setAttribute("registerStatus", "register-fail");
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("adminRegister.jsp");
            dispatcher.forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
