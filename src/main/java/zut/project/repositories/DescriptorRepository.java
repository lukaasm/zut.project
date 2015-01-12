package zut.project.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import zut.project.entity.Descriptor;
import zut.project.entity.User;

public interface DescriptorRepository extends JpaRepository<Descriptor, Integer> {

	List<Descriptor> findByUser( User user );
	Descriptor findByName(String name);
	List<Descriptor> findByParent(Descriptor parent);
	List<Descriptor> findByUserAndParent(User user, Descriptor parent);
	List<Descriptor> findByParentAndAccess(Descriptor parent, String access);
}
