/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Favourite_sellers;
import Model.Sellers;
import Model.Users;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author User
 */
@Stateless
public class Favourite_sellersFacade extends AbstractFacade<Favourite_sellers> {

    @EJB
    private UsersFacade usersFacade;

    @EJB
    private SellersFacade sellersFacade;
    
    

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;
    

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public Favourite_sellersFacade() {
        super(Favourite_sellers.class);
    }
    
    public boolean createFav_seller(Favourite_sellers fav_seller) {
        try {
            this.create(fav_seller);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Favourite_sellers getFav_sellerById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateFav_seller(Favourite_sellers fav_seller) {
        try {
            this.edit(fav_seller);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteFav_seller(Favourite_sellers fav_seller) {
        this.remove(fav_seller);
    }
    
    public List<Users> retrieveAllFavouriteSellersByCustomerId(Long id) {
        try{
            List<Users> userArr = new ArrayList<Users>();
            String query = "SELECT a FROM Favourite_sellers a WHERE a.customer_id = " + id + "";
            TypedQuery<Favourite_sellers> q = em.createQuery(query, Favourite_sellers.class);
            List<Favourite_sellers> fav_sellerArr = q.getResultList();
            
            for (Favourite_sellers fs : fav_sellerArr){
                Sellers s = sellersFacade.getSellerById(fs.getSeller_id());
                Users u = usersFacade.find(s.getUser_id());
                userArr.add(u);
            }
            return userArr;
        } catch(Exception e){
            return new ArrayList<Users>();
        }
    }
    
    public Favourite_sellers checkIfSellerIsCurrentCustomerFavourite(Long seller_id, Long customer_id) {
        try{
            String query = "SELECT a FROM Favourite_sellers a WHERE a.seller_id = " + seller_id + " AND a.customer_id = " + customer_id + "";
            TypedQuery<Favourite_sellers> q = em.createQuery(query, Favourite_sellers.class);
            Favourite_sellers fs = q.getSingleResult();
            return fs;
        } catch (Exception e){
            return null;
        }
    }
}
