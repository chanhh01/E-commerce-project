/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import Fascades.ItemsFacade;
import Fascades.OrdersFacade;
import Fascades.Review_repliesFacade;
import Fascades.ReviewsFacade;
import Fascades.SellersFacade;
import Model.Customers;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.Items;
import Model.Sellers;
import Model.Reviews;
import Model.Review_replies;
import Model.Orders;
import Model.Users;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import javax.ejb.EJB;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Set;
import javax.servlet.RequestDispatcher;
/**
 *
 * @author Chan01
 */
@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    @EJB
    private Review_repliesFacade review_repliesFacade;

    @EJB
    private ReviewsFacade reviewsFacade;

    @EJB
    private OrdersFacade ordersFacade;

    @EJB
    private ItemsFacade itemsFacade;

    @EJB
    private SellersFacade sellersFacade;

    
    
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
        
        if (request.getParameter("orderId") != null){
            Long orderId = Long.parseLong(request.getParameter("orderId"));
            Orders order = ordersFacade.find(orderId);
            Users user = (Users)s.getAttribute("user");
            Customers cust = (Customers)s.getAttribute("userDetail");
            
            Reviews review = new Reviews();
            try{
                
                try{
                    review.setId(reviewsFacade.getLatestId() + 1);
                } catch (Exception e){
                    review.setId(1L);
                }
                
                review.setItem_id(order.getItem_id());
                review.setCustomer_id(order.getCustomer_id());
                review.setUserImg(user.getProfile_img());
                review.setUsername(user.getUsername());
                
                int rating = Integer.parseInt(request.getParameter("finalRating"));
                
                review.setRating(rating);
                review.setComment(request.getParameter("feedback"));
                
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                review.setCreated_at(timestampNow);
                
                if (reviewsFacade.createReview(review)){
                    
                    List<Reviews> reviewArr = reviewsFacade.findAll();
                    s.setAttribute("reviewList", reviewArr);
                    order.setStatus("completed");
                    order.setUpdated_at(timestampNow);
                    if (ordersFacade.updateOrder(order)){
                        
                        List<Orders> orderArr = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                        s.setAttribute("orderList", orderArr);
                        
                        Items item = itemsFacade.find(order.getItem_id());
                        double newItemRating = reviewsFacade.calculateNewRatingForItem(item.getId());
                        item.setAvg_rating(newItemRating);
                        
                        if (itemsFacade.updateItem(item)){
                            List<Items> itemArr = itemsFacade.findAll();
                            s.setAttribute("itemList", itemArr);
                            
                            Sellers seller = sellersFacade.find(item.getSeller_id());
                            double newSellerCredit = itemsFacade.getAvgRatingOfItemsUnderSameSeller(seller.getId());
                            seller.setCredit_points(newSellerCredit);
                            
                            if (sellersFacade.updateSeller(seller)){
                                List<Sellers> sellerArr = sellersFacade.findAll();
                                s.setAttribute("sellerList", sellerArr);
                                request.setAttribute("reviewStat", "success");
                            } else {
                                request.setAttribute("reviewStat", "fail");
                            }
                            
                        } else {
                            request.setAttribute("reviewStat", "fail");
                        }
                    }
                    
                } else {
                    request.setAttribute("reviewStat", "fail");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                dispatcher.forward(request, response);
            } catch (Exception e){
                request.setAttribute("reviewStat", "fail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                dispatcher.forward(request, response);
            }
        }
        
        if (request.getParameter("reviewId") != null){
            Long reviewId = Long.parseLong(request.getParameter("reviewId"));
            Reviews review = reviewsFacade.find(reviewId);
            Users user = (Users)s.getAttribute("user");
            String reply = request.getParameter("reply");
            
            Review_replies rr = new Review_replies();
            
            try{
                
                try{
                    rr.setId(review_repliesFacade.getLatestId() + 1);
                } catch (Exception e){
                    rr.setId(1L);
                }
                
                rr.setReview_id(reviewId);
                rr.setUserImg(user.getProfile_img());
                rr.setUser_id(user.getId());
                rr.setUsername(user.getUsername());
                
                if (user.getRole().equals("customer")){
                    rr.setUserRole("Customer");
                } else if (user.getRole().equals("seller")){
                    rr.setUserRole("Seller");
                } else if (user.getRole().equals("admin")){
                    rr.setUserRole("Administrator Staff");
                } else {
                    rr.setUserRole("Suspended User");
                }

                rr.setComment(reply);
                
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                rr.setCreated_at(timestampNow);
                
                if (review_repliesFacade.createReview_reply(rr)){
                    List<Review_replies> rrArr = review_repliesFacade.findAll();
                    s.setAttribute("replyList", rrArr);
                    request.setAttribute("replyStat", "success");
                } else {
                    request.setAttribute("replyStat", "fail");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp?itemid=" + review.getItem_id());
                dispatcher.forward(request, response);
            } catch (Exception e){
                request.setAttribute("replyStat", "fail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp?itemid=" + review.getItem_id());
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
