/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Customers;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author Customer
 */
@Stateless
public class CustomersFacade extends AbstractFacade<Customers> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CustomersFacade() {
        super(Customers.class);
    }
    
    public boolean registerNewCustomer(Customers custs) {
        try {
            this.create(custs);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Customers getCustomerById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateCustomer(Customers custs) {
        try {
            this.edit(custs);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteCustomer(Customers custs) {
        this.remove(custs);
    }
    
    public Customers retrieveCustomerDetails(Long user_id){
        try{
            String query = "SELECT a FROM Customers a WHERE a.user_id = " + user_id + "";
            TypedQuery<Customers> q = em.createQuery(query, Customers.class);
            return q.getSingleResult();
        } catch (Exception e){
            return null;
        }
    }
}
