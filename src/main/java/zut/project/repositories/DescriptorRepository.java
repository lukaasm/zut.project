package zut.project.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import zut.project.entity.Descriptor;
import zut.project.entity.User;

public interface DescriptorRepository extends JpaRepository<Descriptor, Integer> {

	List<Descriptor> findByUser( User user );
	Descriptor findByName(String name);
	List<Descriptor> findByParent(Descriptor parent);
	List<Descriptor> findByUserAndParent(User user, Descriptor parent);
	List<Descriptor> findByParentAndAccess(Descriptor parent, String access);
	@Modifying 
	@Transactional
	@Query("update Descriptor u set u.parent.id = ?1 where u.id = ?2")
	int setNewParent(int folderId, int elementId);	 
	
}
