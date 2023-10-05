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
import Fascades.ReviewsFacade;
import Fascades.SellersFacade;
import Fascades.UsersFacade;
import Model.Carts;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.Category;
import Model.Customers;
import Model.Items;
import Model.Orders;
import Model.Reviews;
import Model.Sellers;
import Model.Users;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Chan01
 */
@WebServlet("/getDetails")
public class GetDetails extends HttpServlet {

    

    
    private static final long serialVersionUID = 1L;
    
    @EJB
    private ReviewsFacade reviewsFacade;
    
    @EJB
    private ItemsFacade itemsFacade;

    @EJB
    private CategoryFacade categoryFacade;
    
    @EJB
    private UsersFacade usersFacade;

    @EJB
    private OrdersFacade ordersFacade;

    @EJB
    private CartsFacade cartsFacade;

    @EJB
    private CustomersFacade customersFacade;

    @EJB
    private SellersFacade sellersFacade;
    
    @EJB
    private Favourite_sellersFacade favourite_sellersFacade;
    
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
        if (request.getAttribute("getItem") != null){
            try{
                Long category_id = Long.parseLong(request.getParameter("categoryId"));
                if (category_id != null){
                    List<Items> itemList = itemsFacade.retrieveItemsByCategoryId(category_id);
                    request.setAttribute("itemList", itemList);
                } else {
                    List<Items> itemList = itemsFacade.findAll();
                    request.setAttribute("itemList", itemList);
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("item_list.jsp");
                dispatcher.forward(request, response);
            } catch (Exception e){
                request.setAttribute("itemList", new ArrayList<>());
                RequestDispatcher dispatcher = request.getRequestDispatcher("item_list.jsp");
                dispatcher.forward(request, response);
            }
        }
        
        if (request.getParameter("itemIdForItemDetail") != null){
            try{
                String[] itemIdArray = request.getParameterValues("itemIdForItemDetail");
                Long item_id = Long.parseLong(itemIdArray[0]);
                String itemIdStr = item_id.toString();
                Items item = itemsFacade.find(item_id);
                request.setAttribute("product", item);
                
                Sellers seller = sellersFacade.find(item.getSeller_id());
                Users user = usersFacade.find(seller.getUser_id());
                request.setAttribute("sellerName", user.getUsername());
                request.setAttribute("sellerStatus", user.getRole());
                
                Long categoryId = Long.parseLong(String.valueOf(item.getCategory()));
                Category c = categoryFacade.find(categoryId);
                request.setAttribute("productCategory", c.getName());
                
                List<Reviews> reviewArr = reviewsFacade.retrieveAllReviewsByItemId(item_id);
                request.setAttribute("reviewForItem", reviewArr);
                
                
                
                if (request.getParameter("toEditItem") != null){
                    request.setAttribute("categoryId", categoryId);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("edit_item.jsp?id=" + itemIdStr);
                    dispatcher.forward(request, response);
                } else if (request.getParameter("toPayment") != null) {
                    int quantity = Integer.parseInt(request.getParameter("qty"));
                    RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp?itemId=" + itemIdStr + "&qty=" + quantity);
                    dispatcher.forward(request, response);
                } else {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp?itemid=" + item_id);
                    dispatcher.forward(request, response);
                }
            }   catch (Exception e){
                String[] itemIdArray = request.getParameterValues("itemIdForItemDetail");
                Long item_id = Long.parseLong(itemIdArray[0]);
                request.setAttribute("product", null);
                request.setAttribute("sellerName", null);
                request.setAttribute("sellerStatus", null);
                request.setAttribute("productCategory", null);
                request.setAttribute("categoryId", null);
                request.setAttribute("reviewForItem", null);
                if (request.getParameter("toEditItem") != null){
                    String itemIdStr = item_id.toString();
                    RequestDispatcher dispatcher = request.getRequestDispatcher("edit_item.jsp?id=" + itemIdStr);
                    dispatcher.forward(request, response);
                } else {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp?itemid=" + item_id);
                    dispatcher.forward(request, response);
                }
            }
        }
        
        if (request.getParameter("sellerIdForSellerDetail") != null){
            try{
                String[] str = request.getParameterValues("sellerIdForSellerDetail");
                Long seller_id = Long.parseLong(str[0]);
                
                Sellers seller = sellersFacade.find(seller_id);
                Users user = usersFacade.find(seller.getUser_id());
                List<Items> itemArr = itemsFacade.retrieveItemsBySellerId(seller_id);
                double total_earnings = ordersFacade.retrieveTotalEarningsOfSeller(seller_id);
                int totalItemsSold = itemsFacade.retrieveTotalItemsSoldBySeller(seller_id);
                
                request.setAttribute("detail", seller);
                request.setAttribute("userdetail", user);
                request.setAttribute("sellerItems", itemArr);
                request.setAttribute("totalItemSales", totalItemsSold);
                request.setAttribute("totalOrderEarnings", total_earnings);
                
                if (s.getAttribute("role").equals("customer")){
                    Customers customer = (Customers)s.getAttribute("userDetail");
                    if (favourite_sellersFacade.checkIfSellerIsCurrentCustomerFavourite(seller_id, customer.getId()) != null){
                        request.setAttribute("isFavo", "true");
                    } 
                }
                
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("seller_dashboard.jsp?sellerId=" + seller_id);
                dispatcher.forward(request, response);
                
            }   catch (Exception e){
                String[] str = request.getParameterValues("sellerIdForSellerDetail");
                Long seller_id = Long.parseLong(str[0]);
                
                Sellers seller = sellersFacade.find(seller_id);
                request.setAttribute("detail", null);
                request.setAttribute("userdetail", null);
                request.setAttribute("sellerItems", null);
                request.setAttribute("totalItemSales", null);
                request.setAttribute("totalOrderEarnings", null);
                RequestDispatcher dispatcher = request.getRequestDispatcher("seller_dashboard.jsp?sellerId=" + seller_id);
                dispatcher.forward(request, response);
            }
        }
        
        if (request.getParameter("userIdForSellerDetail") != null){
            try{
                String[] str = request.getParameterValues("userIdForSellerDetail");
                Long user_id = Long.parseLong(str[0]);
                
                Users user = usersFacade.find(user_id);
                Sellers seller = sellersFacade.retrieveSellerDetails(user_id);
                List<Items> itemArr = itemsFacade.retrieveItemsBySellerId(seller.getId());
                double total_earnings = ordersFacade.retrieveTotalEarningsOfSeller(seller.getId());
                int totalItemsSold = itemsFacade.retrieveTotalItemsSoldBySeller(seller.getId());
                
                request.setAttribute("detail", seller);
                request.setAttribute("userdetail", user);
                request.setAttribute("sellerItems", itemArr);
                request.setAttribute("totalItemSales", totalItemsSold);
                request.setAttribute("totalOrderEarnings", total_earnings);
                
                if (s.getAttribute("role").equals("customer")){
                    Customers customer = (Customers)s.getAttribute("userDetail");
                    if (favourite_sellersFacade.checkIfSellerIsCurrentCustomerFavourite(seller.getId(), customer.getId()) != null){
                        request.setAttribute("isFavo", "true");
                    } 
                }
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("seller_dashboard.jsp?userId=" + user_id);
                dispatcher.forward(request, response);
                
            }   catch (Exception e){
                String[] str = request.getParameterValues("userIdForSellerDetail");
                Long user_id = Long.parseLong(str[0]);
                
                Users user = usersFacade.find(user_id);
                request.setAttribute("detail", null);
                request.setAttribute("userdetail", null);
                request.setAttribute("sellerItems", null);
                request.setAttribute("totalItemSales", null);
                request.setAttribute("totalOrderEarnings", null);
                RequestDispatcher dispatcher = request.getRequestDispatcher("seller_dashboard.jsp?userId=" + user_id);
                dispatcher.forward(request, response);
            }
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
