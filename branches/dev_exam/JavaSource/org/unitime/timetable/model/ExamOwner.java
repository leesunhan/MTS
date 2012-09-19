/*
 * UniTime 3.0 (University Course Timetabling & Student Sectioning Application)
 * Copyright (C) 2007, UniTime.org, and individual contributors
 * as indicated by the @authors tag.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
package org.unitime.timetable.model;

import java.util.List;

import org.unitime.timetable.model.base.BaseExamOwner;
import org.unitime.timetable.model.comparators.ClassComparator;
import org.unitime.timetable.model.comparators.InstrOfferingConfigComparator;
import org.unitime.timetable.model.dao.Class_DAO;
import org.unitime.timetable.model.dao.CourseOfferingDAO;
import org.unitime.timetable.model.dao.ExamOwnerDAO;
import org.unitime.timetable.model.dao.InstrOfferingConfigDAO;
import org.unitime.timetable.model.dao.InstructionalOfferingDAO;

public class ExamOwner extends BaseExamOwner implements Comparable<ExamOwner> {
	private static final long serialVersionUID = 1L;

/*[CONSTRUCTOR MARKER BEGIN]*/
	public ExamOwner () {
		super();
	}

	/**
	 * Constructor for primary key
	 */
	public ExamOwner (java.lang.Long uniqueId) {
		super(uniqueId);
	}

	/**
	 * Constructor for required fields
	 */
	public ExamOwner (
	        java.lang.Long uniqueId,
	        org.unitime.timetable.model.Exam exam,
	        java.lang.Long ownerId,
	        java.lang.Integer ownerType,
	        org.unitime.timetable.model.CourseOffering course) {

		super (
			uniqueId,
			exam,
			ownerId,
			ownerType,
			course);
	}

/*[CONSTRUCTOR MARKER END]*/

	
	public static final int sOwnerTypeClass = 3;
	public static final int sOwnerTypeConfig = 2;
	public static final int sOwnerTypeCourse = 1;
	public static final int sOwnerTypeOffering = 0;
	public static String[] sOwnerTypes = new String[] {"Offering", "Course", "Config", "Class"};
	
	public static ExamOwner findByOwnerIdType(Long ownerId, Integer ownerType) {
	    return (ExamOwner)new ExamOwnerDAO().
	        getSession().
	        createQuery("select o from ExamOwner o where o.ownerId=:ownerId and o.ownerType=:ownerType").
	        setLong("ownerId", ownerId).
	        setInteger("ownerType", ownerType).
	        setCacheable(true).uniqueResult();
	}
	
	
	private Object iOwnerObject = null;
	public Object getOwnerObject() {
	    if (iOwnerObject!=null) return iOwnerObject;
	    switch (getOwnerType()) {
	        case sOwnerTypeClass : 
	            iOwnerObject = new Class_DAO().get(getOwnerId());
	            return iOwnerObject;
	        case sOwnerTypeConfig : 
	            iOwnerObject = new InstrOfferingConfigDAO().get(getOwnerId());
	            return iOwnerObject;
	        case sOwnerTypeCourse : 
	            iOwnerObject = new CourseOfferingDAO().get(getOwnerId());
	            return iOwnerObject;
	        case sOwnerTypeOffering : 
	            iOwnerObject = new InstructionalOfferingDAO().get(getOwnerId());
	            return iOwnerObject;
	        default : throw new RuntimeException("Unknown owner type "+getOwnerType());
	    }
	}
	
    public void setOwner(Class_ clazz) {
        setOwnerId(clazz.getUniqueId());
        setOwnerType(sOwnerTypeClass);
        setCourse(clazz.getSchedulingSubpart().getInstrOfferingConfig().getControllingCourseOffering());
    }

    public void setOwner(InstrOfferingConfig config) {
        setOwnerId(config.getUniqueId());
        setOwnerType(sOwnerTypeConfig);
        setCourse(config.getControllingCourseOffering());
    }

    public void setOwner(CourseOffering course) {
        setOwnerId(course.getUniqueId());
        setOwnerType(sOwnerTypeCourse);
        setCourse(course);
    }

    public void setOwner(InstructionalOffering offering) {
        setOwnerId(offering.getUniqueId());
        setOwnerType(sOwnerTypeOffering);
        setCourse(offering.getControllingCourseOffering());
    }
    
    public CourseOffering computeCourse() {
        Object owner = getOwnerObject();
        switch (getOwnerType()) {
            case sOwnerTypeClass : 
                return ((Class_)owner).getSchedulingSubpart().getControllingCourseOffering();
            case sOwnerTypeConfig : 
                return ((InstrOfferingConfig)owner).getControllingCourseOffering();
            case sOwnerTypeCourse : 
                return (CourseOffering)owner;
            case sOwnerTypeOffering : 
                return ((InstructionalOffering)owner).getControllingCourseOffering();
            default : throw new RuntimeException("Unknown owner type "+getOwnerType());
        }
    }
    
    public int compareTo(ExamOwner owner) {
        CourseOffering c1 = getCourse();
        CourseOffering c2 = owner.getCourse();
        int cmp = 0;
        
        cmp = c1.getSubjectAreaAbbv().compareTo(c2.getSubjectAreaAbbv());
        if (cmp!=0) return cmp;
        
        cmp = c1.getCourseNbr().compareTo(c2.getCourseNbr());
        if (cmp!=0) return cmp;
        
        cmp = getOwnerType().compareTo(owner.getOwnerType());
        if (cmp!=0) return cmp;
        
        switch (getOwnerType()) {
            case sOwnerTypeClass : return new ClassComparator(ClassComparator.COMPARE_BY_HIERARCHY).compare(getOwnerObject(), owner.getOwnerObject());
            case sOwnerTypeConfig : return new InstrOfferingConfigComparator(null).compare(getOwnerObject(), owner.getOwnerObject());
        }
           
        return getOwnerId().compareTo(owner.getOwnerId());
    }
    
    public List getStudents() {
        switch (getOwnerType()) {
        case sOwnerTypeClass : 
            return new ExamOwnerDAO().getSession().createQuery(
                    "select distinct e.student from " +
                    "StudentClassEnrollment e inner join e.clazz c  " +
                    "where c.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .list();
        case sOwnerTypeConfig : 
            return new ExamOwnerDAO().getSession().createQuery(
                    "select distinct e.student from " +
                    "StudentClassEnrollment e inner join e.clazz c  " +
                    "where c.schedulingSubpart.instrOfferingConfig.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .list();
        case sOwnerTypeCourse : 
            return new ExamOwnerDAO().getSession().createQuery(
                    "select distinct e.student from " +
                    "StudentClassEnrollment e inner join e.courseOffering co  " +
                    "where co.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .list();
        case sOwnerTypeOffering : 
            return new ExamOwnerDAO().getSession().createQuery(
                    "select distinct e.student from " +
                    "StudentClassEnrollment e inner join e.courseOffering co  " +
                    "where co.instructionalOffering.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .list();
        default : throw new RuntimeException("Unknown owner type "+getOwnerType());
        }
    }
    
    public int countStudents() {
        switch (getOwnerType()) {
        case sOwnerTypeClass : 
            return ((Number)new ExamOwnerDAO().getSession().createQuery(
                    "select count(distinct e.student) from " +
                    "StudentClassEnrollment e inner join e.clazz c  " +
                    "where c.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .uniqueResult()).intValue();
        case sOwnerTypeConfig : 
            return ((Number)new ExamOwnerDAO().getSession().createQuery(
                    "select count(distinct e.student) from " +
                    "StudentClassEnrollment e inner join e.clazz c  " +
                    "where c.schedulingSubpart.instrOfferingConfig.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .uniqueResult()).intValue();
        case sOwnerTypeCourse : 
            return ((Number)new ExamOwnerDAO().getSession().createQuery(
                    "select count(distinct e.student) from " +
                    "StudentClassEnrollment e inner join e.courseOffering co  " +
                    "where co.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .uniqueResult()).intValue();
        case sOwnerTypeOffering : 
            return ((Number)new ExamOwnerDAO().getSession().createQuery(
                    "select count(distinct e.student) from " +
                    "StudentClassEnrollment e inner join e.courseOffering co  " +
                    "where co.instructionalOffering.uniqueId = :examOwnerId")
                    .setLong("examOwnerId", getOwnerId())
                    .setCacheable(true)
                    .uniqueResult()).intValue();
        default : throw new RuntimeException("Unknown owner type "+getOwnerType());
        }
    }
    
    public String getLabel() {
        Object owner = getOwnerObject();
        switch (getOwnerType()) {
            case sOwnerTypeClass : 
                return ((Class_)owner).getClassLabel();
            case sOwnerTypeConfig : 
                return ((InstrOfferingConfig)owner).toString();
            case sOwnerTypeCourse : 
                return ((CourseOffering)owner).getCourseName();
            case sOwnerTypeOffering : 
                return ((InstructionalOffering)owner).getCourseName();
            default : throw new RuntimeException("Unknown owner type "+getOwnerType());
        }
    }

    
}