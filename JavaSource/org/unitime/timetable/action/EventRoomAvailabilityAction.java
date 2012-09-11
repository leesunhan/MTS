/*
 * UniTime 3.2 (University Timetabling Application)
 * Copyright (C) 2008 - 2010, UniTime LLC, and individual contributors
 * as indicated by the @authors tag.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
*/

package org.unitime.timetable.action;

import java.util.Iterator;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.unitime.commons.web.WebTable;
import org.unitime.timetable.form.EventRoomAvailabilityForm;
import org.unitime.timetable.model.Class_;
import org.unitime.timetable.model.CourseEvent;
import org.unitime.timetable.model.CourseOffering;
import org.unitime.timetable.model.ExamOwner;
import org.unitime.timetable.model.InstrOfferingConfig;
import org.unitime.timetable.model.InstructionalOffering;
import org.unitime.timetable.model.RelatedCourseInfo;
import org.unitime.timetable.model.dao.CourseEventDAO;
import org.unitime.timetable.security.SessionContext;
import org.unitime.timetable.security.rights.Right;

/**
 * @author Zuzana Mullerova
 */
@Service("/eventRoomAvailability")
public class EventRoomAvailabilityAction extends Action {
	
	@Autowired SessionContext sessionContext;

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 */	
	public ActionForward execute(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpSession webSession = request.getSession();
		
		sessionContext.checkPermissionAnyAuthority(Right.Events);
		
		EventRoomAvailabilityForm myForm = (EventRoomAvailabilityForm) form;
		try { 
			myForm.load(webSession);
		} catch (Exception e) {
		    ActionMessages errors = myForm.validate(mapping, request);
			errors.add("dates", new ActionMessage("errors.generic", e.getMessage()));
			saveErrors(request, errors);
			return  mapping.findForward("show");
		}

		String iOp = myForm.getOp();
		
		if (iOp != null) {
			
			// if the user is returning from the Event Add Info screen
			if ("eventAddInfo".equals(request.getAttribute("back"))) {
				myForm.load(request.getSession());
				iOp = null;
			}
			
			//return to event list
			if("Change Request".equals(iOp)) {
				myForm.loadData(request); myForm.save(webSession);
				request.setAttribute("back", "eventRoomAvailability");
				return mapping.findForward("back");
			}
			
			if("Continue".equals(iOp)) {
                myForm.loadData(request); myForm.save(webSession);  
                ActionMessages errors = myForm.validate(mapping, request);
                if (!errors.isEmpty()) {
                    saveErrors(request, errors);
                    return  mapping.findForward("show");
                }
				if (myForm.getIsAddMeetings()) {
				    if ("Course Related Event".equals(myForm.getEventType())) {
			            CourseEvent courseEvent = new CourseEventDAO().get((myForm.getEventId()));;
			            if (!courseEvent.getRelatedCourses().isEmpty()) {
			                WebTable table = new WebTable(5, null, new String[] {"Object", "Type", "Title","Limit","Assignment"}, new String[] {"left", "left", "left","right","left"}, new boolean[] {true, true, true, true,true});
			                for (Iterator i=new TreeSet(courseEvent.getRelatedCourses()).iterator();i.hasNext();) {
			                    RelatedCourseInfo rci = (RelatedCourseInfo)i.next();
			                    String onclick = null, name = null, type = null, title = null, assignment = null;
			                    String students = String.valueOf(rci.countStudents());
			                    switch (rci.getOwnerType()) {
			                        case ExamOwner.sOwnerTypeClass :
			                            Class_ clazz = (Class_)rci.getOwnerObject();
			                            if (sessionContext.hasPermissionAnyAuthority(clazz, Right.ClassDetail))
			                                onclick = "onClick=\"document.location='classDetail.do?cid="+clazz.getUniqueId()+"';\"";
			                            name = rci.getLabel();//clazz.getClassLabel();
			                            type = "Class";
			                            title = clazz.getSchedulePrintNote();
			                            if (title==null || title.length()==0) title=clazz.getSchedulingSubpart().getControllingCourseOffering().getTitle();
			                            if (clazz.getCommittedAssignment()!=null)
			                                assignment = clazz.getCommittedAssignment().getPlacement().getLongName();
			                            break;
			                        case ExamOwner.sOwnerTypeConfig :
			                            InstrOfferingConfig config = (InstrOfferingConfig)rci.getOwnerObject();
			                            if (sessionContext.hasPermissionAnyAuthority(config.getInstructionalOffering(), Right.InstructionalOfferingDetail))
			                                onclick = "onClick=\"document.location='instructionalOfferingDetail.do?io="+config.getInstructionalOffering().getUniqueId()+"';\"";;
			                            name = rci.getLabel();//config.getCourseName()+" ["+config.getName()+"]";
			                            type = "Configuration";
			                            title = config.getControllingCourseOffering().getTitle();
			                            break;
			                        case ExamOwner.sOwnerTypeOffering :
			                            InstructionalOffering offering = (InstructionalOffering)rci.getOwnerObject();
			                            if (sessionContext.hasPermissionAnyAuthority(offering, Right.InstructionalOfferingDetail))
			                                onclick = "onClick=\"document.location='instructionalOfferingDetail.do?io="+offering.getUniqueId()+"';\"";;
			                            name = rci.getLabel();//offering.getCourseName();
			                            type = "Offering";
			                            title = offering.getControllingCourseOffering().getTitle();
			                            break;
			                        case ExamOwner.sOwnerTypeCourse :
			                            CourseOffering course = (CourseOffering)rci.getOwnerObject();
			                            if (sessionContext.hasPermissionAnyAuthority(course.getInstructionalOffering(), Right.InstructionalOfferingDetail))
			                                onclick = "onClick=\"document.location='instructionalOfferingDetail.do?io="+course.getInstructionalOffering().getUniqueId()+"';\"";;
			                            name = rci.getLabel();//course.getCourseName();
			                            type = "Course";
			                            title = course.getTitle();
			                            break;
			                                
			                    }
			                    table.addLine(onclick, new String[] { name, type, title, students, assignment}, null);
			                }
			                request.setAttribute("EventDetail.table",table.printTable());
			            }
			        }
				    return mapping.findForward("eventUpdateMeetings");
				} else return mapping.findForward("eventAddInfo");
			}
			
			if("Change".equals(iOp)) {
			    myForm.setMaxRooms(request.getParameter("maxRooms"));
			    myForm.save(webSession);
			}
			
		} 

		return  mapping.findForward("show");
	}
		
	
}