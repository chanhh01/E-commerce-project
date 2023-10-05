/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;


import Fascades.CartsFacade;
import Fascades.ItemsFacade;
import Fascades.OrdersFacade;
import java.io.IOException;
import javax.ejb.EJB;
import Model.Carts;
import Model.Customers;
import Model.Items;
import Model.Orders;
import Model.Sellers;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.HashSet;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import javax.servlet.http.HttpSession;

/**
 *
 * @author User
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @EJB
    private ItemsFacade itemsFacade;

    @EJB
    private OrdersFacade ordersFacade;

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
        String action = request.getParameter("action");
        if(action != null && action.equals("checkoutCarts")){
            Object obj = s.getAttribute("cartList");
            Customers cust = (Customers)s.getAttribute("userDetail");
            if (obj instanceof List<?>) {
                List<Carts> cartArr = (List<Carts>) obj;
                try{
                    for (Carts cart : cartArr){
                        Orders order = new Orders();
                        
                        Items item = itemsFacade.find(cart.getItem_id());
                        int itemQty = item.getQuantity();
                        
                        if (itemQty == 0){
                            break;
                        } else {
                            try{
                                order.setId(ordersFacade.getLatestId() + 1);
                            } catch (Exception e){
                                order.setId(1L);
                            }
                            
                            int qty = cart.getQuantity();
                            
                            if (itemQty < qty){
                                int finalqty = qty - itemQty;
                                double item_price = cart.getPrice_per_item();
                                double total_price = item_price*itemQty;
                                
                                DecimalFormat df = new DecimalFormat("#0.00");
                                String formattedNumber = df.format(total_price);
                                total_price = Double.parseDouble(formattedNumber);

                                order.setItem_id(cart.getItem_id());
                                order.setCustomer_id(cart.getCustomer_id());
                                order.setQuantity(itemQty);
                                order.setItem_price(item_price);
                                order.setTotal_price(total_price);
                                order.setStatus("to ship");

                                LocalDateTime now = LocalDateTime.now();
                                Timestamp timestampNow = Timestamp.valueOf(now);
                                order.setCreated_at(timestampNow);
                                order.setUpdated_at(timestampNow);

                                if (ordersFacade.createOrder(order)){
                                    item.setQuantity(0);
                                    cart.setQuantity(finalqty);
                                    
                                    if (itemsFacade.updateItem(item)){
                                        List<Items> newItemArr = itemsFacade.findAll();
                                        s.setAttribute("itemList", newItemArr);
                                    }
                                    
                                    if (cartsFacade.updateCart(cart)){
                                        request.setAttribute("orderCreationStatus", "success");
                                    } else {
                                        request.setAttribute("orderCreationStatus", "fail");
                                    } 
                                } else {
                                    request.setAttribute("orderCreationStatus", "fail");
                                    break;
                                }
                                
                            } else {
                                double item_price = cart.getPrice_per_item();
                                double total_price = item_price*qty;

                                DecimalFormat df = new DecimalFormat("#0.00");
                                String formattedNumber = df.format(total_price);
                                total_price = Double.parseDouble(formattedNumber);

                                order.setItem_id(cart.getItem_id());
                                order.setCustomer_id(cart.getCustomer_id());
                                order.setQuantity(cart.getQuantity());
                                order.setItem_price(item_price);
                                order.setTotal_price(total_price);
                                order.setStatus("to ship");

                                LocalDateTime now = LocalDateTime.now();
                                Timestamp timestampNow = Timestamp.valueOf(now);
                                order.setCreated_at(timestampNow);
                                order.setUpdated_at(timestampNow);

                                
                                if (ordersFacade.createOrder(order)){
                                    item.setQuantity(itemQty - qty);

                                    if (itemsFacade.updateItem(item)){
                                        List<Items> newItemArr = itemsFacade.findAll();
                                        s.setAttribute("itemList", newItemArr);
                                    }

                                    request.setAttribute("orderCreationStatus", "success");
                                    cartsFacade.deleteCart(cart);
                                } else {
                                    request.setAttribute("orderCreationStatus", "fail");
                                    break;
                                }
                            }
                        } 
                    }
                    List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                    s.setAttribute("orderList", newOrderArr);
                    List<Carts> newCartArr = cartsFacade.retrieveAllCartsOfCustomer(cust.getId());
                    s.setAttribute("cartList", newCartArr);          
                    RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                    dispatcher.forward(request, response);
                    
                } catch (Exception e){
                    List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                    s.setAttribute("orderList", newOrderArr);
                    List<Carts> newCartArr = cartsFacade.retrieveAllCartsOfCustomer(cust.getId());
                    s.setAttribute("cartList", newCartArr);
                    request.setAttribute("orderCreationStatus", "fail");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                request.setAttribute("orderCreationStatus", "fail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
                dispatcher.forward(request, response);
            }
        } else if (request.getParameter("itemId") != null && request.getParameter("qty") != null) {
            Long item_id = Long.parseLong(request.getParameter("itemId"));
            String itemIdStr = item_id.toString();
            Items item = itemsFacade.find(item_id);
            int quantity = Integer.parseInt(request.getParameter("qty"));
            Customers cust = (Customers)request.getSession().getAttribute("userDetail");
            Orders order = new Orders();
            
            try{
                order.setId(ordersFacade.getLatestId() + 1);
            } catch (Exception e){
                order.setId(1L);
            }
            
            try{
                double item_price = item.getDiscountedPrice(item);
                double total_price = item_price*quantity;
                
                DecimalFormat df = new DecimalFormat("#0.00");
                String formattedNumber = df.format(total_price);
                total_price = Double.parseDouble(formattedNumber);
                
                order.setItem_id(item_id);
                order.setCustomer_id(cust.getId());
                order.setQuantity(quantity);
                order.setItem_price(item_price);
                order.setTotal_price(total_price);
                order.setStatus("to ship");
                
                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                order.setCreated_at(timestampNow);
                order.setUpdated_at(timestampNow);
                
                if (ordersFacade.createOrder(order)){
                    request.setAttribute("orderCreationStatus", "successPayment");
                    List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                    s.setAttribute("orderList", newOrderArr);
                    
                    int itemQty = item.getQuantity();
                    item.setQuantity(itemQty - quantity);
                    
                    if (itemsFacade.updateItem(item)){
                        List<Items> newItemArr = itemsFacade.findAll();
                        s.setAttribute("itemList", newItemArr);
                    } 
                    RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                    dispatcher.forward(request, response);
                } else {
                    request.setAttribute("orderCreationStatus", "failPayment");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp?itemid=" + itemIdStr);
                    dispatcher.forward(request, response);
                }    
            } catch (Exception e){
                request.setAttribute("orderCreationStatus", "fail");
                RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp?itemid=" + itemIdStr);
                dispatcher.forward(request, response);
            }
        } else if (request.getParameter("orderId") != null){
            Long order_id = Long.parseLong(request.getParameter("orderId"));
            Orders order = ordersFacade.find(order_id);
            
            if (request.getParameter("action").equals("shipOrder")){
                order.setStatus("to receive");
                Sellers seller = (Sellers)s.getAttribute("userDetail");
                
                if(ordersFacade.updateOrder(order)){
                    request.setAttribute("updateOrder", "shipped");
                    List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersOfSellers(seller.getId());
                    List<Orders> newYetToShip = ordersFacade.retrieveOrdersYetToShipBySeller(seller.getId());
                    s.setAttribute("orderList", newOrderArr);
                    s.setAttribute("yetToShip", newYetToShip);
                } else {
                    request.setAttribute("updateOrder", "fail");
                }
                
                if(request.getParameter("from").equals("orderJsp")){
                    RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                    dispatcher.forward(request, response);
                } else if(request.getParameter("from").equals("shipmentJsp")){
                    RequestDispatcher dispatcher = request.getRequestDispatcher("shipment.jsp");
                    dispatcher.forward(request, response);
                }
                
            } else if (request.getParameter("action").equals("cancelOrder")){
                order.setStatus("cancelled");
                Customers cust = (Customers)request.getSession().getAttribute("userDetail");
                
                try{
                    if (ordersFacade.updateOrder(order)){
                        Items item = itemsFacade.find(order.getItem_id());
                        int qty = item.getQuantity();
                        item.setQuantity(qty + order.getQuantity());

                        List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                        s.setAttribute("orderList", newOrderArr);
                        
                        if (itemsFacade.updateItem(item)){
                            request.setAttribute("updateOrder", "cancelled");
                            List<Items> newItemArr = itemsFacade.findAll();
                            s.setAttribute("itemList", newItemArr);
                        }
                        RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                    dispatcher.forward(request, response);
                    }
                } catch (Exception e){
                    request.setAttribute("updateOrder", "fail");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                    dispatcher.forward(request, response);
                }
                

            } else if (request.getParameter("action").equals("receiveOrder")){
                
                order.setStatus("to rate");
                Customers cust = (Customers)request.getSession().getAttribute("userDetail");
                
                try{
                    if (ordersFacade.updateOrder(order)){

                        List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersByCustomer(cust.getId());
                        s.setAttribute("orderList", newOrderArr);
                        request.setAttribute("updateOrder", "received");
                        
                        Items item = itemsFacade.find(order.getItem_id());
                        int orderQty = order.getQuantity();
                        int soldqty = item.getSold_qty();
                        item.setSold_qty(soldqty + orderQty);
                        
                        if (itemsFacade.updateItem(item)){
                            List<Items> itemArr = itemsFacade.findAll();
                            s.setAttribute("itemList", itemArr);
                        }
                        RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                        dispatcher.forward(request, response);
                    }
                } catch (Exception e){
                    request.setAttribute("updateOrder", "fail");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                    dispatcher.forward(request, response);
                }
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
