package zut.project.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import zut.project.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {

	User findByName(String name);

}