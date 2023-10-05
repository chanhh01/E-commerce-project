/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Items;
import Model.Sellers;
import Model.Users;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author Seller
 */
@Stateless
public class SellersFacade extends AbstractFacade<Sellers> {

    @EJB
    private UsersFacade usersFacade;

    @EJB
    private ItemsFacade itemsFacade;
    
    

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;
    
    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public SellersFacade() {
        super(Sellers.class);
    }
    
    public boolean registerNewSeller(Sellers seller) {
        try {
            this.create(seller);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Sellers getSellerById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateSeller(Sellers seller) {
        try {
            this.edit(seller);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteSeller(Sellers seller) {
        this.remove(seller);
    }
    
    public Sellers retrieveSellerDetails(Long user_id){
        try{
            String query = "SELECT a FROM Sellers a WHERE a.user_id = " + user_id + "";
            TypedQuery<Sellers> q = em.createQuery(query, Sellers.class);
            return q.getSingleResult();
        } catch (Exception e){
            return null;
        }
    }
    
    public double retrieveSellerCreditPoints(Long seller_id) {
        try{
            List<Items> itemArr = itemsFacade.retrieveItemsBySellerId(seller_id);
            if (itemArr.size() > 0){
                double average_credit = itemArr.stream()
                        .mapToDouble(Items::getAvg_rating)
                        .average()
                        .orElse(0.0);
                return average_credit;
            } else {
                return 0;
            }
        } catch (Exception e){
            return 0;
        }
    }
    
    public List<Sellers> sortSellersByCreditPoints(List<Sellers> sellerArr, String sortOrder) {
        try{
            if (sortOrder.equals("ascending")){
                return sellerArr.stream()
                        .sorted(Comparator.comparingDouble(Sellers::getCredit_points))
                        .collect(Collectors.toList());
            } else if (sortOrder.equals("descending")){
                return sellerArr.stream()
                        .sorted(Comparator.comparingDouble(Sellers::getCredit_points).reversed())
                        .collect(Collectors.toList());
            }
            return sellerArr;
        } catch (Exception e){
            return sellerArr;
        }
    }
    
    public List<Users> retrieveTopThreeSellersByCredit(){
        String query = "";
        try {
            query = "SELECT a FROM Sellers a ORDER BY a.credit_points DESC";
            TypedQuery<Sellers> q = em.createQuery(query, Sellers.class);
            q.setMaxResults(3);
            List<Sellers> sellerArr = q.getResultList();
            List<Users> userArr = new ArrayList<Users>();

            for (Sellers s : sellerArr){
                Users u = usersFacade.getUserById(s.getUser_id());
                userArr.add(u);
            }

            return userArr;
        } catch (Exception e){
            return new ArrayList<Users>();
        }
    }
}
