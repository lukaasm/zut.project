package zut.project.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import zut.project.entity.Role;

public interface RoleRepository extends JpaRepository<Role, Integer> {

	Role findByName(String name);

}
