/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Items;
import Model.Orders;
import java.util.ArrayList;
import javax.ejb.Stateless;
import java.util.List;
import javax.ejb.EJB;
import java.util.stream.Collectors;
import javax.persistence.TypedQuery;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author User
 */
@Stateless
public class OrdersFacade extends AbstractFacade<Orders> {

    @EJB
    private ItemsFacade itemsFacade;

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    
    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public OrdersFacade() {
        super(Orders.class);
    }
    
    public boolean createOrder(Orders order) {
        try {
            this.create(order);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Orders getOrderById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateOrder(Orders order) {
        try {
            this.edit(order);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteOrder(Orders order) {
        this.remove(order);
    }
    
    public List<Orders> retrieveAllOrdersByCustomer(Long customer_id) {
        try{
            String query = "SELECT a FROM Orders a WHERE a.customer_id = " + customer_id + "";
            TypedQuery<Orders> q = em.createQuery(query, Orders.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Orders>();
        }
    }
    
    public List<Orders> retrieveAllOrdersOfSellers(Long seller_id) {
        List<Orders> orderArr = new ArrayList<Orders>();
        try{
            List<Items> itemArr = itemsFacade.retrieveItemsBySellerId(seller_id);
            for (Items i: itemArr){
                String query = "SELECT a FROM Orders a WHERE a.item_id = " + i.getId() + " AND a.status <> 'cancelled'";
                TypedQuery<Orders> q = em.createQuery(query, Orders.class);
                orderArr.addAll(q.getResultList());
            }
            return orderArr;
        } catch(Exception e){
            return new ArrayList<Orders>();
        }
    }
    
    public List<Orders> retrieveCompletedOrdersByCustomer(Long customer_id) {
        List<Orders> newArr = new ArrayList<Orders>();
        try{
            List<Orders> orderArr = this.retrieveAllOrdersByCustomer(customer_id);
            for (Orders o : orderArr){
                if (o.getStatus().equals("completed")){
                    newArr.add(o);
                }
            }
            return newArr;
        } catch (Exception e){
            return new ArrayList<Orders>();
        }
    }
    
    public double retrieveTotalEarningsOfSeller(Long seller_id){
        double totalEarnings = 0;
        try{
            List<Items> itemArr = itemsFacade.retrieveItemsBySellerId(seller_id);
            for (Items i: itemArr){
                String query = "SELECT a FROM Orders a WHERE a.item_id = " + i.getId() + " AND (a.status = 'completed' or a.status = 'to rate')";
                TypedQuery<Orders> q = em.createQuery(query, Orders.class);
                
                for (Orders o : q.getResultList()){
                    totalEarnings = totalEarnings + o.getTotal_price();
                }
            }
            return totalEarnings;
        } catch(Exception e){
            return 0;
        }
    }
    
    public List<Orders> retrieveOrdersYetToShipBySeller(Long seller_id) {
        List<Orders> newArr = new ArrayList<Orders>();
        try{
            List<Orders> orderArr = this.retrieveAllOrdersOfSellers(seller_id);
            for (Orders o : orderArr){
                if (o.getStatus().equals("to ship")){
                    newArr.add(o);
                }
            }
            return newArr;
        } catch(Exception e){
            return new ArrayList<Orders>();
        }
    }
    
    public List<Orders> retrieveOrdersToSellerYetToBeReceived(Long seller_id) {
        List<Orders> newArr = new ArrayList<Orders>();
        try{
            List<Orders> orderArr = this.retrieveAllOrdersOfSellers(seller_id);
            for (Orders o : orderArr){
                if (o.getStatus().equals("to receive")){
                    newArr.add(o);
                }
            }
            return newArr;
        } catch(Exception e){
            return new ArrayList<Orders>();
        }
    }
    
    public void deleteOrdersByItemId(Long item_id){
        String query = "SELECT a FROM Orders a WHERE a.item_id = " + item_id + "";
        TypedQuery<Orders> q = em.createQuery(query, Orders.class);
        List<Orders> orderArr = q.getResultList();
        
        for (Orders o : orderArr){
            this.deleteOrder(o);
        }
    }
    
    public List<Orders> retrieveCompletedOrdersOfSeller(Long seller_id) {
        List<Orders> newArr = new ArrayList<Orders>();
        try{
            List<Orders> orderArr = this.retrieveAllOrdersOfSellers(seller_id);
            for (Orders o : orderArr){
                if (o.getStatus().equals("to rate") || o.getStatus().equals("completed")){
                    newArr.add(o);
                }
            }
            return newArr;
        } catch(Exception e){
            return new ArrayList<Orders>();
        }
    }
    
    public List<Orders> retrieveAllOrdersByCustomerWithCondition(Long customer_id, String option) {
        List<Orders> newArr = new ArrayList<Orders>();
        try{
            List<Orders> orderArr = this.retrieveAllOrdersByCustomer(customer_id);
            for (Orders o : orderArr){
                if (o.getStatus().equals(option)){
                    newArr.add(o);
                }
            }
            return newArr;
        } catch(Exception e){
            return new ArrayList<Orders>();
        }
    }
    
}
