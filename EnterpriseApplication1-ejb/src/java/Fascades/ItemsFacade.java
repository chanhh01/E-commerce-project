/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Items;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author User
 */
@Stateless
public class ItemsFacade extends AbstractFacade<Items> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ItemsFacade() {
        super(Items.class);
    }
    
    public boolean createItem(Items item) {
        try {
            this.create(item);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Items getItemById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateItem(Items item) {
        try {
            this.edit(item);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteItem(Items item) {
        this.remove(item);
    }
    
    public List<Items> retrieveItemsWithSimilarNames(String name) {
        try{
            String query = "SELECT a FROM Items a WHERE LOWER(a.item_name) LIKE LOWER('%" + name + "%')";
            TypedQuery<Items> q = em.createQuery(query, Items.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Items>();
        }
    }
    
    public List<Items> retrieveItemsByCategoryId(Long category_id) {
        try{
            String query = "SELECT a FROM Items a WHERE a.category = " + category_id + "";
            TypedQuery<Items> q = em.createQuery(query, Items.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Items>();
        }
    }
    
    public List<Items> retrieveItemsBySellerId(Long seller_id) {
        try{
            String query = "SELECT a FROM Items a WHERE a.seller_id = " + seller_id + "";
            TypedQuery<Items> q = em.createQuery(query, Items.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Items>();
        }
    }
    
    public int retrieveTotalItemsSoldBySeller(Long seller_id){
        int totalItemsSold = 0;
        try{
            for (Items i : this.retrieveItemsBySellerId(seller_id)){
                totalItemsSold = totalItemsSold + i.getSold_qty();
            }
            
            return totalItemsSold;
        } catch (Exception e){
            return 0;
        }
    }
    
    public List<Items> retrieveTopThreeItemsWithCertainConditions(String option){
        String query = "";
        try {
            if (option.equals("rating")){
                query = "SELECT a FROM Items a ORDER BY a.avg_rating DESC";
            } else if (option.equals("sales")){
                query = "SELECT a FROM Items a ORDER BY a.sold_qty DESC";
            }
            TypedQuery<Items> q = em.createQuery(query, Items.class);
            q.setMaxResults(3);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Items>();
        }
    }
    
    public List<Items> filterItemsByPriceRange(List<Items> itemArr, double min_price, double max_price) {
        List<Items> newArr = new ArrayList<Items>();
        try{
            for (Items i : itemArr){
                if (i.getDiscountedPrice(i) >= min_price && i.getDiscountedPrice(i) <= max_price){
                    newArr.add(i);
                }
            }
            return  newArr;
        } catch (Exception e){
            return itemArr;
        }
    }
    
    public List<Items> sortItemsByPrice(List<Items> itemArr, String sortOrder) {
        List<Items> newArr = itemArr;
        try{
            if (sortOrder.equals("ascending")){
                Collections.sort(newArr, new Comparator<Items>() {
                    public int compare(Items i1, Items i2) {
                        return Double.compare(i1.getDiscountedPrice(i1), i2.getDiscountedPrice(i2));
                    }
                });
            } else if (sortOrder.equals("descending")){
                Collections.sort(newArr, new Comparator<Items>() {
                    public int compare(Items i1, Items i2) {
                        return Double.compare(i2.getDiscountedPrice(i2), i1.getDiscountedPrice(i1));
                    }
                });
            }
            return newArr;
        } catch (Exception e){
            return itemArr;
        }
    }
    
    public List<Items> sortItemsByRatings(List<Items> itemArr, String sortOrder) {
        List<Items> newArr = itemArr;
        try{
            if (sortOrder.equals("ascending")){
                Collections.sort(newArr, new Comparator<Items>() {
                    public int compare(Items i1, Items i2) {
                        return Double.compare(i1.getAvg_rating(), i2.getAvg_rating());
                    }
                });
            } else if (sortOrder.equals("descending")){
                Collections.sort(newArr, new Comparator<Items>() {
                    public int compare(Items i1, Items i2) {
                        return Double.compare(i2.getAvg_rating(), i1.getAvg_rating());
                    }
                });
            }
            return newArr;
        } catch (Exception e){
            return itemArr;
        }
    }
    
    public List<Items> sortItemsByAmountSold(List<Items> itemArr, String sortOrder) {
         List<Items> newArr = itemArr;
        try{
            if (sortOrder.equals("ascending")){
                Collections.sort(newArr, new Comparator<Items>() {
                    public int compare(Items i1, Items i2) {
                        return Double.compare(i1.getSold_qty(), i2.getSold_qty());
                    }
                });
            } else if (sortOrder.equals("descending")){
                Collections.sort(newArr, new Comparator<Items>() {
                    public int compare(Items i1, Items i2) {
                        return Double.compare(i2.getSold_qty(), i1.getSold_qty());
                    }
                });
            }
            return newArr;
        } catch (Exception e){
            return itemArr;
        }
    }
    
    public double getAvgRatingOfItemsUnderSameSeller(long seller_id){
        List<Items> itemArr = this.retrieveItemsBySellerId(seller_id);
        int size = itemArr.size();
        
        if (size > 0){
            double itemRating = 0;
            for (Items i : itemArr){
                itemRating = itemRating + i.getAvg_rating();
            }
            
            double avgItemRating = 0;
            if (itemRating > 0){
                avgItemRating = itemRating/size;
            }
            
            DecimalFormat df = new DecimalFormat("#.##");
            String str = df.format(avgItemRating);
            avgItemRating = Double.parseDouble(str);
            
            return avgItemRating;
        } else {
            return 0;
        }
    }
}
