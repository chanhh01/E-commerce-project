/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import Fascades.CategoryFacade;
import Fascades.ItemsFacade;
import Fascades.OrdersFacade;
import Fascades.SellersFacade;
import Fascades.UsersFacade;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Model.Items;
import Model.Sellers;
import Model.Orders;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
/**
 *
 * @author User
 */
@WebServlet("/ItemServlet")
public class ItemServlet extends HttpServlet {

    
    private static final long serialVersionUID = 1L;
    @EJB
    private CategoryFacade categoryFacade;

    @EJB
    private UsersFacade usersFacade;

    @EJB
    private SellersFacade sellersFacade;

    @EJB
    private ItemsFacade itemsFacade;

    @EJB
    private OrdersFacade ordersFacade;
    
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
        
        if (request.getParameter("searchResult") != null && !request.getParameter("searchResult").isEmpty()){
            String itemSimilarName = request.getParameter("searchResult");
            List<Items> itemArr = itemsFacade.retrieveItemsWithSimilarNames(itemSimilarName);
            request.setAttribute("resItemList", itemArr);
            RequestDispatcher dispatcher = request.getRequestDispatcher("searchItemList.jsp");
            dispatcher.forward(request, response);
        }
        
        if(request.getParameter("itemId") != null && request.getParameter("action") != null){
            if (request.getParameter("action").equals("deleteItem")){
                Long itemid = Long.parseLong(request.getParameter("itemId"));
                Items item = itemsFacade.find(itemid);
                
                try{
                    //make sure that all item order has been completed (if got any orders that are not cancelled, completed and to rate, then cannot proceed)
                    List<Orders> yetToShipOrders = ordersFacade.retrieveOrdersYetToShipBySeller(item.getSeller_id());
                    List<Orders> yetToReceiveOrders = ordersFacade.retrieveOrdersToSellerYetToBeReceived(item.getSeller_id());

                    if (yetToShipOrders.size() > 0){
                        request.setAttribute("deleteStatus", "haveYetToShip");
                    } else {
                        if (yetToReceiveOrders.size() > 0){
                            request.setAttribute("deleteStatus", "haveYetToReceive");
                        } else {
                            ordersFacade.deleteOrdersByItemId(itemid);
                            List<Orders> newOrderArr = ordersFacade.retrieveAllOrdersOfSellers(item.getSeller_id());
                            itemsFacade.deleteItem(item);
                            List<Items> newItemArr = itemsFacade.retrieveItemsBySellerId(item.getSeller_id());

                            s.setAttribute("itemList", newItemArr);
                            s.setAttribute("orderList", newOrderArr);
                            request.setAttribute("deleteStatus", "success");
                        }
                    }
                    RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                    dispatcher.forward(request, response);
                } catch (Exception e){
                    request.setAttribute("deleteStatus", "fail");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                    dispatcher.forward(request, response);
                }
                
            }
        }
        
        if(request.getParameter("itemname") != null){
            Items item = new Items();
            try{
                
                try{
                    item.setId(itemsFacade.getLatestId() + 1);
                } catch (Exception e){
                    item.setId(1L);
                }
                
                Long sellerId = Long.parseLong(request.getParameter("sellerId"));
                item.setSeller_id(sellerId);
                item.setItem_name(request.getParameter("itemname"));
                item.setItem_img(request.getParameter("url"));
                item.setQuantity(Integer.parseInt(request.getParameter("qty")));
                item.setPrice(Double.parseDouble(request.getParameter("price")));
                item.setDescription(request.getParameter("description"));
                item.setCategory(Integer.parseInt(request.getParameter("category")));
                item.setDiscount_percentage(Double.parseDouble(request.getParameter("discountPercentage")));
                item.setAvg_rating(0);
                item.setSold_qty(0);

                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                item.setCreated_at(timestampNow);
                item.setUpdated_at(timestampNow);

                if (itemsFacade.createItem(item)){
                    request.setAttribute("itemStatus", "success");
                    List<Items> newItemArr = itemsFacade.retrieveItemsBySellerId(sellerId);
                    s.setAttribute("itemList", newItemArr);
                    
                    Sellers seller = (Sellers)s.getAttribute("userDetail");
                    int sellerItemQty = seller.getTotal_items();
                    seller.setTotal_items(sellerItemQty + 1);
                    
                    if (sellersFacade.updateSeller(seller)){
                        s.setAttribute("userDetail", seller);
                    }
                    
                } else {
                    request.setAttribute("itemStatus", "failed");
                }
            } catch (Exception e){
                request.setAttribute("itemStatus", "failed");
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("new_item.jsp");
            dispatcher.forward(request, response);
        }
        
        if (request.getParameter("itemName") != null){
            Long itemid = Long.parseLong(request.getParameter("itemId"));
            String itemIdStr = itemid.toString();
            Items item = itemsFacade.find(itemid);
            
            try{
                item.setItem_name(request.getParameter("itemName"));
                item.setItem_img(request.getParameter("url"));
                item.setQuantity(Integer.parseInt(request.getParameter("qty")));
                item.setPrice(Double.parseDouble(request.getParameter("price")));
                item.setDescription(request.getParameter("description"));
                
                String category = request.getParameter("category");
                int categoryId = Integer.parseInt(category);
                
                item.setCategory(categoryId);
                item.setDiscount_percentage(Double.parseDouble(request.getParameter("discountPercentage")));

                LocalDateTime now = LocalDateTime.now();
                Timestamp timestampNow = Timestamp.valueOf(now);
                item.setUpdated_at(timestampNow);

                if (itemsFacade.updateItem(item)){
                    request.setAttribute("editStatus", "success");
                    request.setAttribute("product", item);
                    request.setAttribute("categoryId", Long.parseLong(request.getParameter("category")));
                    Sellers seller = (Sellers)s.getAttribute("userDetail");
                    List<Items> newItemArr = itemsFacade.retrieveItemsBySellerId(seller.getId());
                    s.setAttribute("itemList", newItemArr);
                } else {
                    request.setAttribute("editStatus", "failed");
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("edit_item.jsp?id=" + itemIdStr);
                dispatcher.forward(request, response);
            } catch (Exception e){
                request.setAttribute("editStatus", "failed");
                RequestDispatcher dispatcher = request.getRequestDispatcher("edit_item.jsp?id=" + itemIdStr);
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
