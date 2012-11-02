<%--
 * UniTime 3.2 (University Timetabling Application)
 * Copyright (C) 2008-2009, UniTime LLC
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
--%>
<%@ page language="java" autoFlush="true" errorPage="../error.jsp" %>
<%@ page import="org.unitime.timetable.util.Constants" %>
<%@ page import="org.unitime.timetable.form.ClassEditForm" %>
<%@ page import="org.unitime.timetable.model.DepartmentalInstructor" %>
<%@ page import="org.unitime.timetable.model.DatePattern" %>
<%@ page import="org.unitime.timetable.util.IdValue" %>
<%@ page import="org.unitime.timetable.model.Reservation" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/tld/timetable.tld" prefix="tt" %>
<%
	// Get Form 
	String frmName = "ClassEditForm";
	ClassEditForm frm = (ClassEditForm)request.getAttribute(frmName);

	String crsNbr = "";
	if (session.getAttribute(Constants.CRS_NBR_ATTR_NAME)!=null )
		crsNbr = session.getAttribute(Constants.CRS_NBR_ATTR_NAME).toString();

%>		
<tiles:importAttribute />
<html:form action="/classDetail">
	<html:hidden property="classId"/>
	<html:hidden property="nextId"/>
	<html:hidden property="previousId"/>
	<bean:define name='<%=frmName%>' property="classId" id="classId"/>

	<TABLE width="100%" border="0" cellspacing="0" cellpadding="3">
		<TR>
			<TD valign="middle" colspan='2'>
				<tt:section-header>
					<tt:section-title>
						<A title="Instructional Offering Detail (Alt+I)" accesskey="I" class="l8"
							href="instructionalOfferingDetail.do?op=view&io=<bean:write name="<%=frmName%>" property="instrOfferingId"/>">
							<bean:write name="<%=frmName%>" property="courseName"/>
							- <bean:write name="<%=frmName%>" property="courseTitle"/></A>: 
						<logic:empty name="<%=frmName%>" property="subpart">
							<bean:write name="<%=frmName%>" property="itypeDesc"/>
						</logic:empty>
						<logic:notEmpty name="<%=frmName%>" property="subpart">
							<A title="Scheduling Subpart Detail (Alt+S)" accesskey="S" class="l8"
								href="schedulingSubpartDetail.do?ssuid=<bean:write name="<%=frmName%>" property="subpart"/>">
								<bean:write name="<%=frmName%>" property="itypeDesc"/>
							</A>
						</logic:notEmpty>
						<bean:write name="<%=frmName%>" property="section"/>
					</tt:section-title>
					
					<logic:equal name="<%=frmName%>" property="editable" value="true">
						<html:submit property="op" styleClass="btn" accesskey="E" titleKey="title.editPrefsClass" >
							<bean:message key="button.editPrefsClass" />
						</html:submit> 
				
						&nbsp;
						<html:submit property="op" styleClass="btn" accesskey="A" titleKey="title.addDistPref" >
							<bean:message key="button.addDistPref" />
						</html:submit>
					</logic:equal>
					
					<logic:equal name="<%=frmName%>" property="displayInfo" value="true">
						&nbsp;
						<input type="button" value="Assign" title="Open Class Assignment Dialog (Alt+X)" class="btn" accesskey="X"
								onClick="showGwtDialog('Class Assignment', 'classInfo.do?classId=<%=String.valueOf(classId)%>','900','90%');"
						/>
					</logic:equal>
									
					<logic:notEmpty name="<%=frmName%>" property="previousId">
						&nbsp;
						<html:submit property="op" 
								styleClass="btn" accesskey="P" titleKey="title.previousClass">
							<bean:message key="button.previousClass" />
						</html:submit> 
					</logic:notEmpty>
					<logic:notEmpty name="<%=frmName%>" property="nextId">
						&nbsp;
						<html:submit property="op" 
							styleClass="btn" accesskey="N" titleKey="title.nextClass">
							<bean:message key="button.nextClass" />
						</html:submit> 
					</logic:notEmpty>

					&nbsp;
					<tt:back styleClass="btn" name="Back" title="Return to %% (Alt+B)" accesskey="B" type="PreferenceGroup">
						<bean:write name="<%=frmName%>" property="classId"/>
					</tt:back>
				</tt:section-header>
			</TD>
		</TR>

		<logic:messagesPresent>
		<TR>
			<TD colspan="2" align="left" class="errorCell">
					<B><U>ERRORS</U></B><BR>
				<BLOCKQUOTE>
				<UL>
				    <html:messages id="error">
				      <LI>
						${error}
				      </LI>
				    </html:messages>
			    </UL>
			    </BLOCKQUOTE>
			</TD>
		</TR>
		</logic:messagesPresent>

		<TR>
			<TD>Manager:</TD>
			<TD>
				<bean:write name="<%=frmName%>" property="managingDeptLabel" />
			</TD>
		</TR>

		<logic:notEqual name="<%=frmName%>" property="parentClassName" value="-">
			<TR>
				<TD>Parent Class:</TD>
				<TD>
					<logic:empty name="<%=frmName%>" property="parentClassId">
						<bean:write name="<%=frmName%>" property="parentClassName"/>
					</logic:empty>
					<logic:notEmpty name="<%=frmName%>" property="parentClassId">
						<A href="classDetail.do?cid=<bean:write name="<%=frmName%>" property="parentClassId"/>">
							<bean:write name="<%=frmName%>" property="parentClassName"/>
						</A>
					</logic:notEmpty>
				</TD>
			</TR>
		</logic:notEqual>

		<logic:notEmpty name="<%=frmName%>" property="classSuffix">
			<TR>
				<TD>External Id:</TD>
				<TD>
					<bean:write name="<%=frmName%>" property="classSuffix" />
				</TD>
			</TR>
		</logic:notEmpty>
		<TR>
			<TD>Enrollment:</TD>
			<TD>
				<bean:write name="<%=frmName%>" property="enrollment" />
			</TD>
		</TR>
		
		<logic:notEqual name="<%=frmName%>" property="nbrRooms" value="0">
			<% if (frm.getExpectedCapacity().intValue()==frm.getMaxExpectedCapacity().intValue()) { %>
				<TR>
					<TD>Class Limit:</TD>
					<TD>
						<bean:write name="<%=frmName%>" property="expectedCapacity" />
					</TD>
				</TR>
			<% } else { %>
				<TR>
					<TD>Minimum Class Limit:</TD>
					<TD>
						<bean:write name="<%=frmName%>" property="expectedCapacity" />
					</TD>
				</TR>
				<TR>
					<TD>Maximum Class Limit:</TD>
					<TD>
						<bean:write name="<%=frmName%>" property="maxExpectedCapacity" />
					</TD>
				</TR>
			<% } %>
		</logic:notEqual>

		<TR>
			<TD>Number of Rooms:</TD>
			<TD>
				<bean:write name="<%=frmName%>" property="nbrRooms" />
			</TD>
		</TR>
		
		<logic:notEqual name="<%=frmName%>" property="nbrRooms" value="0">
			<TR>
				<TD>Room Ratio:</TD>
				<TD>
					<bean:write name="<%=frmName%>" property="roomRatio" />
					&nbsp;&nbsp;&nbsp;&nbsp; ( Minimum Room Capacity: <bean:write name="<%=frmName%>" property="minRoomLimit" /> )
				</TD>
			</TR>
		</logic:notEqual>

		<TR>
			<TD>Date Pattern:</TD>
			<TD>
				<logic:iterate scope="request" name="<%=DatePattern.DATE_PATTERN_LIST_ATTR%>" id="dp">
					<logic:equal name="<%=frmName%>" property="datePattern" value="<%=((IdValue)dp).getId().toString()%>">
						<bean:write name="dp" property="value" />
						<img style="cursor: pointer;" src="scripts/jscalendar/calendar_1.gif" border="0" onclick="showGwtDialog('Preview of <%=((IdValue)dp).getValue()%>', 'user/dispDatePattern.jsp?id=<%=((IdValue)dp).getId()%>&class='+ClassEditForm.classId.value,'840','520');">
					</logic:equal>
				</logic:iterate>
			</TD>
		</TR>
		
		<TR>
			<TD>Display Instructors:</TD>
			<TD>
				<logic:equal name="<%=frmName%>" property="displayInstructor" value="true">
					<IMG src="images/tick.gif" border="0" alt="Instructor Displayed" title="Instructor Displayed">
				</logic:equal>
				<logic:notEqual name="<%=frmName%>" property="displayInstructor" value="true">
					<IMG src="images/delete.gif" border="0" alt="Instructor Displayed" title="Instructor Displayed">
				</logic:notEqual>
			</TD>
		</TR>

		<TR>
			<TD>Display In Schedule Book:</TD>
			<TD>
				<logic:equal name="<%=frmName%>" property="displayInScheduleBook" value="true">
					<IMG src="images/tick.gif" border="0" alt="Displayed in Schedule Book" title="Displayed in Schedule Book">
				</logic:equal>
				<logic:notEqual name="<%=frmName%>" property="displayInScheduleBook" value="true">
					<IMG src="images/delete.gif" border="0" alt="Displayed in Schedule Book" title="Displayed in Schedule Book">
				</logic:notEqual>
			</TD>
		</TR>

		<TR>
			<TD valign="top">Student Schedule Note:</TD>
			<TD>
				<bean:write name="<%=frmName%>" property="schedulePrintNote" />
			</TD>
		</TR>

		<logic:notEmpty name="<%=frmName%>" property="notes">
			<TR>
				<TD valign="top">Requests / Notes:</TD>
				<TD>
					<bean:write name="<%=frmName%>" property="notes" filter="false"/>
				</TD>
			</TR>
		</logic:notEmpty>
		
		<logic:notEmpty name="<%=frmName%>" property="instructors">
			<TR>
				<TD valign="top">Instructors:</TD>
				<TD>
					<table cellspacing="0" cellpadding="3">
						<tr><td width='250'><i>Name</i></td><td width='80'><i>Share</i></td><td width='80'><i>Check Conflicts</i></td></tr>
						<logic:iterate name="<%=frmName%>" property="instructors" id="instructor" indexId="ctr">
							<tr onmouseover="this.style.backgroundColor='rgb(223,231,242)';this.style.cursor='hand';this.style.cursor='pointer';" 
								onmouseout="this.style.backgroundColor='transparent';"
								onClick="document.location='instructorDetail.do?instructorId=<%=instructor%>';"
							>
								<td>
								<logic:iterate scope="request" name="<%=DepartmentalInstructor.INSTR_LIST_ATTR_NAME%>" id="instr">
									<logic:equal name="instr" property="value" value="<%=(String)instructor%>">
										<bean:write name="instr" property="label"/>
									</logic:equal>
								</logic:iterate>
								</td>
								<td>
									<bean:write name="<%=frmName%>" property='<%= "instrPctShare[" + ctr + "]" %>' />%
								</td>
								<td>
									<logic:equal name="<%=frmName%>" property='<%="instrLead[" + ctr + "]"%>' value="true"> 
										<IMG border='0' alt='true' align="middle" src='images/tick.gif'>
										<%-- <input type='checkbox' checked disabled> --%>
									</logic:equal>
									<%-- 
									<logic:notEqual name="<%=frmName%>" property='<%="instrLead[" + ctr + "]"%>' value="false"> 
										<input type='checkbox' disabled>
									</logic:notEqual>
									--%>
								</td>
								
							</tr>
						</logic:iterate>
					</table>
				</TD>
			</TR>
		</logic:notEmpty>

		<tt:last-change type='Class_'>
			<bean:write name="<%=frmName%>" property="classId"/>
		</tt:last-change>		

<%
	if (request.getAttribute("Suggestions.assignmentInfo")!=null) {
%>
		<TR>
			<TD colspan="2" align="left">
				&nbsp;<BR>
				<DIV class="WelcomeRowHead">Timetable</DIV>
			</TD>
		</TR>
		<%=request.getAttribute("Suggestions.assignmentInfo")%>
<%
	}
%>

<!-- Preferences -->
		<TR>
			<TD colspan="2" valign="middle">
				&nbsp;<BR>
				<tt:section-title>Preferences</tt:section-title>
			</TD>
		</TR>
		<logic:equal value="0" name="<%=frmName%>" property="nbrRooms">
			<jsp:include page="preferencesDetail.jspf">
				<jsp:param name="frmName" value="<%=frmName%>"/>
				<jsp:param name="bldgPref" value="false"/>
				<jsp:param name="roomFeaturePref" value="false"/>
				<jsp:param name="roomGroupPref" value="false"/>
			</jsp:include>
		</logic:equal>
		<logic:notEqual value="0" name="<%=frmName%>" property="nbrRooms">
			<logic:equal value="true" name="<%=frmName%>" property="unlimitedEnroll">
				<jsp:include page="preferencesDetail.jspf">
					<jsp:param name="frmName" value="<%=frmName%>"/>
					<jsp:param name="bldgPref" value="false"/>
					<jsp:param name="roomFeaturePref" value="false"/>
					<jsp:param name="roomGroupPref" value="false"/>
				</jsp:include>
			</logic:equal>
			<logic:notEqual value="true" name="<%=frmName%>" property="unlimitedEnroll">
				<jsp:include page="preferencesDetail.jspf">
					<jsp:param name="frmName" value="<%=frmName%>"/>
				</jsp:include>
			</logic:notEqual>
		</logic:notEqual>
		
		<TR>
			<TD colspan="2">
				<tt:exams type='Class_' add='true'>
					<bean:write name="<%=frmName%>" property="classId"/>
				</tt:exams>
			</TD>
		</TR>
		

<!-- Buttons -->
		<TR>
			<TD colspan="2" align="right">
				<tt:section-title/>
			</TD>
		</TR>

		<TR>
			<TD colspan="2" align="right">
				<INPUT type="hidden" name="doit" value="Cancel">

				<logic:equal name="<%=frmName%>" property="editable" value="true">
					<html:submit property="op" styleClass="btn" accesskey="E" titleKey="title.editPrefsClass" >
						<bean:message key="button.editPrefsClass" />
					</html:submit> 
				
					&nbsp;
					<html:submit property="op" styleClass="btn" accesskey="A" titleKey="title.addDistPref" >
						<bean:message key="button.addDistPref" />
					</html:submit>
				</logic:equal>

				<logic:equal name="<%=frmName%>" property="displayInfo" value="true">
					&nbsp;
					<input type="button" value="Assign" title="Open Class Assignment Dialog (Alt+X)" class="btn" accesskey="X"
							onClick="showGwtDialog('Class Assignment', 'classInfo.do?classId=<%=String.valueOf(classId)%>','900','90%');"
					/>
				</logic:equal>
			
				<logic:notEmpty name="<%=frmName%>" property="previousId">
					&nbsp;
					<html:submit property="op" 
							styleClass="btn" accesskey="P" titleKey="title.previousClass">
						<bean:message key="button.previousClass" />
					</html:submit> 
				</logic:notEmpty>
				<logic:notEmpty name="<%=frmName%>" property="nextId">
					&nbsp;
					<html:submit property="op" 
						styleClass="btn" accesskey="N" titleKey="title.nextClass">
						<bean:message key="button.nextClass" />
					</html:submit> 
				</logic:notEmpty>

				&nbsp;
				<tt:back styleClass="btn" name="Back" title="Return to %% (Alt+B)" accesskey="B" type="PreferenceGroup">
					<bean:write name="<%=frmName%>" property="classId"/>
				</tt:back>
			</TD>
		</TR>

	</TABLE>
</html:form>