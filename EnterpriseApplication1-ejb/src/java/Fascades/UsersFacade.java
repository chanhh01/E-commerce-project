/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Users;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

/**
 *
 * @author User
 */
@Stateless
public class UsersFacade extends AbstractFacade<Users> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UsersFacade() {
        super(Users.class);
    }
    
    public boolean registerNewUser(Users users) {
        try {
            this.create(users);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Users getUserById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateUser(Users users) {
        try {
            this.edit(users);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteUser(Users users) {
        this.remove(users);
    }
    
    public Users verifyUsers(String email, String pswd){
        try{
            String query = "SELECT a FROM Users a WHERE a.email = '" + email + "' AND a.passwords = '" + pswd + "'";
            TypedQuery<Users> q = em.createQuery(query, Users.class);
            return (Users)q.getSingleResult();
        } catch (Exception e){
            return null;
        }
    }
    
    public List<Users> retrievePendingSellers(){
        try{
            String query = "SELECT a FROM Users a WHERE a.roles = 'pending'";
            TypedQuery<Users> q = em.createQuery(query, Users.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Users>();
        }
    }
    
    public Users getUserByEmail(String email) {
        try{
            String query = "SELECT a FROM Users a WHERE a.email = '" + email + "'";
            TypedQuery<Users> q = em.createQuery(query, Users.class);
            return q.getSingleResult();
        } catch (Exception e){
            return null;
        }
    }
    
    public List<Users> retrieveUsersWithSimilarUsernames(String name, String role) {
        try{
            String query = "SELECT a FROM Users a WHERE a.username LIKE '%" + name + "%' AND a.roles = '" + role + "'";
            TypedQuery<Users> q = em.createQuery(query, Users.class);
            return q.getResultList();
        } catch (Exception e){
            return new ArrayList<Users>();
        }
    }
}
