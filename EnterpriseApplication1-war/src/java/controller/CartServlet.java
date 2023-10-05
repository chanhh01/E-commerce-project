/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import Fascades.CartsFacade;
import Fascades.ItemsFacade;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import Model.Carts;
import Model.Customers;
import Model.Items;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Chan01
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @EJB
    private ItemsFacade itemsFacade;

    @EJB
    private CartsFacade cartsFacade;

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
        
        if (request.getParameter("itemId") != null && request.getParameter("qty") != null){
            String[] itemIdArray = request.getParameterValues("itemId");
            String result = "";
            int qty = Integer.parseInt(request.getParameter("qty"));
            Long item_id = Long.parseLong(itemIdArray[0]);
            String itemIdStr = item_id.toString();
            Customers cust = (Customers)s.getAttribute("userDetail");
            
            Carts existingCart = cartsFacade.getCartWithSameCustomerAndItem(cust.getId(), item_id);
            if (existingCart != null){
                int existingQty = existingCart.getQuantity();
                existingCart.setQuantity(existingQty + qty);
                
                if (cartsFacade.updateCart(existingCart)){
                    request.setAttribute("addCart", "appended");
                    List<Carts> newCartArr = cartsFacade.retrieveAllCartsOfCustomer(cust.getId());
                    s.setAttribute("cartList", newCartArr);
                } else {
                    request.setAttribute("addCart", "fail");
                }
            } else {
                Carts cart = new Carts();
                Items item = itemsFacade.find(item_id);
                try{
                    cart.setId(cartsFacade.getLatestId() + 1);
                } catch (Exception e){
                    cart.setId(1L);
                }
                cart.setItem_id(item_id);
                cart.setCustomer_id(cust.getId());
                cart.setQuantity(qty);

                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                cart.setCreated_at(timestampNow);
                cart.setPrice_per_item(item.getDiscountedPrice(item));

                if (cartsFacade.createCart(cart)){
                    request.setAttribute("addCart", "success");
                    List<Carts> newCartArr = cartsFacade.retrieveAllCartsOfCustomer(cust.getId());
                    s.setAttribute("cartList", newCartArr);
                } else {
                    request.setAttribute("addCart", "fail");
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
            dispatcher.forward(request, response);
        }
        
        if (request.getParameter("cartId") != null && request.getParameter("action") != null){
            try{
                String[] cartIdArray = request.getParameterValues("cartId");
                Long cart_id = Long.parseLong(cartIdArray[0]);
                Carts cart = cartsFacade.find(cart_id);
                if (request.getParameter("action").equals("delete")){
                    cartsFacade.deleteCart(cart);
                    request.setAttribute("deleteCart", "success");
                    Customers cust = (Customers)s.getAttribute("userDetail");
                    List<Carts> newCartArr = cartsFacade.retrieveAllCartsOfCustomer(cust.getId());
                    s.setAttribute("cartList", newCartArr);
                }
            } catch(Exception e){
                request.setAttribute("deleteCart", "fail");
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
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
