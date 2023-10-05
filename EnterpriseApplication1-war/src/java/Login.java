/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import Fascades.CartsFacade;
import Fascades.CategoryFacade;
import Fascades.CustomersFacade;
import Fascades.Favourite_sellersFacade;
import Fascades.ItemsFacade;
import Fascades.OrdersFacade;
import Fascades.Review_repliesFacade;
import Fascades.ReviewsFacade;
import Fascades.SellersFacade;
import Fascades.UsersFacade;
import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.*;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Chan01
 */
@WebServlet(urlPatterns = {"/Login"})
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @EJB
    private ReviewsFacade reviewsFacade;

    @EJB
    private Review_repliesFacade review_repliesFacade;

    @EJB
    private OrdersFacade ordersFacade;

    @EJB
    private ItemsFacade itemsFacade;

    @EJB
    private Favourite_sellersFacade favourite_sellersFacade;

    @EJB
    private CategoryFacade categoryFacade;
    
    @EJB
    private CartsFacade cartsFacade;
    
    @EJB
    private SellersFacade sellersFacade;
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
        HttpSession s = request.getSession();
        String email = request.getParameter("email");
        String password = request.getParameter("pswd");
        
        Users user = usersFacade.verifyUsers(email, password);

        if (user != null){
            if (user.getRole().equals("pending")){
                request.setAttribute("loginStatus", "pending");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login_and_register.jsp");
                dispatcher.forward(request, response);
            } else if (user.getRole().equals("suspendedCust") || user.getRole().equals("suspendedSeller")){
                request.setAttribute("loginStatus", "suspended");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login_and_register.jsp");
                dispatcher.forward(request, response);
            } else {
                s.setAttribute("user", user);
                switch (user.getRole()){
                    case "admin":
                        s.setAttribute("role", "admin");
                        break;
                    case "customer":
                        Customers cust = customersFacade.retrieveCustomerDetails(user.getId());
                        s.setAttribute("userDetail", cust);
                        s.setAttribute("role", "customer");
                        break;
                    case "seller":
                        Sellers seller = sellersFacade.retrieveSellerDetails(user.getId());
                        s.setAttribute("userDetail", seller);
                        s.setAttribute("role", "seller");
                        break;
                }
            s.setAttribute("auth", "auth");
            
            List<Users> userList = usersFacade.findAll();
            List<Customers> custList = customersFacade.findAll();
            List<Sellers> sellerList = sellersFacade.findAll();
            List<Carts> cartList = cartsFacade.findAll();
            List<Items> itemList = itemsFacade.findAll();
            List<Category> categoryList = categoryFacade.findAll();
            List<Favourite_sellers> favoSellerList = favourite_sellersFacade.findAll();
            List<Orders> orderList = ordersFacade.findAll();
            List<Reviews> reviewList = reviewsFacade.findAll();
            List<Review_replies> replyList = review_repliesFacade.findAll();

            s.setAttribute("userList", userList);
            s.setAttribute("custList", custList);
            s.setAttribute("sellerList", sellerList);
            s.setAttribute("itemList", itemList);
            s.setAttribute("cartList", cartList);
            s.setAttribute("categoryList", categoryList);
            s.setAttribute("favoSellerList", favoSellerList);
            s.setAttribute("orderList", orderList);
            s.setAttribute("reviewList", reviewList);
            s.setAttribute("replyList", replyList);

            if (s.getAttribute("role").equals("customer")){

                Customers cust = (Customers)s.getAttribute("userDetail");

                cartList = cartsFacade.retrieveAllCartsOfCustomer(cust.getId());
                s.setAttribute("cartList", cartList);

                orderList = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                s.setAttribute("orderList", orderList);

                List<Users> favoSellers = favourite_sellersFacade.retrieveAllFavouriteSellersByCustomerId(cust.getId());
                s.setAttribute("favoSellerByCust", favoSellers);

            } else if (s.getAttribute("role").equals("seller")){

                Sellers seller = (Sellers)s.getAttribute("userDetail");

                itemList = itemsFacade.retrieveItemsBySellerId(seller.getId());
                s.setAttribute("itemList", itemList);

                orderList = ordersFacade.retrieveAllOrdersOfSellers(seller.getId());
                s.setAttribute("orderList", orderList);

                List<Orders> YetToShipOrders = ordersFacade.retrieveOrdersYetToShipBySeller(seller.getId());
                s.setAttribute("yetToShip", YetToShipOrders);

            } else if (s.getAttribute("role").equals("admin")){

                List<Users> pendingSellers = usersFacade.retrievePendingSellers();
                s.setAttribute("pendingSellers", pendingSellers);
                
                List<Users> topThreeSellers = sellersFacade.retrieveTopThreeSellersByCredit();
                s.setAttribute("topThreeSellers", topThreeSellers);
                
                List<Items> topThreeItemsBySales = itemsFacade.retrieveTopThreeItemsWithCertainConditions("sales");
                List<Items> topThreeItemsByRating = itemsFacade.retrieveTopThreeItemsWithCertainConditions("rating");
                s.setAttribute("topThreeItemsBySales", topThreeItemsBySales);
                s.setAttribute("topThreeItemsByRating", topThreeItemsByRating);
            }
            
            request.setAttribute("loginStatus", "yes");
            RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
            dispatcher.forward(request, response);
            }
        } else {
            s.invalidate();
            request.setAttribute("loginStatus", "no");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login_and_register.jsp");
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
