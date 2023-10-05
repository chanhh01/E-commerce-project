/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Carts;
import Model.Items;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author User
 */
@Stateless
public class CartsFacade extends AbstractFacade<Carts> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CartsFacade() {
        super(Carts.class);
    }
    
    public boolean createCart(Carts cart) {
        try {
            this.create(cart);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Carts getCartById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateCart(Carts cart) {
        try {
            this.edit(cart);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteCart(Carts cart) {
        this.remove(cart);
    }
    
    public List<Carts> retrieveAllCartsOfCustomer(Long customer_id) {
        try{
           String query = "SELECT a FROM Carts a WHERE a.customer_id = " + customer_id + "";
           TypedQuery<Carts> q = em.createQuery(query, Carts.class);
           return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Carts>();
        }
    }
    
    public List<Carts> retrieveAllCartsForItemsUnderSameSeller(List<Items> itemArr) {
        try{
            List<Carts> cartArr = new ArrayList<Carts>();
            for (Items i : itemArr){
                String query = "SELECT a FROM Carts a WHERE a.item_id = " + i.getId()+ "";
                TypedQuery<Carts> q = em.createQuery(query, Carts.class);
                if (q.getResultList().size() > 0){
                    cartArr.addAll(q.getResultList());
                }
            }
            return cartArr;
        } catch (Exception e){
            return new ArrayList<Carts>();
        }
    }
    
    public Carts getCartWithSameCustomerAndItem(Long customer_id, Long item_id){
        try{
            String query = "SELECT a FROM Carts a WHERE a.item_id = " + item_id + " AND a.customer_id = " + customer_id + "";
            TypedQuery<Carts> q = em.createQuery(query, Carts.class);
            return q.getSingleResult();
        } catch (Exception e){
            return null;
        }
    }
}
