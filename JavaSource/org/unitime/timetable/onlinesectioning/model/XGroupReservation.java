/*
 * Licensed to The Apereo Foundation under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.
 *
 * The Apereo Foundation licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
*/
package org.unitime.timetable.onlinesectioning.model;

import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;

import org.infinispan.commons.marshall.Externalizer;
import org.infinispan.commons.marshall.SerializeWith;
import org.unitime.timetable.model.StudentGroupReservation;

/**
 * @author Tomas Muller
 */
@SerializeWith(XGroupReservation.XCourseReservationSerializer.class)
public class XGroupReservation extends XReservation {
	private static final long serialVersionUID = 1L;
	private int iLimit;
    private String iGroup;

    public XGroupReservation() {
    	super();
    }
    
    public XGroupReservation(ObjectInput in) throws IOException, ClassNotFoundException {
    	super();
    	readExternal(in);
    }
    
    public XGroupReservation(XOffering offering, StudentGroupReservation reservation) {
    	super(XReservationType.Group, offering, reservation);
        iLimit = (reservation.getLimit() == null ? -1 : reservation.getLimit());
        iGroup = reservation.getGroup().getGroupAbbreviation();
    }
    
    public String getGroup() {
    	return iGroup;
    }
    
    /**
     * Reservation limit
     */
    @Override
    public int getReservationLimit() {
        return iLimit;
    }
    
	@Override
	public boolean isApplicable(XStudent student) {
		return student.getGroups().contains(iGroup);
	}

	@Override
	public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
    	super.readExternal(in);
    	iGroup = (String)in.readObject();
    	iLimit = in.readInt();
	}

	@Override
	public void writeExternal(ObjectOutput out) throws IOException {
		super.writeExternal(out);
		out.writeObject(iGroup);
		out.writeInt(iLimit);
	}
	
	public static class XCourseReservationSerializer implements Externalizer<XGroupReservation> {
		private static final long serialVersionUID = 1L;

		@Override
		public void writeObject(ObjectOutput output, XGroupReservation object) throws IOException {
			object.writeExternal(output);
		}

		@Override
		public XGroupReservation readObject(ObjectInput input) throws IOException, ClassNotFoundException {
			return new XGroupReservation(input);
		}
	}
}
