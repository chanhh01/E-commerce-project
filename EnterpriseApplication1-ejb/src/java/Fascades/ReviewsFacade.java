/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Reviews;
import java.text.DecimalFormat;
import javax.ejb.Stateless;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author User
 */
@Stateless
public class ReviewsFacade extends AbstractFacade<Reviews> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ReviewsFacade() {
        super(Reviews.class);
    }
    
    public boolean createReview(Reviews review) {
        try {
            this.create(review);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Reviews getReviewById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateReview(Reviews review) {
        try {
            this.edit(review);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteReview(Reviews review) {
        this.remove(review);
    }
    
    public List<Reviews> retrieveAllReviewsByItemId(Long item_id) {
        try{
            String query = "SELECT a FROM Reviews a WHERE a.item_id = " + item_id + "";
            TypedQuery<Reviews> q = em.createQuery(query, Reviews.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<>();
        }
    }

    public double retrieveItemAverageRating(Long item_id) {
        try{
            List<Reviews> reviewArr = this.retrieveAllReviewsByItemId(item_id);
            if (reviewArr.size() > 0){
                double avg_rating = reviewArr.stream()
                        .mapToDouble(Reviews::getRating)
                        .average()
                        .orElse(0.0);
                return avg_rating;
            } else {
                return 0.0;
            }
        } catch (Exception e){
            return 0.0;
        }
    }
    
    public List<Reviews> sortReviewsByDescendingOrder(List<Reviews> reviewArr) {
        try{
            if (reviewArr.size() > 0){
                return reviewArr.stream()
                        .sorted(Comparator.comparingLong(Reviews::getId).reversed())
                        .collect(Collectors.toList());
            } else {
                return reviewArr;
            }
        } catch (Exception e){
            return reviewArr;
        }
    }
    
    public double calculateNewRatingForItem(Long itemId){
        List<Reviews> reviewArr = this.retrieveAllReviewsByItemId(itemId);
        
        if (reviewArr.size() > 0){
            int size = reviewArr.size();
            double totalRating = 0;
            for (Reviews r : reviewArr){
                totalRating = totalRating + r.getRating();
            }
            double avgRating = 0;
            if (totalRating != 0){
                avgRating = totalRating/size;
            }
            
            DecimalFormat df = new DecimalFormat("#.##");
            String str = df.format(avgRating);
            avgRating = Double.parseDouble(str);
            
            return avgRating;
        } else {
            return 0;
        }
    }
}
