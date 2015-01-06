package zut.project.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import zut.project.entity.Descriptor;

public interface DescriptorRepository extends JpaRepository<Descriptor, Integer> {

}
