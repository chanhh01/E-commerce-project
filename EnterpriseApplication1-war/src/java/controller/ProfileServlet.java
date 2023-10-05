/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import Fascades.CustomersFacade;
import Fascades.SellersFacade;
import Fascades.UsersFacade;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.Customers;
import Model.Users;
import Model.Sellers;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Objects;

/**
 *
 * @author User
 */
@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @EJB
    private SellersFacade sellersFacade;

    @EJB
    private UsersFacade usersFacade;

    @EJB
    private CustomersFacade customersFacade;

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
        HttpSession s = request.getSession();
        Users user = (Users)s.getAttribute("user");
        String role = s.getAttribute("role").toString();
        String editFor = request.getParameter("editFor");
        
        if (editFor != null){
            if (editFor.equals("editOwnProfile")){
            user.setUsername(request.getParameter("username"));
            String email = request.getParameter("email");
            if (usersFacade.getUserByEmail(email).getId().compareTo(user.getId()) != 0){
                request.setAttribute("editStatus", "duplicateEmail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
            } else {
                user.setEmail(email);
                user.setProfile_img(request.getParameter("imgUrl"));
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                user.setUpdated_at(timestampNow);
                
                if (usersFacade.updateUser(user)){
                    s.setAttribute("user", user);
                    
                    if (role.equals("customer")){
                        Customers cust = (Customers)s.getAttribute("userDetail");
                        cust.setContact_no(request.getParameter("contactCust"));
                        cust.setBilling_address(request.getParameter("billing"));
                        cust.setShipping_address(request.getParameter("shipping"));
                        cust.setDate_of_birth(request.getParameter("dob"));
                    
                        if (customersFacade.updateCustomer(cust)){
                            s.setAttribute("userDetail", cust);
                            request.setAttribute("editStatus", "editSuccess");
                        } else {
                            request.setAttribute("editStatus", "editFailed");
                        }
                    } else if (role.equals("seller")){
                        Sellers seller = (Sellers)s.getAttribute("userDetail");
                        seller.setContact_no(request.getParameter("contactSeller"));
                        seller.setAddress(request.getParameter("address"));
                        seller.setDescription(request.getParameter("description"));
                        
                        if (sellersFacade.updateSeller(seller)){
                            s.setAttribute("userDetail", seller);
                            request.setAttribute("editStatus", "editSuccess");
                        } else {
                            request.setAttribute("editStatus", "editFailed");
                        }
                    }
                } else {
                    request.setAttribute("editStatus", "editFailed");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
            }
            
        } else if (editFor.equals("editPassword")){
            
            if (user.getPassword().equals(request.getParameter("oldPass"))){
                user.setPassword(request.getParameter("newPass"));
                if (usersFacade.updateUser(user)){
                    s.setAttribute("user", user);
                    request.setAttribute("passStatus", "editSuccess");

                    if(s.getAttribute("role").equals("admin")){
                        List<Users> newUserArr = usersFacade.findAll();
                        s.setAttribute("userList", newUserArr);
                    } 
                    
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                } else {
                    request.setAttribute("passStatus", "editFailed");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                request.setAttribute("passStatus", "wrongPass");
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
            }
        } else if (editFor.equals("adminEditProfile")){
            Long user_id = Long.parseLong(request.getParameter("currUserId"));
            Users targetuser = usersFacade.find(user_id);
            targetuser.setUsername(request.getParameter("username"));
            String email = request.getParameter("email");
            if (usersFacade.getUserByEmail(email).getId().compareTo(user_id) != 0){
                request.setAttribute("editStatus", "duplicateEmail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp?userid=" + user.getId() + "&roleDetail=" + user.getRole());
                dispatcher.forward(request, response);
            } else {
                targetuser.setEmail(email);
                targetuser.setProfile_img(request.getParameter("imgUrl"));
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                targetuser.setUpdated_at(timestampNow);
                
                if (usersFacade.updateUser(targetuser)){
                    List<Users> newUserArr = usersFacade.findAll();
                    s.setAttribute("userList", newUserArr);
                    
                    if (targetuser.getRole().equals("customer")){
                        Customers targetcust = customersFacade.retrieveCustomerDetails(user_id);
                        targetcust.setContact_no(request.getParameter("contactCust"));
                        targetcust.setBilling_address(request.getParameter("billing"));
                        targetcust.setShipping_address(request.getParameter("shipping"));
                        targetcust.setDate_of_birth(request.getParameter("dob"));
                    
                        if (customersFacade.updateCustomer(targetcust)){
                            List<Customers> customerArr = customersFacade.findAll();
                            s.setAttribute("custList", customerArr);
                            request.setAttribute("editStatus", "editSuccess");
                        } else {
                            request.setAttribute("editStatus", "editFailed");
                        }
                    } else if (targetuser.getRole().equals("seller")){
                        Sellers targetseller = sellersFacade.retrieveSellerDetails(user_id);
                        targetseller.setContact_no(request.getParameter("contactSeller"));
                        targetseller.setAddress(request.getParameter("address"));
                        targetseller.setDescription(request.getParameter("description"));
                        
                        if (sellersFacade.updateSeller(targetseller)){
                            List<Sellers> sellersArr = sellersFacade.findAll();
                            s.setAttribute("sellerList", sellersArr);
                            request.setAttribute("editStatus", "editSuccess");
                        } else {
                            request.setAttribute("editStatus", "editFailed");
                        }
                    }
                } else {
                    request.setAttribute("editStatus", "editFailed");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp?userid=" + targetuser.getId() + "&roleDetail=" + targetuser.getRole());
                dispatcher.forward(request, response);
            }
            
        } else if (editFor.equals("adminEditOwnProfile")){
            user.setUsername(request.getParameter("username"));
            String email = request.getParameter("email");
            if (usersFacade.getUserByEmail(email).getId().compareTo(user.getId()) != 0){
                request.setAttribute("editStatus", "duplicateEmail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
            } else {
                user.setEmail(email);
                user.setProfile_img(request.getParameter("imgUrl"));
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                user.setUpdated_at(timestampNow);
                
                if (usersFacade.updateUser(user)){
                    s.setAttribute("user", user);
                    List<Users> userList = usersFacade.findAll();
                    s.setAttribute("userList", userList);
                    request.setAttribute("editStatus", "editSuccess");
                } else {
                    request.setAttribute("editStatus", "editFailed");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
            }
        }
        
    } else if (request.getParameter("action") != null) {
        Long userid = Long.parseLong(request.getParameter("userId"));
        String action = request.getParameter("action");
        Users targetuser = usersFacade.find(userid);
        
        try{
            if (action.equals("unsuspend")){
            String currRole = targetuser.getRole();
            if (currRole.equals("suspendedCust")){
                targetuser.setRole("customer");
            } else if (currRole.equals("suspendedSeller")){
                targetuser.setRole("seller");
            }
            LocalDateTime now = LocalDateTime.now();
            Timestamp timestampNow = Timestamp.valueOf(now);
            targetuser.setUpdated_at(timestampNow);
            if (usersFacade.updateUser(targetuser)){
                List<Users> newUserArr = usersFacade.findAll();
                s.setAttribute("userList", newUserArr);
                request.setAttribute("adminEdit", "unsuspendSuccess");
            } else {
                request.setAttribute("adminEdit", "fail");
            }
        } else if (action.equals("suspend")){
            String currRole = targetuser.getRole();
            if (currRole.equals("customer")){
                targetuser.setRole("suspendedCust");
            } else if (currRole.equals("seller")){
                targetuser.setRole("suspendedSeller");
            }
            LocalDateTime now = LocalDateTime.now();
            Timestamp timestampNow = Timestamp.valueOf(now);
            targetuser.setUpdated_at(timestampNow);
            if (usersFacade.updateUser(targetuser)){
                List<Users> newUserArr = usersFacade.findAll();
                s.setAttribute("userList", newUserArr);
                request.setAttribute("adminEdit", "suspendSuccess");
            } else {
                request.setAttribute("adminEdit", "fail");
            }
        } else if (action.equals("approve")){
            targetuser.setRole("seller");
            LocalDateTime now = LocalDateTime.now();
            Timestamp timestampNow = Timestamp.valueOf(now);
            targetuser.setUpdated_at(timestampNow);
            if (usersFacade.updateUser(targetuser)){
                List<Users> newUserArr = usersFacade.findAll();
                s.setAttribute("userList", newUserArr);
                
                List<Users> newPendingSellerArr = usersFacade.retrievePendingSellers();
                s.setAttribute("pendingSellers", newPendingSellerArr);
                
                request.setAttribute("adminEdit", "approveSuccess");
            } else {
                request.setAttribute("adminEdit", "fail");
            }
        } else if (action.equals("reject")){
            Sellers seller = sellersFacade.retrieveSellerDetails(targetuser.getId());
            sellersFacade.remove(seller);
            usersFacade.remove(targetuser);
            List<Users> newUserArr = usersFacade.findAll();
            s.setAttribute("userList", newUserArr);
            List<Sellers> newSellerArr = sellersFacade.findAll();
            s.setAttribute("sellerList", newSellerArr);
            List<Users> pendingArr = usersFacade.retrievePendingSellers();
            s.setAttribute("pendingSellers", pendingArr);
            request.setAttribute("adminEdit", "rejectSuccess");
        }
        
        if (request.getParameter("fromPending") != null){
            RequestDispatcher dispatcher = request.getRequestDispatcher("pendingSeller.jsp");
            dispatcher.forward(request, response);
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("user_list.jsp");
            dispatcher.forward(request, response);
        }
        } catch (Exception e){
            request.setAttribute("adminEdit", "fail");
            if (request.getParameter("fromPending") != null){
                RequestDispatcher dispatcher = request.getRequestDispatcher("pendingSeller.jsp");
                dispatcher.forward(request, response);
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("user_list.jsp");
                dispatcher.forward(request, response);
            }
        }
    } else {
        request.setAttribute("editStatus", "editFailed");
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
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
