/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Review_replies;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.TypedQuery;

/**
 *
 * @author User
 */
@Stateless
public class Review_repliesFacade extends AbstractFacade<Review_replies> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public Review_repliesFacade() {
        super(Review_replies.class);
    }
    
    public boolean createReview_reply(Review_replies reply) {
        try {
            this.create(reply);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Review_replies getReview_replyById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateReview_reply(Review_replies reply) {
        try {
            this.edit(reply);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteReview_reply(Review_replies reply) {
        this.remove(reply);
    }
    
    public List<Review_replies> retrieveAllRepliesUnderReview(Long review_id) {
        try{
            String query = "SELECT a FROM Review_replies a WHERE a.review_id = " + review_id + "";
            TypedQuery<Review_replies> q = em.createQuery(query, Review_replies.class);
            return q.getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}
