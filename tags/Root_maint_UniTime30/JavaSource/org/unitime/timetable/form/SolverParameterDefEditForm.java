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
package org.unitime.timetable.form;

import org.apache.struts.action.ActionForm;
import org.unitime.timetable.model.SolverParameterDef;


/** 
 * @author Tomas Muller
 */
public class SolverParameterDefEditForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	/** solverParameterDef property */
	private SolverParameterDef solverParameterDef = new SolverParameterDef();;

	// --------------------------------------------------------- Methods

	/** 
	 * Returns the solverParameterDef.
	 * @return SolverParameterDef
	 */
	public SolverParameterDef getSolverParameterDef() {
		return solverParameterDef;
	}

	/** 
	 * Set the solverParameterDef.
	 * @param solverParameterDef The solverParameterDef to set
	 */
	public void setSolverParameterDef(SolverParameterDef solverParameterDef) {
		this.solverParameterDef = solverParameterDef;
	}
	
	/**
	 * 
	 * @return
	 */
	public Long getUniqueId() {
		return solverParameterDef.getUniqueId();
	}

	/**
	 * 
	 * @param uniqueId
	 */
	public void setUniqueId(Long uniqueId) {
		solverParameterDef.setUniqueId(uniqueId);
	}
	
	/**
	 * 
	 * @return
	 */
	public String getKey() {
		return solverParameterDef.getName();
	}

	/**
	 * 
	 * @param key
	 */
	public void setKey(String key) {
		solverParameterDef.setName(key);
	}
	
	/**
	 * 
	 * @return
	 */
	public String getDesc() {
		return solverParameterDef.getDescription();
	}

	/**
	 * 
	 * @param desc
	 */
	public void setDesc(String desc) {
		solverParameterDef.setDescription(desc);
	}
	
	/**
	 * 
	 * @return
	 */
	public String getDefaultValue() {
		return solverParameterDef.getDefault();
	}

	/**
	 * 
	 * @param DefaultValue
	 */
	public void setDefaultValue(String DefaultValue) {
		solverParameterDef.setDefault(DefaultValue);
	}

}

