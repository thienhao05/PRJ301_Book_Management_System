package utils;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class JPAUtil {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("PRJ301_Book_Management_SystemPU");

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
}