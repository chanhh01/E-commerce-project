/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Admins;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author User
 */
@Stateless
public class AdminsFacade extends AbstractFacade<Admins> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AdminsFacade() {
        super(Admins.class);
    }
    
    public boolean registerNewAdmin(Admins admin) {
        try {
            this.create(admin);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Admins getAdminById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateUser(Admins admin) {
        try {
            this.edit(admin);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteUser(Admins admin) {
        this.remove(admin);
    }
    
}
