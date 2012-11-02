/*
 * UniTime 3.1 (University Timetabling Application)
 * Copyright (C) 2008, UniTime LLC, and individual contributors
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
package org.unitime.timetable.model.base;

import java.io.Serializable;


/**
 * This is an object that contains data related to the HISTORY table.
 * Do not modify this class because it will be overwritten if the configuration file
 * related to this class is modified.
 *
 * @hibernate.class
 *  table="HISTORY"
 */

public abstract class BaseSubjectHistory extends org.unitime.timetable.model.History  implements Serializable {

	public static String REF = "SubjectHistory";


	// constructors
	public BaseSubjectHistory () {
		initialize();
	}

	/**
	 * Constructor for primary key
	 */
	public BaseSubjectHistory (java.lang.Long uniqueId) {
		super(uniqueId);
	}

	/**
	 * Constructor for required fields
	 */
	public BaseSubjectHistory (
		java.lang.Long uniqueId,
		java.lang.String oldValue,
		java.lang.String newValue,
		java.lang.Long sessionId) {

		super (
			uniqueId,
			oldValue,
			newValue,
			sessionId);
	}



	private int hashCode = Integer.MIN_VALUE;









	public boolean equals (Object obj) {
		if (null == obj) return false;
		if (!(obj instanceof org.unitime.timetable.model.SubjectHistory)) return false;
		else {
			org.unitime.timetable.model.SubjectHistory subjectHistory = (org.unitime.timetable.model.SubjectHistory) obj;
			if (null == this.getUniqueId() || null == subjectHistory.getUniqueId()) return false;
			else return (this.getUniqueId().equals(subjectHistory.getUniqueId()));
		}
	}

	public int hashCode () {
		if (Integer.MIN_VALUE == this.hashCode) {
			if (null == this.getUniqueId()) return super.hashCode();
			else {
				String hashStr = this.getClass().getName() + ":" + this.getUniqueId().hashCode();
				this.hashCode = hashStr.hashCode();
			}
		}
		return this.hashCode;
	}


	public String toString () {
		return super.toString();
	}


}