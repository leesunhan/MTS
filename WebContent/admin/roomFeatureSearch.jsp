<%-- 
 * UniTime 3.2 (University Timetabling Application)
 * Copyright (C) 2008 - 2010, UniTime LLC
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
<%@ page language="java" autoFlush="true" errorPage="../error.jsp"%>
<%@ page import="org.unitime.timetable.util.Constants" %>
<%@ page import="org.unitime.timetable.model.Department" %>
<%@ page import="org.unitime.timetable.form.RoomFeatureListForm" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/tld/timetable.tld" prefix="tt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
	// Get Form 
	String frmName = "roomFeatureListForm";	
	RoomFeatureListForm frm = (RoomFeatureListForm) request.getAttribute(frmName);
%>
	
<tiles:importAttribute />
<html:form action="roomFeatureList">
	<TABLE border="0" cellspacing="0" cellpadding="3">
		<TR>
			<TD>
				<B>Department: </B>
				<html:select property="deptCodeX"
					onchange="displayLoading(); submit()"
					onfocus="setUp();" 
					onkeypress="return selectSearch(event, this);" 
					onkeydown="return checkKey(event, this);" >
					<html:option value="<%=Constants.BLANK_OPTION_VALUE%>"><%=Constants.BLANK_OPTION_LABEL%></html:option>
					<html:option value="<%=Constants.ALL_OPTION_VALUE%>">All Managed</html:option>
					<tt:canSeeExams>
						<tt:hasFinalExams>
							<html:option value="Exam">All Final Examination Rooms</html:option>
						</tt:hasFinalExams>
						<tt:hasMidtermExams>
							<html:option value="EExam">All Midterm Examination Rooms</html:option>
						</tt:hasMidtermExams>
					</tt:canSeeExams>
					<html:options collection="<%=Department.DEPT_ATTR_NAME%>" 
						property="value" labelProperty="label"/>
					</html:select>
			</TD>
		
			<TD align="right" nowrap>			
				&nbsp;&nbsp;&nbsp;
				<html:submit property="op" value="Search" onclick="displayLoading();" accesskey="S" styleClass="btn"/>
				<sec:authorize access="hasPermission(null, 'Department', 'RoomFeaturesExportPdf')">
					&nbsp;&nbsp;
					<html:submit property="op" value="Export PDF" onclick="displayLoading();" accesskey="P" styleClass="btn"/>
				</sec:authorize>
			</TD>
		</TR>
		
		<TR>
			<TD colspan="2" valign="top" align="center">
				<html:errors />			
			</TD>
		</TR>

	</TABLE>
</html:form>

<logic:notEmpty name="body2">
	<script language="javascript">displayLoading();</script>
	<tiles:insert attribute="body2" />
	<script language="javascript">displayElement('loading', false);</script>
</logic:notEmpty>