package org.unitime.timetable.model.base;

import java.io.Serializable;


/**
 * This is an object that contains data related to the EVENT table.
 * Do not modify this class because it will be overwritten if the configuration file
 * related to this class is modified.
 *
 * @hibernate.class
 *  table="EVENT"
 */

public abstract class BaseMidtermExamEvent extends org.unitime.timetable.model.ExamEvent  implements Serializable {

	public static String REF = "MidtermExamEvent";


	// constructors
	public BaseMidtermExamEvent () {
		initialize();
	}

	/**
	 * Constructor for primary key
	 */
	public BaseMidtermExamEvent (java.lang.Long uniqueId) {
		super(uniqueId);
	}

	/**
	 * Constructor for required fields
	 */
	public BaseMidtermExamEvent (
		java.lang.Long uniqueId,
		java.lang.Integer minCapacity,
		java.lang.Integer maxCapacity) {

		super (
			uniqueId,
			minCapacity,
			maxCapacity);
	}



	private int hashCode = Integer.MIN_VALUE;









	public boolean equals (Object obj) {
		if (null == obj) return false;
		if (!(obj instanceof org.unitime.timetable.model.MidtermExamEvent)) return false;
		else {
			org.unitime.timetable.model.MidtermExamEvent midtermExamEvent = (org.unitime.timetable.model.MidtermExamEvent) obj;
			if (null == this.getUniqueId() || null == midtermExamEvent.getUniqueId()) return false;
			else return (this.getUniqueId().equals(midtermExamEvent.getUniqueId()));
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