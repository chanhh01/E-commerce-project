/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Fascades;

import Model.Category;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author User
 */
@Stateless
public class CategoryFacade extends AbstractFacade<Category> {

    @PersistenceContext(unitName = "EnterpriseApplication1-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CategoryFacade() {
        super(Category.class);
    }
    
    public boolean createCategory(Category category) {
        try {
            this.create(category);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public Category getCategoryById(Long id) {
        try{
            return this.find(id);
        } catch (Exception e){
            return null;
        }
    }
    
    public boolean updateCategory(Category category) {
        try {
            this.edit(category);
            return true;
        } catch (Exception e){
            return false;
        }
    }
    
    public void deleteCategory(Category category) {
        this.remove(category);
    }
    
}
