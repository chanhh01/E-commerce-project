/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import Fascades.Favourite_sellersFacade;
import Fascades.SellersFacade;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.Customers;
import Model.Sellers;
import Model.Favourite_sellers;
import Model.Users;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import javax.ejb.EJB;
import javax.servlet.http.HttpSession;
import java.util.List;
import javax.servlet.RequestDispatcher;

/**
 *
 * @author Chan01
 */
@WebServlet("/follow")
public class FollowServlet extends HttpServlet {

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
        
        if (request.getParameter("sellerId") != null){
            if (request.getParameter("action").equals("follow")){
                Long seller_id = Long.parseLong(request.getParameter("sellerId"));
                Sellers seller = sellersFacade.find(seller_id);
                Customers cust = (Customers)s.getAttribute("userDetail");

                Favourite_sellers fs = new Favourite_sellers();

                try{
                    fs.setId(favourite_sellersFacade.getLatestId() + 1);
                } catch (Exception e){
                    fs.setId(1L);
                }

                fs.setSeller_id(seller_id);
                fs.setCustomer_id(cust.getId());
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                fs.setCreated_at(timestampNow);

                if (favourite_sellersFacade.createFav_seller(fs)){
                    List<Users> fsArr = favourite_sellersFacade.retrieveAllFavouriteSellersByCustomerId(cust.getId());
                    s.setAttribute("favoSellerByCust", fsArr);

                    int oriFollowCount = seller.getFollowers();
                    seller.setFollowers(oriFollowCount + 1);

                    if (sellersFacade.updateSeller(seller)){
                        List<Sellers> sellerArr = sellersFacade.findAll();
                        s.setAttribute("sellerList", sellerArr);
                        request.setAttribute("followStat", "success");
                    } else {
                        request.setAttribute("followStat", "fail");
                    }
                } else {
                    request.setAttribute("followStat", "fail");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("seller_dashboard.jsp?sellerId" + seller_id);
                dispatcher.forward(request, response);
            } else if (request.getParameter("action").equals("unfollow")){
                Long seller_id = Long.parseLong(request.getParameter("sellerId"));
                Sellers seller = sellersFacade.find(seller_id);
                Customers cust = (Customers)s.getAttribute("userDetail");

                Favourite_sellers fs = favourite_sellersFacade.checkIfSellerIsCurrentCustomerFavourite(seller_id, cust.getId());
                
                if (fs != null){
                    favourite_sellersFacade.deleteFav_seller(fs);
                    List<Users> fsArr = favourite_sellersFacade.retrieveAllFavouriteSellersByCustomerId(cust.getId());
                    s.setAttribute("favoSellerByCust", fsArr);
                    
                    int oriFollowCount = seller.getFollowers();
                    seller.setFollowers(oriFollowCount - 1);

                    if (sellersFacade.updateSeller(seller)){
                        List<Sellers> sellerArr = sellersFacade.findAll();
                        s.setAttribute("sellerList", sellerArr);
                        request.setAttribute("followStat", "unfollowSuccess");
                    } else {
                        request.setAttribute("followStat", "fail");
                    }
                } else {
                    request.setAttribute("followStat", "fail");
                }
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("seller_dashboard.jsp?sellerId" + seller_id);
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
