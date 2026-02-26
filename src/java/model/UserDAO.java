package model;

import javax.persistence.EntityManager;
import utils.JPAUtil;

public class UserDAO {

    public UserDTO login(String email, String password) {

        EntityManager em = JPAUtil.getEntityManager();

        try {
            String jpql = "SELECT u FROM UserDTO u "
                    + "WHERE u.email = :email "
                    + "AND u.password = :password "
                    + "AND u.status = 'ACTIVE'";

            return em.createQuery(jpql, UserDTO.class)
                    .setParameter("email", email)
                    .setParameter("password", password)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

        } finally {
            em.close();
        }
    }
}