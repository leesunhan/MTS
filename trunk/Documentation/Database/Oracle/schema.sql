/*
 * UniTime 3.1 (University Timetabling Application)
 * Copyright (C) 2008, UniTime.org
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

spool timetable.log

drop user timetable cascade;

create user timetable identified by unitime;

grant dba to timetable;

prompt
prompt Creating table DATE_PATTERN
prompt ===========================
prompt
create table TIMETABLE.DATE_PATTERN
(
  UNIQUEID   NUMBER(20),
  NAME       VARCHAR2(50),
  PATTERN    VARCHAR2(366),
  OFFSET     NUMBER(10),
  TYPE       NUMBER(10),
  VISIBLE    NUMBER(1),
  SESSION_ID NUMBER(20)
)
;
alter table TIMETABLE.DATE_PATTERN
  add constraint PK_DATE_PATTERN primary key (UNIQUEID);
alter table TIMETABLE.DATE_PATTERN
  add constraint NN_DATE_PATTERN_OFFSET
  check ("OFFSET" IS NOT NULL);
alter table TIMETABLE.DATE_PATTERN
  add constraint NN_DATE_PATTERN_PATTERN
  check ("PATTERN" IS NOT NULL);
alter table TIMETABLE.DATE_PATTERN
  add constraint NN_DATE_PATTERN_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.DATE_PATTERN
  add constraint NN_DATE_PATTERN_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_DATE_PATTERN_SESSION on TIMETABLE.DATE_PATTERN (SESSION_ID);

prompt
prompt Creating table DEPT_STATUS_TYPE
prompt ===============================
prompt
create table TIMETABLE.DEPT_STATUS_TYPE
(
  UNIQUEID  NUMBER(20),
  REFERENCE VARCHAR2(20),
  LABEL     VARCHAR2(60),
  STATUS    NUMBER(10),
  APPLY     NUMBER(10),
  ORD       NUMBER(10)
)
;
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint PK_DEPT_STATUS primary key (UNIQUEID);
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint NN_DEPT_STATUS_TYPE_APPLY
  check ("APPLY" IS NOT NULL);
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint NN_DEPT_STATUS_TYPE_LABEL
  check ("LABEL" IS NOT NULL);
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint NN_DEPT_STATUS_TYPE_ORD
  check ("ORD" IS NOT NULL);
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint NN_DEPT_STATUS_TYPE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint NN_DEPT_STATUS_TYPE_STATUS
  check ("STATUS" IS NOT NULL);
alter table TIMETABLE.DEPT_STATUS_TYPE
  add constraint NN_DEPT_STATUS_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table SESSIONS
prompt =======================
prompt
create table TIMETABLE.SESSIONS
(
  ACADEMIC_INITIATIVE     VARCHAR2(20),
  SESSION_BEGIN_DATE_TIME DATE,
  CLASSES_END_DATE_TIME   DATE,
  SESSION_END_DATE_TIME   DATE,
  UNIQUEID                NUMBER(20) not null,
  HOLIDAYS                VARCHAR2(366),
  DEF_DATEPATT_ID         NUMBER(20),
  STATUS_TYPE             NUMBER(20),
  LAST_MODIFIED_TIME      TIMESTAMP(6),
  ACADEMIC_YEAR           VARCHAR2(4),
  ACADEMIC_TERM           VARCHAR2(20),
  EXAM_BEGIN_DATE         DATE
)
;
alter table TIMETABLE.SESSIONS
  add constraint PK_SESSIONS primary key (UNIQUEID);
alter table TIMETABLE.SESSIONS
  add constraint FK_SESSIONS_STATUS_TYPE foreign key (STATUS_TYPE)
  references TIMETABLE.DEPT_STATUS_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.SESSIONS
  add constraint FK_SESSION_DATEPATT foreign key (DEF_DATEPATT_ID)
  references TIMETABLE.DATE_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_ACADEMIC_INITIATIV
  check ("ACADEMIC_INITIATIVE" IS NOT NULL);
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_ACADEMIC_TERM
  check ("ACADEMIC_TERM" IS NOT NULL);
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_ACADEMIC_YEAR
  check ("ACADEMIC_YEAR" IS NOT NULL);
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_CLASSESENDDATETIME
  check ("CLASSES_END_DATE_TIME" IS NOT NULL);
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_EXAM_BEGIN_DATE
  check (exam_begin_date is not null);
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_SESSIONENDDATETIME
  check ("SESSION_END_DATE_TIME" IS NOT NULL);
alter table TIMETABLE.SESSIONS
  add constraint NN_SESSIONS_SESSION_BEGI_DT_TM
  check ("SESSION_BEGIN_DATE_TIME" IS NOT NULL);
alter table TIMETABLE.DATE_PATTERN
  add constraint FK_DATE_PATTERN_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
create index TIMETABLE.IDX_SESSIONS_DATE_PATTERN on TIMETABLE.SESSIONS (DEF_DATEPATT_ID);
create index TIMETABLE.IDX_SESSIONS_STATUS_TYPE on TIMETABLE.SESSIONS (STATUS_TYPE);

prompt
prompt Creating table ACADEMIC_AREA
prompt ============================
prompt
create table TIMETABLE.ACADEMIC_AREA
(
  UNIQUEID                   NUMBER(20),
  SESSION_ID                 NUMBER(20),
  ACADEMIC_AREA_ABBREVIATION VARCHAR2(10),
  SHORT_TITLE                VARCHAR2(50),
  LONG_TITLE                 VARCHAR2(100),
  EXTERNAL_UID               VARCHAR2(40)
)
;
alter table TIMETABLE.ACADEMIC_AREA
  add constraint PK_ACADEMIC_AREA primary key (UNIQUEID);
alter table TIMETABLE.ACADEMIC_AREA
  add constraint UK_ACADEMIC_AREA unique (SESSION_ID, ACADEMIC_AREA_ABBREVIATION);
alter table TIMETABLE.ACADEMIC_AREA
  add constraint FK_ACADEMIC_AREA_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.ACADEMIC_AREA
  add constraint NN_ACADEMIC_AREA_ACAD_AREA_ABB
  check ("ACADEMIC_AREA_ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_AREA
  add constraint NN_ACADEMIC_AREA_LONG_TITLE
  check ("LONG_TITLE" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_AREA
  add constraint NN_ACADEMIC_AREA_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_AREA
  add constraint NN_ACADEMIC_AREA_SHORT_TITLE
  check ("SHORT_TITLE" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_AREA
  add constraint NN_ACADEMIC_AREA_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table ACADEMIC_CLASSIFICATION
prompt ======================================
prompt
create table TIMETABLE.ACADEMIC_CLASSIFICATION
(
  UNIQUEID     NUMBER(20),
  SESSION_ID   NUMBER(20),
  CODE         VARCHAR2(10),
  NAME         VARCHAR2(50),
  EXTERNAL_UID VARCHAR2(40)
)
;
alter table TIMETABLE.ACADEMIC_CLASSIFICATION
  add constraint PK_ACAD_CLASS primary key (UNIQUEID);
alter table TIMETABLE.ACADEMIC_CLASSIFICATION
  add constraint FK_ACAD_CLASS_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.ACADEMIC_CLASSIFICATION
  add constraint NN_ACAD_CLASS_CODE
  check ("CODE" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_CLASSIFICATION
  add constraint NN_ACAD_CLASS_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_CLASSIFICATION
  add constraint NN_ACAD_CLASS_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.ACADEMIC_CLASSIFICATION
  add constraint NN_ACAD_CLASS_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table RESERVATION_TYPE
prompt ===============================
prompt
create table TIMETABLE.RESERVATION_TYPE
(
  UNIQUEID  NUMBER(20),
  REFERENCE VARCHAR2(20),
  LABEL     VARCHAR2(60)
)
;
alter table TIMETABLE.RESERVATION_TYPE
  add constraint PK_RESERVATION_TYPE primary key (UNIQUEID);
alter table TIMETABLE.RESERVATION_TYPE
  add constraint UK_RESERVATION_TYPE_LABEL unique (LABEL);
alter table TIMETABLE.RESERVATION_TYPE
  add constraint UK_RESERVATION_TYPE_REF unique (REFERENCE);
alter table TIMETABLE.RESERVATION_TYPE
  add constraint NN_RESERVATION_TYPE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.RESERVATION_TYPE
  add constraint NN_RESERVATION_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table ACAD_AREA_RESERVATION
prompt ====================================
prompt
create table TIMETABLE.ACAD_AREA_RESERVATION
(
  UNIQUEID             NUMBER(20),
  OWNER                NUMBER(20),
  RESERVATION_TYPE     NUMBER(20),
  ACAD_CLASSIFICATION  NUMBER(20),
  ACAD_AREA            NUMBER(20),
  PRIORITY             NUMBER(5),
  RESERVED             NUMBER(10),
  PRIOR_ENROLLMENT     NUMBER(10),
  PROJECTED_ENROLLMENT NUMBER(10),
  OWNER_CLASS_ID       VARCHAR2(1),
  REQUESTED            NUMBER(10),
  LAST_MODIFIED_TIME   TIMESTAMP(6)
)
;
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint PK_ACAD_AREA_RESV primary key (UNIQUEID);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint FK_ACAD_AREA_RESV_ACAD_AREA foreign key (ACAD_AREA)
  references TIMETABLE.ACADEMIC_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint FK_ACAD_AREA_RESV_ACAD_CLASS foreign key (ACAD_CLASSIFICATION)
  references TIMETABLE.ACADEMIC_CLASSIFICATION (UNIQUEID) on delete cascade;
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint FK_ACAD_AREA_RESV_TYPE foreign key (RESERVATION_TYPE)
  references TIMETABLE.RESERVATION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_ACAD_AREA
  check ("ACAD_AREA" IS NOT NULL);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_OWNER
  check ("OWNER" IS NOT NULL);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_OWNER_CLS_ID
  check ("OWNER_CLASS_ID" IS NOT NULL);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_PRIORITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_RESERVED
  check ("RESERVED" IS NOT NULL);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_RESERV_TYPE
  check ("RESERVATION_TYPE" IS NOT NULL);
alter table TIMETABLE.ACAD_AREA_RESERVATION
  add constraint NN_ACAD_AREA_RESV_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ACAD_AREA_RESV_ACAD_AREA on TIMETABLE.ACAD_AREA_RESERVATION (ACAD_AREA);
create index TIMETABLE.IDX_ACAD_AREA_RESV_ACAD_CLASS on TIMETABLE.ACAD_AREA_RESERVATION (ACAD_CLASSIFICATION);
create index TIMETABLE.IDX_ACAD_AREA_RESV_OWNER on TIMETABLE.ACAD_AREA_RESERVATION (OWNER);
create index TIMETABLE.IDX_ACAD_AREA_RESV_OWNER_CLS on TIMETABLE.ACAD_AREA_RESERVATION (OWNER_CLASS_ID);
create index TIMETABLE.IDX_ACAD_AREA_RESV_TYPE on TIMETABLE.ACAD_AREA_RESERVATION (RESERVATION_TYPE);

prompt
prompt Creating table APPLICATION_CONFIG
prompt =================================
prompt
create table TIMETABLE.APPLICATION_CONFIG
(
  NAME        VARCHAR2(1000),
  VALUE       VARCHAR2(4000),
  DESCRIPTION VARCHAR2(100)
)
;
alter table TIMETABLE.APPLICATION_CONFIG
  add constraint PK_APPLICATION_CONFIG primary key (NAME);
alter table TIMETABLE.APPLICATION_CONFIG
  add constraint NN_APPLICATION_CONFIG_KEY
  check ("NAME" IS NOT NULL);

prompt
prompt Creating table OFFR_CONSENT_TYPE
prompt ================================
prompt
create table TIMETABLE.OFFR_CONSENT_TYPE
(
  UNIQUEID  NUMBER(20),
  REFERENCE VARCHAR2(20),
  LABEL     VARCHAR2(60)
)
;
alter table TIMETABLE.OFFR_CONSENT_TYPE
  add constraint PK_OFFR_CONSENT_TYPE primary key (UNIQUEID);
alter table TIMETABLE.OFFR_CONSENT_TYPE
  add constraint UK_OFFR_CONSENT_TYPE_LABEL unique (LABEL);
alter table TIMETABLE.OFFR_CONSENT_TYPE
  add constraint UK_OFFR_CONSENT_TYPE_REF unique (REFERENCE);
alter table TIMETABLE.OFFR_CONSENT_TYPE
  add constraint NN_OFFR_CONSENT_TYPE_REF
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.OFFR_CONSENT_TYPE
  add constraint NN_OFFR_CONSENT_TYPE_UNIQUE_ID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table INSTRUCTIONAL_OFFERING
prompt =====================================
prompt
create table TIMETABLE.INSTRUCTIONAL_OFFERING
(
  UNIQUEID               NUMBER(20),
  SESSION_ID             NUMBER(20),
  INSTR_OFFERING_PERM_ID NUMBER(10),
  NOT_OFFERED            NUMBER(1),
  LIMIT                  NUMBER(4),
  CONSENT_TYPE           NUMBER(20),
  DESIGNATOR_REQUIRED    NUMBER(1),
  LAST_MODIFIED_TIME     TIMESTAMP(6),
  UID_ROLLED_FWD_FROM    NUMBER(20),
  EXTERNAL_UID           VARCHAR2(40)
)
;
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint PK_INSTR_OFFR primary key (UNIQUEID);
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint FK_INSTR_OFFR_CONSENT_TYPE foreign key (CONSENT_TYPE)
  references TIMETABLE.OFFR_CONSENT_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint NN_INSTR_OFFR_DESIGNATOR_REQD
  check ("DESIGNATOR_REQUIRED" IS NOT NULL);
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint NN_INSTR_OFFR_NOT_OFFERED
  check ("NOT_OFFERED" IS NOT NULL);
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint NN_INSTR_OFFR_PERM_ID
  check ("INSTR_OFFERING_PERM_ID" IS NOT NULL);
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint NN_INSTR_OFFR_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.INSTRUCTIONAL_OFFERING
  add constraint NN_INSTR_OFFR_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_INSTR_OFFR_CONSENT on TIMETABLE.INSTRUCTIONAL_OFFERING (CONSENT_TYPE);

prompt
prompt Creating table INSTR_OFFERING_CONFIG
prompt ====================================
prompt
create table TIMETABLE.INSTR_OFFERING_CONFIG
(
  UNIQUEID             NUMBER(20),
  CONFIG_LIMIT         NUMBER(10),
  INSTR_OFFR_ID        NUMBER(20),
  UNLIMITED_ENROLLMENT NUMBER(1),
  NAME                 VARCHAR2(10),
  LAST_MODIFIED_TIME   TIMESTAMP(6),
  UID_ROLLED_FWD_FROM  NUMBER(20)
)
;
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint PK_INSTR_OFFR_CFG primary key (UNIQUEID);
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint UK_INSTR_OFFR_CFG_NAME unique (UNIQUEID, NAME);
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint FK_INSTR_OFFR_CFG_INSTR_OFFR foreign key (INSTR_OFFR_ID)
  references TIMETABLE.INSTRUCTIONAL_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint NN_INSTR_OFFR_CFG_INST_OFFR_ID
  check ("INSTR_OFFR_ID" IS NOT NULL);
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint NN_INSTR_OFFR_CFG_LIMIT
  check ("CONFIG_LIMIT" IS NOT NULL);
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint NN_INSTR_OFFR_CFG_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.INSTR_OFFERING_CONFIG
  add constraint NN_INSTR_OFFR_CFG_UNLIM_ENRL
  check ("UNLIMITED_ENROLLMENT" IS NOT NULL);
create index TIMETABLE.IDX_INSTR_OFFR_CFG_INSTR_OFFR on TIMETABLE.INSTR_OFFERING_CONFIG (INSTR_OFFR_ID);

prompt
prompt Creating table ITYPE_DESC
prompt =========================
prompt
create table TIMETABLE.ITYPE_DESC
(
  ITYPE       NUMBER(2),
  ABBV        VARCHAR2(7),
  DESCRIPTION VARCHAR2(50),
  SIS_REF     VARCHAR2(20),
  BASIC       NUMBER(1),
  PARENT      NUMBER(2),
  ORGANIZED   NUMBER(1)
)
;
alter table TIMETABLE.ITYPE_DESC
  add constraint PK_ITYPE_DESC primary key (ITYPE);
alter table TIMETABLE.ITYPE_DESC
  add constraint NN_ITYPE_DESC_ITYPE
  check ("ITYPE" IS NOT NULL);
alter table TIMETABLE.ITYPE_DESC
  add constraint NN_ITYPE_DESC_ORGANIZED
  check (organized is not null);

prompt
prompt Creating table SCHEDULING_SUBPART
prompt =================================
prompt
create table TIMETABLE.SCHEDULING_SUBPART
(
  UNIQUEID              NUMBER(20),
  MIN_PER_WK            NUMBER(4),
  PARENT                NUMBER(20),
  CONFIG_ID             NUMBER(20),
  ITYPE                 NUMBER(2),
  DATE_PATTERN_ID       NUMBER(20),
  AUTO_TIME_SPREAD      NUMBER(1) default 1,
  SUBPART_SUFFIX        VARCHAR2(5),
  STUDENT_ALLOW_OVERLAP NUMBER(1) default (0),
  LAST_MODIFIED_TIME    TIMESTAMP(6),
  UID_ROLLED_FWD_FROM   NUMBER(20)
)
;
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint PK_SCHED_SUBPART primary key (UNIQUEID);
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint FK_SCHED_SUBPART_CONFIG foreign key (CONFIG_ID)
  references TIMETABLE.INSTR_OFFERING_CONFIG (UNIQUEID) on delete cascade;
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint FK_SCHED_SUBPART_DATE_PATTERN foreign key (DATE_PATTERN_ID)
  references TIMETABLE.DATE_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint FK_SCHED_SUBPART_ITYPE foreign key (ITYPE)
  references TIMETABLE.ITYPE_DESC (ITYPE) on delete cascade;
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint FK_SCHED_SUBPART_PARENT foreign key (PARENT)
  references TIMETABLE.SCHEDULING_SUBPART (UNIQUEID) on delete cascade;
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint NN_SCHED_SUBPART_AUTO_TIME_SPR
  check ("AUTO_TIME_SPREAD" IS NOT NULL);
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint NN_SCHED_SUBPART_CONFIG_ID
  check ("CONFIG_ID" IS NOT NULL);
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint NN_SCHED_SUBPART_ITYPE
  check ("ITYPE" IS NOT NULL);
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint NN_SCHED_SUBPART_MIN_PER_WK
  check ("MIN_PER_WK" IS NOT NULL);
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint NN_SCHED_SUBPART_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.SCHEDULING_SUBPART
  add constraint NN_SUBPART_STAL_OVERLAP
  check ("STUDENT_ALLOW_OVERLAP" IS NOT NULL);
create index TIMETABLE.IDX_SCHED_SUBPART_CONFIG on TIMETABLE.SCHEDULING_SUBPART (CONFIG_ID);
create index TIMETABLE.IDX_SCHED_SUBPART_DATE_PATTERN on TIMETABLE.SCHEDULING_SUBPART (DATE_PATTERN_ID);
create index TIMETABLE.IDX_SCHED_SUBPART_ITYPE on TIMETABLE.SCHEDULING_SUBPART (ITYPE);
create index TIMETABLE.IDX_SCHED_SUBPART_PARENT on TIMETABLE.SCHEDULING_SUBPART (PARENT);

prompt
prompt Creating table CLASS_
prompt =====================
prompt
create table TIMETABLE.CLASS_
(
  UNIQUEID              NUMBER(20),
  SUBPART_ID            NUMBER(20),
  EXPECTED_CAPACITY     NUMBER(4),
  NBR_ROOMS             NUMBER(4),
  PARENT_CLASS_ID       NUMBER(20),
  OWNER_ID              NUMBER(20),
  ROOM_CAPACITY         NUMBER(4),
  NOTES                 VARCHAR2(1000),
  DATE_PATTERN_ID       NUMBER(20),
  MANAGING_DEPT         NUMBER(20),
  DISPLAY_INSTRUCTOR    NUMBER(1),
  SCHED_PRINT_NOTE      VARCHAR2(40),
  CLASS_SUFFIX          VARCHAR2(6),
  DISPLAY_IN_SCHED_BOOK NUMBER(1) default 1,
  MAX_EXPECTED_CAPACITY NUMBER(4),
  ROOM_RATIO            NUMBER default 1.0,
  SECTION_NUMBER        NUMBER(5),
  LAST_MODIFIED_TIME    TIMESTAMP(6),
  UID_ROLLED_FWD_FROM   NUMBER(20),
  EXTERNAL_UID          VARCHAR2(40)
)
;
alter table TIMETABLE.CLASS_
  add constraint PK_CLASS primary key (UNIQUEID);
alter table TIMETABLE.CLASS_
  add constraint FK_CLASS_DATEPATT foreign key (DATE_PATTERN_ID)
  references TIMETABLE.DATE_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_
  add constraint FK_CLASS_PARENT foreign key (PARENT_CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_
  add constraint FK_CLASS_SCHEDULING_SUBPART foreign key (SUBPART_ID)
  references TIMETABLE.SCHEDULING_SUBPART (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_DISPLAY_INSTRUCTOR
  check ("DISPLAY_INSTRUCTOR" IS NOT NULL);
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_DISPLAY_IN_SCHED_BOOK
  check ("DISPLAY_IN_SCHED_BOOK" IS NOT NULL);
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_EXPECTED_CAPACITY
  check ("EXPECTED_CAPACITY" IS NOT NULL);
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_MAX_EXPECTED_CAPACITY
  check ("MAX_EXPECTED_CAPACITY" IS NOT NULL);
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_ROOM_RATIO
  check ("ROOM_RATIO" IS NOT NULL);
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_SUBPART_ID
  check ("SUBPART_ID" IS NOT NULL);
alter table TIMETABLE.CLASS_
  add constraint NN_CLASS_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_CLASS_DATEPATT on TIMETABLE.CLASS_ (DATE_PATTERN_ID);
create index TIMETABLE.IDX_CLASS_MANAGING_DEPT on TIMETABLE.CLASS_ (MANAGING_DEPT);
create index TIMETABLE.IDX_CLASS_PARENT on TIMETABLE.CLASS_ (PARENT_CLASS_ID);
create index TIMETABLE.IDX_CLASS_SUBPART_ID on TIMETABLE.CLASS_ (SUBPART_ID);

prompt
prompt Creating table EVENT_CONTACT
prompt ============================
prompt
create table TIMETABLE.EVENT_CONTACT
(
  UNIQUEID    NUMBER(20),
  EXTERNAL_ID VARCHAR2(40),
  EMAIL       VARCHAR2(100),
  PHONE       VARCHAR2(10),
  FIRSTNAME   VARCHAR2(20),
  MIDDLENAME  VARCHAR2(20),
  LASTNAME    VARCHAR2(30)
)
;
alter table TIMETABLE.EVENT_CONTACT
  add constraint PK_EVENT_CONTACT_UNIQUEID primary key (UNIQUEID);
alter table TIMETABLE.EVENT_CONTACT
  add constraint NN_EVENT_CONTACT_EMAIL
  check ("EMAIL" IS NOT NULL);
alter table TIMETABLE.EVENT_CONTACT
  add constraint NN_EVENT_CONTACT_PHONE
  check ("PHONE" IS NOT NULL);
alter table TIMETABLE.EVENT_CONTACT
  add constraint NN_EVENT_CONTACT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EVENT_TYPE
prompt =========================
prompt
create table TIMETABLE.EVENT_TYPE
(
  UNIQUEID  NUMBER(20),
  REFERENCE VARCHAR2(20),
  LABEL     VARCHAR2(60)
)
;
alter table TIMETABLE.EVENT_TYPE
  add constraint PK_EVENT_TYPE primary key (UNIQUEID);
alter table TIMETABLE.EVENT_TYPE
  add constraint NN_EVENT_TYPE_LABEL
  check ("LABEL" IS NOT NULL);
alter table TIMETABLE.EVENT_TYPE
  add constraint NN_EVENT_TYPE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.EVENT_TYPE
  add constraint NN_EVENT_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EVENT
prompt ====================
prompt
create table TIMETABLE.EVENT
(
  UNIQUEID        NUMBER(20) not null,
  EVENT_TYPE      NUMBER(20) not null,
  EVENT_NAME      VARCHAR2(100),
  MIN_CAPACITY    NUMBER(10),
  MAX_CAPACITY    NUMBER(10),
  SPONSORING_ORG  NUMBER(20),
  MAIN_CONTACT_ID NUMBER(20)
)
;
alter table TIMETABLE.EVENT
  add constraint PK_EVENT_UNIQUEID primary key (UNIQUEID);
alter table TIMETABLE.EVENT
  add constraint FK_EVENT_EVENT_TYPE foreign key (EVENT_TYPE)
  references TIMETABLE.EVENT_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.EVENT
  add constraint FK_EVENT_MAIN_CONTACT foreign key (MAIN_CONTACT_ID)
  references TIMETABLE.EVENT_CONTACT (UNIQUEID) on delete set null;

prompt
prompt Creating table SOLVER_GROUP
prompt ===========================
prompt
create table TIMETABLE.SOLVER_GROUP
(
  UNIQUEID   NUMBER(20),
  NAME       VARCHAR2(50),
  ABBV       VARCHAR2(50),
  SESSION_ID NUMBER(20)
)
;
alter table TIMETABLE.SOLVER_GROUP
  add constraint PK_SOLVER_GROUP primary key (UNIQUEID);
alter table TIMETABLE.SOLVER_GROUP
  add constraint FK_SOLVER_GROUP_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_GROUP
  add constraint NN_SOLVER_GROUP_ABBV
  check ("ABBV" IS NOT NULL);
alter table TIMETABLE.SOLVER_GROUP
  add constraint NN_SOLVER_GROUP_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.SOLVER_GROUP
  add constraint NN_SOLVER_GROUP_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.SOLVER_GROUP
  add constraint NN_SOLVER_GROUP_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_SOLVER_GROUP_SESSION on TIMETABLE.SOLVER_GROUP (SESSION_ID);

prompt
prompt Creating table SOLUTION
prompt =======================
prompt
create table TIMETABLE.SOLUTION
(
  UNIQUEID           NUMBER(20),
  CREATED            DATE,
  VALID              NUMBER(1),
  COMMITED           NUMBER(1),
  COMMIT_DATE        DATE,
  NOTE               VARCHAR2(1000),
  CREATOR            VARCHAR2(250),
  OWNER_ID           NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.SOLUTION
  add constraint PK_SOLUTION primary key (UNIQUEID);
alter table TIMETABLE.SOLUTION
  add constraint FK_SOLUTION_OWNER foreign key (OWNER_ID)
  references TIMETABLE.SOLVER_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLUTION
  add constraint NN_SOLUTION_COMMITED
  check ("COMMITED" IS NOT NULL);
alter table TIMETABLE.SOLUTION
  add constraint NN_SOLUTION_CREATED
  check ("CREATED" IS NOT NULL);
alter table TIMETABLE.SOLUTION
  add constraint NN_SOLUTION_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.SOLUTION
  add constraint NN_SOLUTION_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.SOLUTION
  add constraint NN_SOLUTION_VALID
  check ("VALID" IS NOT NULL);
create index TIMETABLE.IDX_SOLUTION_OWNER on TIMETABLE.SOLUTION (OWNER_ID);

prompt
prompt Creating table TIME_PATTERN
prompt ===========================
prompt
create table TIMETABLE.TIME_PATTERN
(
  UNIQUEID   NUMBER(20),
  NAME       VARCHAR2(50),
  MINS_PMT   NUMBER(10),
  SLOTS_PMT  NUMBER(10),
  NR_MTGS    NUMBER(10),
  VISIBLE    NUMBER(1),
  TYPE       NUMBER(10),
  BREAK_TIME NUMBER(3),
  SESSION_ID NUMBER(20)
)
;
alter table TIMETABLE.TIME_PATTERN
  add constraint PK_TIME_PATTERN primary key (UNIQUEID);
alter table TIMETABLE.TIME_PATTERN
  add constraint FK_TIME_PATTERN_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PATTERN
  add constraint NN_TIME_PATTERN_SESSION
  check (SESSION_ID IS NOT NULL);
alter table TIMETABLE.TIME_PATTERN
  add constraint NN_TIME_PATTERN_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_TIME_PATTERN_SESSION on TIMETABLE.TIME_PATTERN (SESSION_ID);

prompt
prompt Creating table ASSIGNMENT
prompt =========================
prompt
create table TIMETABLE.ASSIGNMENT
(
  UNIQUEID           NUMBER(20),
  DAYS               NUMBER(10),
  SLOT               NUMBER(10),
  TIME_PATTERN_ID    NUMBER(20),
  SOLUTION_ID        NUMBER(20),
  CLASS_ID           NUMBER(20),
  CLASS_NAME         VARCHAR2(100),
  LAST_MODIFIED_TIME TIMESTAMP(6),
  EVENT_ID           NUMBER(20)
)
;
alter table TIMETABLE.ASSIGNMENT
  add constraint PK_ASSIGNMENT primary key (UNIQUEID);
alter table TIMETABLE.ASSIGNMENT
  add constraint FK_ASSIGNMENT_CLASS foreign key (CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.ASSIGNMENT
  add constraint FK_ASSIGNMENT_EVENT foreign key (EVENT_ID)
  references TIMETABLE.EVENT (UNIQUEID) on delete set null;
alter table TIMETABLE.ASSIGNMENT
  add constraint FK_ASSIGNMENT_SOLUTION foreign key (SOLUTION_ID)
  references TIMETABLE.SOLUTION (UNIQUEID) on delete cascade;
alter table TIMETABLE.ASSIGNMENT
  add constraint FK_ASSIGNMENT_TIME_PATTERN foreign key (TIME_PATTERN_ID)
  references TIMETABLE.TIME_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.ASSIGNMENT
  add constraint NN_ASSIGNMENT_CLASS_ID
  check ("CLASS_ID" IS NOT NULL);
alter table TIMETABLE.ASSIGNMENT
  add constraint NN_ASSIGNMENT_CLASS_NAME
  check ("CLASS_NAME" IS NOT NULL);
alter table TIMETABLE.ASSIGNMENT
  add constraint NN_ASSIGNMENT_SOLUTION_ID
  check ("SOLUTION_ID" IS NOT NULL);
alter table TIMETABLE.ASSIGNMENT
  add constraint NN_ASSIGNMENT_TIME_PATTERN_ID
  check ("TIME_PATTERN_ID" IS NOT NULL);
alter table TIMETABLE.ASSIGNMENT
  add constraint NN_ASSIGNMENT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ASSIGNMENT_CLASS on TIMETABLE.ASSIGNMENT (CLASS_ID);
create index TIMETABLE.IDX_ASSIGNMENT_SOLUTION_INDEX on TIMETABLE.ASSIGNMENT (SOLUTION_ID);
create index TIMETABLE.IDX_ASSIGNMENT_TIME_PATTERN on TIMETABLE.ASSIGNMENT (TIME_PATTERN_ID);

prompt
prompt Creating table POSITION_TYPE
prompt ============================
prompt
create table TIMETABLE.POSITION_TYPE
(
  UNIQUEID   NUMBER(20),
  REFERENCE  VARCHAR2(20),
  LABEL      VARCHAR2(60),
  SORT_ORDER NUMBER(4)
)
;
alter table TIMETABLE.POSITION_TYPE
  add constraint PK_POSITION_TYPE primary key (UNIQUEID);
alter table TIMETABLE.POSITION_TYPE
  add constraint UK_POSITION_TYPE_LABEL unique (LABEL);
alter table TIMETABLE.POSITION_TYPE
  add constraint UK_POSITION_TYPE_REF unique (REFERENCE);
alter table TIMETABLE.POSITION_TYPE
  add constraint NN_POSITION_TYPE_LABEL
  check ("LABEL" IS NOT NULL);
alter table TIMETABLE.POSITION_TYPE
  add constraint NN_POSITION_TYPE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.POSITION_TYPE
  add constraint NN_POSITION_TYPE_SORT_ORDER
  check (sort_order is not null);
alter table TIMETABLE.POSITION_TYPE
  add constraint NN_POSITION_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table DEPARTMENT
prompt =========================
prompt
create table TIMETABLE.DEPARTMENT
(
  UNIQUEID           NUMBER(20),
  SESSION_ID         NUMBER(20),
  ABBREVIATION       VARCHAR2(20),
  NAME               VARCHAR2(100),
  DEPT_CODE          VARCHAR2(50),
  EXTERNAL_UID       VARCHAR2(40),
  RS_COLOR           VARCHAR2(6),
  EXTERNAL_MANAGER   NUMBER(1),
  EXTERNAL_MGR_LABEL VARCHAR2(30),
  EXTERNAL_MGR_ABBV  VARCHAR2(10),
  SOLVER_GROUP_ID    NUMBER(20),
  STATUS_TYPE        NUMBER(20),
  DIST_PRIORITY      NUMBER(10) default (0),
  ALLOW_REQ_TIME     NUMBER(1) default (0),
  ALLOW_REQ_ROOM     NUMBER(1) default (0),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.DEPARTMENT
  add constraint PK_DEPARTMENT primary key (UNIQUEID);
alter table TIMETABLE.DEPARTMENT
  add constraint UK_DEPARTMENT_DEPT_CODE unique (SESSION_ID, DEPT_CODE);
alter table TIMETABLE.DEPARTMENT
  add constraint FK_DEPARTMENT_SOLVER_GROUP foreign key (SOLVER_GROUP_ID)
  references TIMETABLE.SOLVER_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.DEPARTMENT
  add constraint FK_DEPARTMENT_STATUS_TYPE foreign key (STATUS_TYPE)
  references TIMETABLE.DEPT_STATUS_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.DEPARTMENT
  add constraint NN_DEPARTMENT_DEPT_CODE
  check ("DEPT_CODE" IS NOT NULL);
alter table TIMETABLE.DEPARTMENT
  add constraint NN_DEPARTMENT_DIST_PRIORITY
  check ("DIST_PRIORITY" IS NOT NULL);
alter table TIMETABLE.DEPARTMENT
  add constraint NN_DEPARTMENT_EXTERNAL_MANAGER
  check ("EXTERNAL_MANAGER" IS NOT NULL);
alter table TIMETABLE.DEPARTMENT
  add constraint NN_DEPARTMENT_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.DEPARTMENT
  add constraint NN_DEPARTMENT_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.DEPARTMENT
  add constraint NN_DEPARTMENT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_DEPARTMENT_SOLVER_GRP on TIMETABLE.DEPARTMENT (SOLVER_GROUP_ID);
create index TIMETABLE.IDX_DEPARTMENT_STATUS_TYPE on TIMETABLE.DEPARTMENT (STATUS_TYPE);

prompt
prompt Creating table DEPARTMENTAL_INSTRUCTOR
prompt ======================================
prompt
create table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
(
  UNIQUEID            NUMBER(20),
  EXTERNAL_UID        VARCHAR2(40),
  CAREER_ACCT         VARCHAR2(20),
  LNAME               VARCHAR2(26),
  FNAME               VARCHAR2(20),
  MNAME               VARCHAR2(20),
  POS_CODE_TYPE       NUMBER(20),
  NOTE                VARCHAR2(20),
  DEPARTMENT_UNIQUEID NUMBER(20),
  IGNORE_TOO_FAR      NUMBER(1) default 0,
  LAST_MODIFIED_TIME  TIMESTAMP(6),
  EMAIL               VARCHAR2(200)
)
;
alter table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
  add constraint PK_DEPT_INSTR primary key (UNIQUEID);
alter table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
  add constraint FK_DEPT_INSTR_DEPT foreign key (DEPARTMENT_UNIQUEID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
  add constraint FK_DEPT_INSTR_POS_CODE_TYPE foreign key (POS_CODE_TYPE)
  references TIMETABLE.POSITION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
  add constraint NN_DEPT_INSTR_DEPT_UNIQUEID
  check ("DEPARTMENT_UNIQUEID" IS NOT NULL);
alter table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
  add constraint NN_DEPT_INSTR_LNAME
  check ("LNAME" IS NOT NULL);
alter table TIMETABLE.DEPARTMENTAL_INSTRUCTOR
  add constraint NN_DEPT_INSTR_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_DEPT_INSTR_DEPT on TIMETABLE.DEPARTMENTAL_INSTRUCTOR (DEPARTMENT_UNIQUEID);
create index TIMETABLE.IDX_DEPT_INSTR_POSITION_TYPE on TIMETABLE.DEPARTMENTAL_INSTRUCTOR (POS_CODE_TYPE);

prompt
prompt Creating table ASSIGNED_INSTRUCTORS
prompt ===================================
prompt
create table TIMETABLE.ASSIGNED_INSTRUCTORS
(
  ASSIGNMENT_ID      NUMBER(20),
  INSTRUCTOR_ID      NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.ASSIGNED_INSTRUCTORS
  add constraint PK_ASSIGNED_INSTRUCTORS primary key (ASSIGNMENT_ID, INSTRUCTOR_ID);
alter table TIMETABLE.ASSIGNED_INSTRUCTORS
  add constraint FK_ASSIGNED_INSTRS_ASSIGNMENT foreign key (ASSIGNMENT_ID)
  references TIMETABLE.ASSIGNMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.ASSIGNED_INSTRUCTORS
  add constraint FK_ASSIGNED_INSTRS_INSTRUCTOR foreign key (INSTRUCTOR_ID)
  references TIMETABLE.DEPARTMENTAL_INSTRUCTOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.ASSIGNED_INSTRUCTORS
  add constraint NN_ASSIGNED_INSTRS_ASSGN_ID
  check ("ASSIGNMENT_ID" IS NOT NULL);
alter table TIMETABLE.ASSIGNED_INSTRUCTORS
  add constraint NN_ASSIGNED_INSTRS_INSTR_ID
  check ("INSTRUCTOR_ID" IS NOT NULL);
create index TIMETABLE.IDX_ASSIGNED_INSTRUCTORS on TIMETABLE.ASSIGNED_INSTRUCTORS (ASSIGNMENT_ID);

prompt
prompt Creating table ASSIGNED_ROOMS
prompt =============================
prompt
create table TIMETABLE.ASSIGNED_ROOMS
(
  ASSIGNMENT_ID      NUMBER(20),
  ROOM_ID            NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.ASSIGNED_ROOMS
  add constraint PK_ASSIGNED_ROOMS primary key (ASSIGNMENT_ID, ROOM_ID);
alter table TIMETABLE.ASSIGNED_ROOMS
  add constraint FK_ASSIGNED_ROOMS_ASSIGNMENT foreign key (ASSIGNMENT_ID)
  references TIMETABLE.ASSIGNMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.ASSIGNED_ROOMS
  add constraint NN_ASSIGNED_ROOMS_ASSIGN_ID
  check ("ASSIGNMENT_ID" IS NOT NULL);
alter table TIMETABLE.ASSIGNED_ROOMS
  add constraint NN_ASSIGNED_ROOMS_ROOM_ID
  check ("ROOM_ID" IS NOT NULL);
create index TIMETABLE.IDX_ASSIGNED_ROOMS on TIMETABLE.ASSIGNED_ROOMS (ASSIGNMENT_ID);

prompt
prompt Creating table BUILDING
prompt =======================
prompt
create table TIMETABLE.BUILDING
(
  UNIQUEID     NUMBER(20),
  SESSION_ID   NUMBER(20),
  ABBREVIATION VARCHAR2(10),
  NAME         VARCHAR2(100),
  COORDINATE_X NUMBER(10),
  COORDINATE_Y NUMBER(10),
  EXTERNAL_UID VARCHAR2(40)
)
;
alter table TIMETABLE.BUILDING
  add constraint PK_BUILDING primary key (UNIQUEID);
alter table TIMETABLE.BUILDING
  add constraint UK_BUILDING unique (SESSION_ID, ABBREVIATION);
alter table TIMETABLE.BUILDING
  add constraint FK_BUILDING_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.BUILDING
  add constraint NN_BUILDING_ABBREVIATION
  check ("ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.BUILDING
  add constraint NN_BUILDING_COORDINATE_X
  check ("COORDINATE_X" IS NOT NULL);
alter table TIMETABLE.BUILDING
  add constraint NN_BUILDING_COORDINATE_Y
  check ("COORDINATE_Y" IS NOT NULL);
alter table TIMETABLE.BUILDING
  add constraint NN_BUILDING_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.BUILDING
  add constraint NN_BUILDING_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.BUILDING
  add constraint NN_BUILDING_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table PREFERENCE_LEVEL
prompt ===============================
prompt
create table TIMETABLE.PREFERENCE_LEVEL
(
  PREF_ID     NUMBER(2),
  PREF_PROLOG VARCHAR2(2),
  PREF_NAME   VARCHAR2(20),
  UNIQUEID    NUMBER(20)
)
;
alter table TIMETABLE.PREFERENCE_LEVEL
  add constraint PK_PREFERENCE_LEVEL primary key (UNIQUEID);
alter table TIMETABLE.PREFERENCE_LEVEL
  add constraint UK_PREFERENCE_LEVEL_PREF_ID unique (PREF_ID);
alter table TIMETABLE.PREFERENCE_LEVEL
  add constraint NN_PREFERENCE_LEVEL_PREF_ID
  check ("PREF_ID" IS NOT NULL);
alter table TIMETABLE.PREFERENCE_LEVEL
  add constraint NN_PREFERENCE_LEVEL_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table BUILDING_PREF
prompt ============================
prompt
create table TIMETABLE.BUILDING_PREF
(
  UNIQUEID           NUMBER(20),
  OWNER_ID           NUMBER(20),
  PREF_LEVEL_ID      NUMBER(20),
  BLDG_ID            NUMBER(20),
  DISTANCE_FROM      NUMBER(5),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.BUILDING_PREF
  add constraint PK_BUILDING_PREF primary key (UNIQUEID);
alter table TIMETABLE.BUILDING_PREF
  add constraint FK_BUILDING_PREF_BLDG foreign key (BLDG_ID)
  references TIMETABLE.BUILDING (UNIQUEID) on delete cascade;
alter table TIMETABLE.BUILDING_PREF
  add constraint FK_BUILDING_PREF_LEVEL foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.BUILDING_PREF
  add constraint NN_BUILDING_PREF_BLDG_ID
  check ("BLDG_ID" IS NOT NULL);
alter table TIMETABLE.BUILDING_PREF
  add constraint NN_BUILDING_PREF_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.BUILDING_PREF
  add constraint NN_BUILDING_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_BUILDING_PREF_BLDG on TIMETABLE.BUILDING_PREF (BLDG_ID);
create index TIMETABLE.IDX_BUILDING_PREF_LEVEL on TIMETABLE.BUILDING_PREF (PREF_LEVEL_ID);
create index TIMETABLE.IDX_BUILDING_PREF_OWNER on TIMETABLE.BUILDING_PREF (OWNER_ID);

prompt
prompt Creating table SUBJECT_AREA
prompt ===========================
prompt
create table TIMETABLE.SUBJECT_AREA
(
  UNIQUEID                  NUMBER(20),
  SESSION_ID                NUMBER(20),
  SUBJECT_AREA_ABBREVIATION VARCHAR2(10),
  SHORT_TITLE               VARCHAR2(50),
  LONG_TITLE                VARCHAR2(100),
  SCHEDULE_BOOK_ONLY        VARCHAR2(1),
  PSEUDO_SUBJECT_AREA       VARCHAR2(1),
  DEPARTMENT_UNIQUEID       NUMBER(20),
  EXTERNAL_UID              VARCHAR2(40),
  LAST_MODIFIED_TIME        TIMESTAMP(6)
)
;
alter table TIMETABLE.SUBJECT_AREA
  add constraint PK_SUBJECT_AREA primary key (UNIQUEID);
alter table TIMETABLE.SUBJECT_AREA
  add constraint UK_SUBJECT_AREA unique (SESSION_ID, SUBJECT_AREA_ABBREVIATION);
alter table TIMETABLE.SUBJECT_AREA
  add constraint FK_SUBJECT_AREA_DEPT foreign key (DEPARTMENT_UNIQUEID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_DEPARTMENT_UID
  check ("DEPARTMENT_UNIQUEID" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_LONG_TITLE
  check ("LONG_TITLE" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_PSEUDO_SUBAREA
  check ("PSEUDO_SUBJECT_AREA" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_SCHE_BOOK_ONLY
  check ("SCHEDULE_BOOK_ONLY" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_SHORT_TITLE
  check ("SHORT_TITLE" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_SUBJ_AREA_ABBR
  check ("SUBJECT_AREA_ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.SUBJECT_AREA
  add constraint NN_SUBJECT_AREA_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_SUBJECT_AREA_DEPT on TIMETABLE.SUBJECT_AREA (DEPARTMENT_UNIQUEID);

prompt
prompt Creating table TIMETABLE_MANAGER
prompt ================================
prompt
create table TIMETABLE.TIMETABLE_MANAGER
(
  UNIQUEID           NUMBER(20),
  EXTERNAL_UID       VARCHAR2(40),
  FIRST_NAME         VARCHAR2(20),
  MIDDLE_NAME        VARCHAR2(20),
  LAST_NAME          VARCHAR2(30),
  EMAIL_ADDRESS      VARCHAR2(135),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.TIMETABLE_MANAGER
  add constraint PK_TIMETABLE_MANAGER primary key (UNIQUEID);
alter table TIMETABLE.TIMETABLE_MANAGER
  add constraint UK_TIMETABLE_MANAGER_PUID unique (EXTERNAL_UID);
alter table TIMETABLE.TIMETABLE_MANAGER
  add constraint NN_TIMETABLE_MANAGER_FIRST_NAM
  check ("FIRST_NAME" IS NOT NULL);
alter table TIMETABLE.TIMETABLE_MANAGER
  add constraint NN_TIMETABLE_MANAGER_LAST_NAME
  check ("LAST_NAME" IS NOT NULL);
alter table TIMETABLE.TIMETABLE_MANAGER
  add constraint NN_TIMETABLE_MANAGER_PUID
  check ("EXTERNAL_UID" IS NOT NULL);
alter table TIMETABLE.TIMETABLE_MANAGER
  add constraint NN_TIMETABLE_MANAGER_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table CHANGE_LOG
prompt =========================
prompt
create table TIMETABLE.CHANGE_LOG
(
  UNIQUEID      NUMBER(20),
  SESSION_ID    NUMBER(20),
  MANAGER_ID    NUMBER(20),
  TIME_STAMP    TIMESTAMP(9),
  OBJ_TYPE      VARCHAR2(255),
  OBJ_UID       NUMBER(20),
  OBJ_TITLE     VARCHAR2(255),
  SUBJ_AREA_ID  NUMBER(20),
  DEPARTMENT_ID NUMBER(20),
  SOURCE        VARCHAR2(50),
  OPERATION     VARCHAR2(50),
  DETAIL        BLOB
)
;
alter table TIMETABLE.CHANGE_LOG
  add constraint PK_CHANGE_LOG primary key (UNIQUEID);
alter table TIMETABLE.CHANGE_LOG
  add constraint FK_CHANGE_LOG_DEPARTMENT foreign key (DEPARTMENT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.CHANGE_LOG
  add constraint FK_CHANGE_LOG_MANAGER foreign key (MANAGER_ID)
  references TIMETABLE.TIMETABLE_MANAGER (UNIQUEID) on delete cascade;
alter table TIMETABLE.CHANGE_LOG
  add constraint FK_CHANGE_LOG_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.CHANGE_LOG
  add constraint FK_CHANGE_LOG_SUBJAREA foreign key (SUBJ_AREA_ID)
  references TIMETABLE.SUBJECT_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_MANAGER
  check ("MANAGER_ID" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_OBJTITLE
  check ("OBJ_TITLE" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_OBJTYPE
  check ("OBJ_TYPE" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_OBJUID
  check ("OBJ_UID" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_OP
  check ("OPERATION" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_SRC
  check ("SOURCE" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_TS
  check ("TIME_STAMP" IS NOT NULL);
alter table TIMETABLE.CHANGE_LOG
  add constraint NN_CHANGE_LOG_UID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_CHANGE_LOG_DEPARTMENT on TIMETABLE.CHANGE_LOG (DEPARTMENT_ID);
create index TIMETABLE.IDX_CHANGE_LOG_OBJECT on TIMETABLE.CHANGE_LOG (OBJ_TYPE, OBJ_UID);
create index TIMETABLE.IDX_CHANGE_LOG_SESSIONMGR on TIMETABLE.CHANGE_LOG (SESSION_ID, MANAGER_ID);
create index TIMETABLE.IDX_CHANGE_LOG_SUBJAREA on TIMETABLE.CHANGE_LOG (SUBJ_AREA_ID);

prompt
prompt Creating table CLASS_INSTRUCTOR
prompt ===============================
prompt
create table TIMETABLE.CLASS_INSTRUCTOR
(
  UNIQUEID           NUMBER(20),
  CLASS_ID           NUMBER(20),
  INSTRUCTOR_ID      NUMBER(20),
  PERCENT_SHARE      NUMBER(3),
  IS_LEAD            NUMBER(1),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint PK_CLASS_INSTRUCTOR_UNIQUEID primary key (UNIQUEID);
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint FK_CLASS_INSTRUCTOR_CLASS foreign key (CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint FK_CLASS_INSTRUCTOR_INSTR foreign key (INSTRUCTOR_ID)
  references TIMETABLE.DEPARTMENTAL_INSTRUCTOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint NN_CLASS_INSTRUCTOR_CLASS_ID
  check ("CLASS_ID" IS NOT NULL);
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint NN_CLASS_INSTRUCTOR_INSTR_ID
  check ("INSTRUCTOR_ID" IS NOT NULL);
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint NN_CLASS_INSTRUCTOR_IS_LEAD
  check ("IS_LEAD" IS NOT NULL);
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint NN_CLASS_INSTRUCTOR_PERC_SHARE
  check ("PERCENT_SHARE" IS NOT NULL);
alter table TIMETABLE.CLASS_INSTRUCTOR
  add constraint NN_CLASS_INSTRUCTOR_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_CLASS_INSTRUCTOR_CLASS on TIMETABLE.CLASS_INSTRUCTOR (CLASS_ID);
create index TIMETABLE.IDX_CLASS_INSTRUCTOR_INSTR on TIMETABLE.CLASS_INSTRUCTOR (INSTRUCTOR_ID);

prompt
prompt Creating table STUDENT_STATUS_TYPE
prompt ==================================
prompt
create table TIMETABLE.STUDENT_STATUS_TYPE
(
  UNIQUEID     NUMBER(20),
  ABBREVIATION VARCHAR2(20),
  NAME         VARCHAR2(50)
)
;
alter table TIMETABLE.STUDENT_STATUS_TYPE
  add constraint PK_STUDENT_STATUS_TYPE primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_STATUS_TYPE
  add constraint NN_STUDENT_STATUS_TYPE_ABBV
  check ("ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.STUDENT_STATUS_TYPE
  add constraint NN_STUDENT_STATUS_TYPE_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.STUDENT_STATUS_TYPE
  add constraint NN_STUDENT_STATUS_TYPE_UID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table STUDENT
prompt ======================
prompt
create table TIMETABLE.STUDENT
(
  UNIQUEID            NUMBER(20),
  EXTERNAL_UID        VARCHAR2(40),
  FIRST_NAME          VARCHAR2(50),
  MIDDLE_NAME         VARCHAR2(50),
  LAST_NAME           VARCHAR2(100),
  EMAIL               VARCHAR2(200),
  FREE_TIME_CAT       NUMBER(10) default (0),
  SCHEDULE_PREFERENCE NUMBER(10) default (0),
  STATUS_TYPE_ID      NUMBER(20),
  STATUS_CHANGE_DATE  DATE,
  SESSION_ID          NUMBER(20)
)
;
alter table TIMETABLE.STUDENT
  add constraint PK_STUDENT primary key (UNIQUEID);
alter table TIMETABLE.STUDENT
  add constraint FK_STUDENT_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT
  add constraint FK_STUDENT_STATUS_STUDENT foreign key (STATUS_TYPE_ID)
  references TIMETABLE.STUDENT_STATUS_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT
  add constraint NN_STUDENT_FNAME
  check ("FIRST_NAME" IS NOT NULL);
alter table TIMETABLE.STUDENT
  add constraint NN_STUDENT_FT_CAT
  check ("FREE_TIME_CAT" IS NOT NULL);
alter table TIMETABLE.STUDENT
  add constraint NN_STUDENT_LNAME
  check ("LAST_NAME" IS NOT NULL);
alter table TIMETABLE.STUDENT
  add constraint NN_STUDENT_SCH_PREF
  check ("SCHEDULE_PREFERENCE" IS NOT NULL);
alter table TIMETABLE.STUDENT
  add constraint NN_STUDENT_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT
  add constraint NN_STUDENT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STUDENT_SESSION on TIMETABLE.STUDENT (SESSION_ID);

prompt
prompt Creating table FREE_TIME
prompt ========================
prompt
create table TIMETABLE.FREE_TIME
(
  UNIQUEID   NUMBER(20),
  NAME       VARCHAR2(50),
  DAY_CODE   NUMBER(10),
  START_SLOT NUMBER(10),
  LENGTH     NUMBER(10),
  CATEGORY   NUMBER(10),
  SESSION_ID NUMBER(20)
)
;
alter table TIMETABLE.FREE_TIME
  add constraint PK_FREE_TIME primary key (UNIQUEID);
alter table TIMETABLE.FREE_TIME
  add constraint FK_FREE_TIME_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_CATEGORY
  check ("CATEGORY" IS NOT NULL);
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_DAY_CODE
  check ("DAY_CODE" IS NOT NULL);
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_LENGTH
  check ("LENGTH" IS NOT NULL);
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_START_SLOT
  check ("START_SLOT" IS NOT NULL);
alter table TIMETABLE.FREE_TIME
  add constraint NN_FREE_TIME_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table COURSE_DEMAND
prompt ============================
prompt
create table TIMETABLE.COURSE_DEMAND
(
  UNIQUEID       NUMBER(20),
  STUDENT_ID     NUMBER(20),
  PRIORITY       NUMBER(10),
  WAITLIST       NUMBER(1),
  IS_ALTERNATIVE NUMBER(1),
  TIMESTAMP      DATE,
  FREE_TIME_ID   NUMBER(20)
)
;
alter table TIMETABLE.COURSE_DEMAND
  add constraint PK_COURSE_DEMAND primary key (UNIQUEID);
alter table TIMETABLE.COURSE_DEMAND
  add constraint FK_COURSE_DEMAND_FREE_TIME foreign key (FREE_TIME_ID)
  references TIMETABLE.FREE_TIME (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_DEMAND
  add constraint FK_COURSE_DEMAND_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_DEMAND
  add constraint NN_COURSE_DEMAND_IS_ALT
  check ("IS_ALTERNATIVE" IS NOT NULL);
alter table TIMETABLE.COURSE_DEMAND
  add constraint NN_COURSE_DEMAND_PRIORITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.COURSE_DEMAND
  add constraint NN_COURSE_DEMAND_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_DEMAND
  add constraint NN_COURSE_DEMAND_TIMESTAMP
  check ("TIMESTAMP" IS NOT NULL);
alter table TIMETABLE.COURSE_DEMAND
  add constraint NN_COURSE_DEMAND_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.COURSE_DEMAND
  add constraint NN_COURSE_DEMAND_WAITLIST
  check ("WAITLIST" IS NOT NULL);
create index TIMETABLE.IDX_COURSE_DEMAND_FREE_TIME on TIMETABLE.COURSE_DEMAND (FREE_TIME_ID);
create index TIMETABLE.IDX_COURSE_DEMAND_STUDENT on TIMETABLE.COURSE_DEMAND (STUDENT_ID);

prompt
prompt Creating table COURSE_OFFERING
prompt ==============================
prompt
create table TIMETABLE.COURSE_OFFERING
(
  UNIQUEID             NUMBER(20),
  COURSE_NBR           VARCHAR2(10),
  IS_CONTROL           NUMBER(1),
  PERM_ID              VARCHAR2(20),
  PROJ_DEMAND          NUMBER(10),
  INSTR_OFFR_ID        NUMBER(20),
  SUBJECT_AREA_ID      NUMBER(20),
  TITLE                VARCHAR2(90),
  SCHEDULE_BOOK_NOTE   VARCHAR2(1000),
  DEMAND_OFFERING_ID   NUMBER(20),
  DEMAND_OFFERING_TYPE NUMBER(20),
  NBR_EXPECTED_STDENTS NUMBER(10) default (0),
  EXTERNAL_UID         VARCHAR2(40),
  LAST_MODIFIED_TIME   TIMESTAMP(6),
  UID_ROLLED_FWD_FROM  NUMBER(20),
  LASTLIKE_DEMAND      NUMBER(10) default 0
)
;
alter table TIMETABLE.COURSE_OFFERING
  add constraint PK_COURSE_OFFERING primary key (UNIQUEID);
alter table TIMETABLE.COURSE_OFFERING
  add constraint UK_COURSE_OFFERING_SUBJ_CRS unique (COURSE_NBR, SUBJECT_AREA_ID);
alter table TIMETABLE.COURSE_OFFERING
  add constraint FK_COURSE_OFFERING_DEMAND_OFFR foreign key (DEMAND_OFFERING_ID)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_OFFERING
  add constraint FK_COURSE_OFFERING_INSTR_OFFR foreign key (INSTR_OFFR_ID)
  references TIMETABLE.INSTRUCTIONAL_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_OFFERING
  add constraint FK_COURSE_OFFERING_SUBJ_AREA foreign key (SUBJECT_AREA_ID)
  references TIMETABLE.SUBJECT_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_COURSE_NBR
  check ("COURSE_NBR" IS NOT NULL);
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_EXPST
  check ("NBR_EXPECTED_STDENTS" IS NOT NULL);
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_INSTROFFRID
  check ("INSTR_OFFR_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_IS_CONTROL
  check ("IS_CONTROL" IS NOT NULL);
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_LL_DEMAND
  check ("LASTLIKE_DEMAND" IS NOT NULL);
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_SUBJAREA_ID
  check ("SUBJECT_AREA_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_OFFERING
  add constraint NN_COURSE_OFFERING_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_COURSE_OFFERING_CONTROL on TIMETABLE.COURSE_OFFERING (IS_CONTROL);
create index TIMETABLE.IDX_COURSE_OFFERING_DEMD_OFFR on TIMETABLE.COURSE_OFFERING (DEMAND_OFFERING_ID);
create index TIMETABLE.IDX_COURSE_OFFERING_INSTR_OFFR on TIMETABLE.COURSE_OFFERING (INSTR_OFFR_ID);

prompt
prompt Creating table COURSE_REQUEST
prompt =============================
prompt
create table TIMETABLE.COURSE_REQUEST
(
  UNIQUEID           NUMBER(20),
  COURSE_DEMAND_ID   NUMBER(20),
  COURSE_OFFERING_ID NUMBER(20),
  ORD                NUMBER(10),
  ALLOW_OVERLAP      NUMBER(1),
  CREDIT             NUMBER(10) default (0)
)
;
alter table TIMETABLE.COURSE_REQUEST
  add constraint PK_COURSE_REQUEST primary key (UNIQUEID);
alter table TIMETABLE.COURSE_REQUEST
  add constraint FK_COURSE_REQUEST_DEMAND foreign key (COURSE_DEMAND_ID)
  references TIMETABLE.COURSE_DEMAND (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_REQUEST
  add constraint FK_COURSE_REQUEST_OFFERING foreign key (COURSE_OFFERING_ID)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_REQUEST
  add constraint NN_COURSE_REQUEST_CREDIT
  check ("CREDIT" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST
  add constraint NN_COURSE_REQUEST_DEMAND
  check ("COURSE_DEMAND_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST
  add constraint NN_COURSE_REQUEST_OFFERING
  check ("COURSE_OFFERING_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST
  add constraint NN_COURSE_REQUEST_ORDER
  check ("ORD" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST
  add constraint NN_COURSE_REQUEST_OVERLAP
  check ("ALLOW_OVERLAP" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST
  add constraint NN_COURSE_REQUEST_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_COURSE_REQUEST_DEMAND on TIMETABLE.COURSE_REQUEST (COURSE_DEMAND_ID);
create index TIMETABLE.IDX_COURSE_REQUEST_OFFERING on TIMETABLE.COURSE_REQUEST (COURSE_OFFERING_ID);

prompt
prompt Creating table CLASS_WAITLIST
prompt =============================
prompt
create table TIMETABLE.CLASS_WAITLIST
(
  UNIQUEID          NUMBER(20),
  STUDENT_ID        NUMBER(20),
  COURSE_REQUEST_ID NUMBER(20),
  CLASS_ID          NUMBER(20),
  TYPE              NUMBER(10) default (0),
  TIMESTAMP         DATE
)
;
alter table TIMETABLE.CLASS_WAITLIST
  add constraint PK_CLASS_WAITLIST primary key (UNIQUEID);
alter table TIMETABLE.CLASS_WAITLIST
  add constraint FK_CLASS_WAITLIST_CLASS foreign key (CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_WAITLIST
  add constraint FK_CLASS_WAITLIST_REQUEST foreign key (COURSE_REQUEST_ID)
  references TIMETABLE.COURSE_REQUEST (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_WAITLIST
  add constraint FK_CLASS_WAITLIST_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.CLASS_WAITLIST
  add constraint NN_CLASS_WAITLIST_CLASS
  check ("CLASS_ID" IS NOT NULL);
alter table TIMETABLE.CLASS_WAITLIST
  add constraint NN_CLASS_WAITLIST_COURSE
  check ("COURSE_REQUEST_ID" IS NOT NULL);
alter table TIMETABLE.CLASS_WAITLIST
  add constraint NN_CLASS_WAITLIST_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.CLASS_WAITLIST
  add constraint NN_CLASS_WAITLIST_TIMESTMP
  check ("TIMESTAMP" IS NOT NULL);
alter table TIMETABLE.CLASS_WAITLIST
  add constraint NN_CLASS_WAITLIST_TYPE
  check ("TYPE" IS NOT NULL);
alter table TIMETABLE.CLASS_WAITLIST
  add constraint NN_CLASS_WAITLIST_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_CLASS_WAITLIST_CLASS on TIMETABLE.CLASS_WAITLIST (CLASS_ID);
create index TIMETABLE.IDX_CLASS_WAITLIST_REQ on TIMETABLE.CLASS_WAITLIST (COURSE_REQUEST_ID);
create index TIMETABLE.IDX_CLASS_WAITLIST_STUDENT on TIMETABLE.CLASS_WAITLIST (STUDENT_ID);

prompt
prompt Creating table SOLVER_INFO_DEF
prompt ==============================
prompt
create table TIMETABLE.SOLVER_INFO_DEF
(
  UNIQUEID       NUMBER(20),
  NAME           VARCHAR2(100),
  DESCRIPTION    VARCHAR2(1000),
  IMPLEMENTATION VARCHAR2(250)
)
;
alter table TIMETABLE.SOLVER_INFO_DEF
  add constraint PK_SOLVER_INFO_DEF primary key (UNIQUEID);
alter table TIMETABLE.SOLVER_INFO_DEF
  add constraint NN_SOLVER_INFO_DEF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table SOLVER_INFO
prompt ==========================
prompt
create table TIMETABLE.SOLVER_INFO
(
  UNIQUEID           NUMBER(20),
  TYPE               NUMBER(10),
  VALUE              BLOB,
  OPT                VARCHAR2(250),
  SOLVER_INFO_DEF_ID NUMBER(20),
  SOLUTION_ID        NUMBER(20),
  ASSIGNMENT_ID      NUMBER(20)
)
;
alter table TIMETABLE.SOLVER_INFO
  add constraint PK_SOLVER_INFO primary key (UNIQUEID);
alter table TIMETABLE.SOLVER_INFO
  add constraint FK_SOLVER_INFO_ASSIGNMENT foreign key (ASSIGNMENT_ID)
  references TIMETABLE.ASSIGNMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_INFO
  add constraint FK_SOLVER_INFO_DEF foreign key (SOLVER_INFO_DEF_ID)
  references TIMETABLE.SOLVER_INFO_DEF (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_INFO
  add constraint FK_SOLVER_INFO_SOLUTION foreign key (SOLUTION_ID)
  references TIMETABLE.SOLUTION (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_INFO
  add constraint NN_SOLVER_INFO_TYPE
  check ("TYPE" IS NOT NULL);
alter table TIMETABLE.SOLVER_INFO
  add constraint NN_SOLVER_INFO_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.SOLVER_INFO
  add constraint NN_SOLVER_INFO_VALUE
  check ("VALUE" IS NOT NULL);
create index TIMETABLE.IDX_SOLVER_INFO on TIMETABLE.SOLVER_INFO (ASSIGNMENT_ID);
create index TIMETABLE.IDX_SOLVER_INFO_SOLUTION on TIMETABLE.SOLVER_INFO (SOLUTION_ID, SOLVER_INFO_DEF_ID);

prompt
prompt Creating table CONSTRAINT_INFO
prompt ==============================
prompt
create table TIMETABLE.CONSTRAINT_INFO
(
  ASSIGNMENT_ID  NUMBER(20),
  SOLVER_INFO_ID NUMBER(20)
)
;
alter table TIMETABLE.CONSTRAINT_INFO
  add constraint UK_CONSTRAINT_INFO_SOLV_ASSGN primary key (SOLVER_INFO_ID, ASSIGNMENT_ID);
alter table TIMETABLE.CONSTRAINT_INFO
  add constraint FK_CONSTRAINT_INFO_ASSIGNMENT foreign key (ASSIGNMENT_ID)
  references TIMETABLE.ASSIGNMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.CONSTRAINT_INFO
  add constraint FK_CONSTRAINT_INFO_SOLVER foreign key (SOLVER_INFO_ID)
  references TIMETABLE.SOLVER_INFO (UNIQUEID) on delete cascade;
alter table TIMETABLE.CONSTRAINT_INFO
  add constraint NN_CONSTRAINT_INFO_ASSIGN_ID
  check ("ASSIGNMENT_ID" IS NOT NULL);
alter table TIMETABLE.CONSTRAINT_INFO
  add constraint NN_CONSTRAINT_INFO_SOL_INFO_ID
  check ("SOLVER_INFO_ID" IS NOT NULL);
create index TIMETABLE.IDX_CONSTRAINT_INFO on TIMETABLE.CONSTRAINT_INFO (ASSIGNMENT_ID);

prompt
prompt Creating table COURSE_CATALOG
prompt =============================
prompt
create table TIMETABLE.COURSE_CATALOG
(
  UNIQUEID            NUMBER(20) not null,
  SESSION_ID          NUMBER(20),
  EXTERNAL_UID        VARCHAR2(40),
  SUBJECT             VARCHAR2(10),
  COURSE_NBR          VARCHAR2(10),
  TITLE               VARCHAR2(100),
  PERM_ID             VARCHAR2(20),
  APPROVAL_TYPE       VARCHAR2(20),
  DESIGNATOR_REQ      NUMBER(1),
  PREV_SUBJECT        VARCHAR2(10),
  PREV_CRS_NBR        VARCHAR2(10),
  CREDIT_TYPE         VARCHAR2(20),
  CREDIT_UNIT_TYPE    VARCHAR2(20),
  CREDIT_FORMAT       VARCHAR2(20),
  FIXED_MIN_CREDIT    NUMBER(10),
  MAX_CREDIT          NUMBER(10),
  FRAC_CREDIT_ALLOWED NUMBER(1)
)
;
alter table TIMETABLE.COURSE_CATALOG
  add constraint PK_COURSE_CATALOG primary key (UNIQUEID);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_CRED
  check ("FIXED_MIN_CREDIT" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_CRED_FMT
  check ("CREDIT_FORMAT" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_CRED_TYPE
  check ("CREDIT_TYPE" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_CRED_UNIT
  check ("CREDIT_UNIT_TYPE" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_CRS_NBR
  check ("COURSE_NBR" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_DES_REQ
  check ("DESIGNATOR_REQ" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_SUBJ
  check ("SUBJECT" IS NOT NULL);
alter table TIMETABLE.COURSE_CATALOG
  add constraint NN_CRS_CATLOG_TITLE
  check ("TITLE" IS NOT NULL);
create index TIMETABLE.IDX_COURSE_CATALOG on TIMETABLE.COURSE_CATALOG (SESSION_ID, SUBJECT, COURSE_NBR);

prompt
prompt Creating table COURSE_CREDIT_TYPE
prompt =================================
prompt
create table TIMETABLE.COURSE_CREDIT_TYPE
(
  UNIQUEID                NUMBER(20),
  REFERENCE               VARCHAR2(20),
  LABEL                   VARCHAR2(60),
  ABBREVIATION            VARCHAR2(10),
  LEGACY_CRSE_MASTER_CODE VARCHAR2(10)
)
;
alter table TIMETABLE.COURSE_CREDIT_TYPE
  add constraint PK_COURSE_CREDIT_TYPE primary key (UNIQUEID);
alter table TIMETABLE.COURSE_CREDIT_TYPE
  add constraint UK_COURSE_CREDIT_TYPE_REF unique (REFERENCE);
alter table TIMETABLE.COURSE_CREDIT_TYPE
  add constraint NN_COURSE_CREDIT_TYPE_REF
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.COURSE_CREDIT_TYPE
  add constraint NN_COURSE_CREDIT_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table COURSE_CREDIT_UNIT_CONFIG
prompt ========================================
prompt
create table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
(
  UNIQUEID                       NUMBER(20),
  CREDIT_FORMAT                  VARCHAR2(20),
  OWNER_ID                       NUMBER(20),
  CREDIT_TYPE                    NUMBER(20),
  CREDIT_UNIT_TYPE               NUMBER(20),
  DEFINES_CREDIT_AT_COURSE_LEVEL NUMBER(1),
  FIXED_UNITS                    NUMBER,
  MIN_UNITS                      NUMBER,
  MAX_UNITS                      NUMBER,
  FRACTIONAL_INCR_ALLOWED        NUMBER(1),
  INSTR_OFFR_ID                  NUMBER(20),
  LAST_MODIFIED_TIME             TIMESTAMP(6)
)
;
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint PK_CRS_CRDT_UNIT_CFG primary key (UNIQUEID);
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint FK_CRS_CRDT_UNIT_CFG_CRDT_TYPE foreign key (CREDIT_TYPE)
  references TIMETABLE.COURSE_CREDIT_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint FK_CRS_CRDT_UNIT_CFG_IO_OWN foreign key (INSTR_OFFR_ID)
  references TIMETABLE.INSTRUCTIONAL_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint FK_CRS_CRDT_UNIT_CFG_OWNER foreign key (OWNER_ID)
  references TIMETABLE.SCHEDULING_SUBPART (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint NN_CRS_CRDT_UNIT_CFG_CRDT_FMT
  check ("CREDIT_FORMAT" IS NOT NULL);
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint NN_CRS_CRDT_UNIT_CFG_CRDT_TYPE
  check ("CREDIT_TYPE" IS NOT NULL);
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint NN_CRS_CRDT_UNIT_CFG_DEF_LEVEL
  check ("DEFINES_CREDIT_AT_COURSE_LEVEL" IS NOT NULL);
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint NN_CRS_CRDT_UNIT_CFG_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.COURSE_CREDIT_UNIT_CONFIG
  add constraint NN_CRS_CRDT_UNIT_CFG_UNIT_TYPE
  check ("CREDIT_UNIT_TYPE" IS NOT NULL);
create index TIMETABLE.IDX_CRS_CRDT_UNIT_CFG_CRD_TYPE on TIMETABLE.COURSE_CREDIT_UNIT_CONFIG (CREDIT_TYPE);
create index TIMETABLE.IDX_CRS_CRDT_UNIT_CFG_IO_OWN on TIMETABLE.COURSE_CREDIT_UNIT_CONFIG (INSTR_OFFR_ID);
create index TIMETABLE.IDX_CRS_CRDT_UNIT_CFG_OWNER on TIMETABLE.COURSE_CREDIT_UNIT_CONFIG (OWNER_ID);

prompt
prompt Creating table COURSE_CREDIT_UNIT_TYPE
prompt ======================================
prompt
create table TIMETABLE.COURSE_CREDIT_UNIT_TYPE
(
  UNIQUEID     NUMBER(20),
  REFERENCE    VARCHAR2(20),
  LABEL        VARCHAR2(60),
  ABBREVIATION VARCHAR2(10)
)
;
alter table TIMETABLE.COURSE_CREDIT_UNIT_TYPE
  add constraint PK_CRS_CRDT_UNIT_TYPE primary key (UNIQUEID);
alter table TIMETABLE.COURSE_CREDIT_UNIT_TYPE
  add constraint UK_CRS_CRDT_UNIT_TYPE_REF unique (REFERENCE);
alter table TIMETABLE.COURSE_CREDIT_UNIT_TYPE
  add constraint NN_CRS_CRDT_UNIT_TYPE_REF
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.COURSE_CREDIT_UNIT_TYPE
  add constraint NN_CRS_CRDT_UNIT_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table COURSE_REQUEST_OPTION
prompt ====================================
prompt
create table TIMETABLE.COURSE_REQUEST_OPTION
(
  UNIQUEID          NUMBER(20),
  COURSE_REQUEST_ID NUMBER(20),
  OPTION_TYPE       NUMBER(10),
  VALUE             BLOB
)
;
alter table TIMETABLE.COURSE_REQUEST_OPTION
  add constraint PK_COURSE_REQUEST_OPTION primary key (UNIQUEID);
alter table TIMETABLE.COURSE_REQUEST_OPTION
  add constraint FK_COURSE_REQUEST_OPTIONS_REQ foreign key (COURSE_REQUEST_ID)
  references TIMETABLE.COURSE_REQUEST (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_REQUEST_OPTION
  add constraint NN_COURSE_REQUEST_OPT_REQ
  check ("COURSE_REQUEST_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST_OPTION
  add constraint NN_COURSE_REQUEST_OPT_TYPE
  check ("OPTION_TYPE" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST_OPTION
  add constraint NN_COURSE_REQUEST_OPT_UID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.COURSE_REQUEST_OPTION
  add constraint NN_COURSE_REQUEST_OPT_VALUE
  check ("VALUE" IS NOT NULL);
create index TIMETABLE.IDX_COURSE_REQUEST_OPTION_REQ on TIMETABLE.COURSE_REQUEST_OPTION (COURSE_REQUEST_ID);

prompt
prompt Creating table COURSE_RESERVATION
prompt =================================
prompt
create table TIMETABLE.COURSE_RESERVATION
(
  UNIQUEID             NUMBER(20),
  OWNER                NUMBER(20),
  RESERVATION_TYPE     NUMBER(20),
  COURSE_OFFERING      NUMBER(20),
  PRIORITY             NUMBER(5),
  RESERVED             NUMBER(10),
  PRIOR_ENROLLMENT     NUMBER(10),
  PROJECTED_ENROLLMENT NUMBER(10),
  OWNER_CLASS_ID       VARCHAR2(1),
  REQUESTED            NUMBER(10),
  LAST_MODIFIED_TIME   TIMESTAMP(6)
)
;
alter table TIMETABLE.COURSE_RESERVATION
  add constraint PK_COURSE_RESV primary key (UNIQUEID);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint FK_COURSE_RESERV_TYPE foreign key (RESERVATION_TYPE)
  references TIMETABLE.RESERVATION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_RESERVATION
  add constraint FK_COURSE_RESV_CRS_OFFR foreign key (COURSE_OFFERING)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_CRS_OFFR
  check ("COURSE_OFFERING" IS NOT NULL);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_OWNER
  check ("OWNER" IS NOT NULL);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_OWNER_CLASS_ID
  check ("OWNER_CLASS_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_PRIORITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_RESERVED
  check ("RESERVED" IS NOT NULL);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_RESERV_TYPE
  check ("RESERVATION_TYPE" IS NOT NULL);
alter table TIMETABLE.COURSE_RESERVATION
  add constraint NN_COURSE_RESV_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_COURSE_RESV_CRS_OFFR on TIMETABLE.COURSE_RESERVATION (COURSE_OFFERING);
create index TIMETABLE.IDX_COURSE_RESV_OWNER on TIMETABLE.COURSE_RESERVATION (OWNER);
create index TIMETABLE.IDX_COURSE_RESV_OWNER_CLS on TIMETABLE.COURSE_RESERVATION (OWNER_CLASS_ID);
create index TIMETABLE.IDX_COURSE_RESV_TYPE on TIMETABLE.COURSE_RESERVATION (RESERVATION_TYPE);

prompt
prompt Creating table COURSE_SUBPART_CREDIT
prompt ====================================
prompt
create table TIMETABLE.COURSE_SUBPART_CREDIT
(
  UNIQUEID            NUMBER(20) not null,
  COURSE_CATALOG_ID   NUMBER(20),
  SUBPART_ID          VARCHAR2(10),
  CREDIT_TYPE         VARCHAR2(20),
  CREDIT_UNIT_TYPE    VARCHAR2(20),
  CREDIT_FORMAT       VARCHAR2(20),
  FIXED_MIN_CREDIT    NUMBER(10),
  MAX_CREDIT          NUMBER(10),
  FRAC_CREDIT_ALLOWED NUMBER(1)
)
;
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint PK_COURSE_SUBPART_CREDIT primary key (UNIQUEID);
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint FK_SUBPART_CRED_CRS foreign key (COURSE_CATALOG_ID)
  references TIMETABLE.COURSE_CATALOG (UNIQUEID) on delete cascade;
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint NN_CRS_SUBPART_CRED
  check ("FIXED_MIN_CREDIT" IS NOT NULL);
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint NN_CRS_SUBPART_CRED_CRS_ID
  check ("COURSE_CATALOG_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint NN_CRS_SUBPART_CRED_FMT
  check ("CREDIT_FORMAT" IS NOT NULL);
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint NN_CRS_SUBPART_CRED_SUB_ID
  check ("SUBPART_ID" IS NOT NULL);
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint NN_CRS_SUBPART_CRED_TYPE
  check ("CREDIT_TYPE" IS NOT NULL);
alter table TIMETABLE.COURSE_SUBPART_CREDIT
  add constraint NN_CRS_SUBPART_CRED_UNIT
  check ("CREDIT_UNIT_TYPE" IS NOT NULL);

prompt
prompt Creating table CRSE_CREDIT_FORMAT
prompt =================================
prompt
create table TIMETABLE.CRSE_CREDIT_FORMAT
(
  UNIQUEID     NUMBER(20),
  REFERENCE    VARCHAR2(20),
  LABEL        VARCHAR2(60),
  ABBREVIATION VARCHAR2(10)
)
;
alter table TIMETABLE.CRSE_CREDIT_FORMAT
  add constraint PK_CRSE_CREDIT_FORMAT primary key (UNIQUEID);
alter table TIMETABLE.CRSE_CREDIT_FORMAT
  add constraint UK_CRSE_CREDIT_FORMAT_REF unique (REFERENCE);
alter table TIMETABLE.CRSE_CREDIT_FORMAT
  add constraint NN_CRSE_CREDIT_FORMAT_REF
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.CRSE_CREDIT_FORMAT
  add constraint NN_CRSE_CREDIT_FORMAT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table DATE_PATTERN_DEPT
prompt ================================
prompt
create table TIMETABLE.DATE_PATTERN_DEPT
(
  DEPT_ID    NUMBER(20),
  PATTERN_ID NUMBER(20)
)
;
alter table TIMETABLE.DATE_PATTERN_DEPT
  add constraint PK_DATE_PATTERN_DEPT primary key (DEPT_ID, PATTERN_ID);
alter table TIMETABLE.DATE_PATTERN_DEPT
  add constraint FK_DATE_PATTERN_DEPT_DATE foreign key (PATTERN_ID)
  references TIMETABLE.DATE_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.DATE_PATTERN_DEPT
  add constraint FK_DATE_PATTERN_DEPT_DEPT foreign key (DEPT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.DATE_PATTERN_DEPT
  add constraint NN_DATE_PATTERN_DEPT_DEPT_ID
  check ("DEPT_ID" IS NOT NULL);
alter table TIMETABLE.DATE_PATTERN_DEPT
  add constraint NN_DATE_PATTERN_DEPT_PATT_ID
  check ("PATTERN_ID" IS NOT NULL);

prompt
prompt Creating table DEMAND_OFFR_TYPE
prompt ===============================
prompt
create table TIMETABLE.DEMAND_OFFR_TYPE
(
  UNIQUEID  NUMBER(20),
  REFERENCE VARCHAR2(20),
  LABEL     VARCHAR2(60)
)
;
alter table TIMETABLE.DEMAND_OFFR_TYPE
  add constraint PK_DEMAND_OFFR_TYPE primary key (UNIQUEID);
alter table TIMETABLE.DEMAND_OFFR_TYPE
  add constraint UK_DEMAND_OFFR_TYPE_LABEL unique (LABEL);
alter table TIMETABLE.DEMAND_OFFR_TYPE
  add constraint UK_DEMAND_OFFR_TYPE_REF unique (REFERENCE);
alter table TIMETABLE.DEMAND_OFFR_TYPE
  add constraint NN_DEMAND_OFFR_TYPE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.DEMAND_OFFR_TYPE
  add constraint NN_DEMAND_OFFR_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table DEPT_TO_TT_MGR
prompt =============================
prompt
create table TIMETABLE.DEPT_TO_TT_MGR
(
  TIMETABLE_MGR_ID NUMBER(20),
  DEPARTMENT_ID    NUMBER(20)
)
;
alter table TIMETABLE.DEPT_TO_TT_MGR
  add constraint PK_DEPT_TO_TT_MGR_UID primary key (TIMETABLE_MGR_ID, DEPARTMENT_ID);
alter table TIMETABLE.DEPT_TO_TT_MGR
  add constraint FK_DEPT_TO_TT_MGR_DEPT foreign key (DEPARTMENT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.DEPT_TO_TT_MGR
  add constraint FK_DEPT_TO_TT_MGR_MGR foreign key (TIMETABLE_MGR_ID)
  references TIMETABLE.TIMETABLE_MANAGER (UNIQUEID) on delete cascade;
alter table TIMETABLE.DEPT_TO_TT_MGR
  add constraint NN_DEPT_TO_TT_MGR_DEPT_ID
  check ("DEPARTMENT_ID" IS NOT NULL);
alter table TIMETABLE.DEPT_TO_TT_MGR
  add constraint NN_DEPT_TO_TT_MGR_TMTBL_MGR_ID
  check ("TIMETABLE_MGR_ID" IS NOT NULL);

prompt
prompt Creating table DESIGNATOR
prompt =========================
prompt
create table TIMETABLE.DESIGNATOR
(
  UNIQUEID           NUMBER(20),
  SUBJECT_AREA_ID    NUMBER(20),
  INSTRUCTOR_ID      NUMBER(20),
  CODE               VARCHAR2(3),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.DESIGNATOR
  add constraint PK_DESIGNATOR primary key (UNIQUEID);
alter table TIMETABLE.DESIGNATOR
  add constraint UK_DESIGNATOR_CODE unique (SUBJECT_AREA_ID, INSTRUCTOR_ID, CODE);
alter table TIMETABLE.DESIGNATOR
  add constraint FK_DESIGNATOR_INSTRUCTOR foreign key (INSTRUCTOR_ID)
  references TIMETABLE.DEPARTMENTAL_INSTRUCTOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.DESIGNATOR
  add constraint FK_DESIGNATOR_SUBJ_AREA foreign key (SUBJECT_AREA_ID)
  references TIMETABLE.SUBJECT_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.DESIGNATOR
  add constraint NN_DESIGNATOR_CODE
  check ("CODE" IS NOT NULL);
alter table TIMETABLE.DESIGNATOR
  add constraint NN_DESIGNATOR_INSTRUCTOR_ID
  check ("INSTRUCTOR_ID" IS NOT NULL);
alter table TIMETABLE.DESIGNATOR
  add constraint NN_DESIGNATOR_SUBJECT_AREA_ID
  check ("SUBJECT_AREA_ID" IS NOT NULL);
alter table TIMETABLE.DESIGNATOR
  add constraint NN_DESIGNATOR_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table DISTRIBUTION_TYPE
prompt ================================
prompt
create table TIMETABLE.DISTRIBUTION_TYPE
(
  UNIQUEID            NUMBER(20),
  REFERENCE           VARCHAR2(20),
  LABEL               VARCHAR2(60),
  SEQUENCING_REQUIRED VARCHAR2(1) default '0',
  REQ_ID              NUMBER(6),
  ALLOWED_PREF        VARCHAR2(10),
  DESCRIPTION         VARCHAR2(2048),
  ABBREVIATION        VARCHAR2(20),
  INSTRUCTOR_PREF     NUMBER(1) default (0),
  EXAM_PREF           NUMBER(1) default 0
)
;
alter table TIMETABLE.DISTRIBUTION_TYPE
  add constraint PK_DISTRIBUTION_TYPE primary key (UNIQUEID);
alter table TIMETABLE.DISTRIBUTION_TYPE
  add constraint UK_DISTRIBUTION_TYPE_REQ_ID unique (REQ_ID);
alter table TIMETABLE.DISTRIBUTION_TYPE
  add constraint NN_DISTRIBUTION_TYPE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_TYPE
  add constraint NN_DISTRIBUTION_TYPE_REQ_ID
  check ("REQ_ID" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_TYPE
  add constraint NN_DISTRIBUTION_TYPE_SEQ_REQD
  check ("SEQUENCING_REQUIRED" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_TYPE
  add constraint NN_DISTRIBUTION_TYPE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table DISTRIBUTION_PREF
prompt ================================
prompt
create table TIMETABLE.DISTRIBUTION_PREF
(
  UNIQUEID            NUMBER(20),
  OWNER_ID            NUMBER(20),
  PREF_LEVEL_ID       NUMBER(20),
  DIST_TYPE_ID        NUMBER(20),
  GROUPING            NUMBER(10),
  LAST_MODIFIED_TIME  TIMESTAMP(6),
  UID_ROLLED_FWD_FROM NUMBER(20)
)
;
alter table TIMETABLE.DISTRIBUTION_PREF
  add constraint PK_DISTRIBUTION_PREF primary key (UNIQUEID);
alter table TIMETABLE.DISTRIBUTION_PREF
  add constraint FK_DISTRIBUTION_PREF_DIST_TYPE foreign key (DIST_TYPE_ID)
  references TIMETABLE.DISTRIBUTION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.DISTRIBUTION_PREF
  add constraint FK_DISTRIBUTION_PREF_LEVEL foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.DISTRIBUTION_PREF
  add constraint NN_DISTRIBUTION_PREF_DIST_TYPE
  check ("DIST_TYPE_ID" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_PREF
  add constraint NN_DISTRIBUTION_PREF_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_PREF
  add constraint NN_DISTRIBUTION_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_DISTRIBUTION_PREF_LEVEL on TIMETABLE.DISTRIBUTION_PREF (PREF_LEVEL_ID);
create index TIMETABLE.IDX_DISTRIBUTION_PREF_OWNER on TIMETABLE.DISTRIBUTION_PREF (OWNER_ID);
create index TIMETABLE.IDX_DISTRIBUTION_PREF_TYPE on TIMETABLE.DISTRIBUTION_PREF (DIST_TYPE_ID);

prompt
prompt Creating table DISTRIBUTION_OBJECT
prompt ==================================
prompt
create table TIMETABLE.DISTRIBUTION_OBJECT
(
  UNIQUEID           NUMBER(20),
  DIST_PREF_ID       NUMBER(20),
  SEQUENCE_NUMBER    NUMBER(3),
  PREF_GROUP_ID      NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.DISTRIBUTION_OBJECT
  add constraint PK_DISTRIBUTION_OBJECT primary key (UNIQUEID);
alter table TIMETABLE.DISTRIBUTION_OBJECT
  add constraint FK_DISTRIBUTION_OBJECT_PREF foreign key (DIST_PREF_ID)
  references TIMETABLE.DISTRIBUTION_PREF (UNIQUEID) on delete cascade;
alter table TIMETABLE.DISTRIBUTION_OBJECT
  add constraint NN_DISTRIBUTION_OBJECT_PREFID
  check ("DIST_PREF_ID" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_OBJECT
  add constraint NN_DISTRIBUTION_OBJECT_PRGRPID
  check ("PREF_GROUP_ID" IS NOT NULL);
alter table TIMETABLE.DISTRIBUTION_OBJECT
  add constraint NN_DISTRIBUTION_OBJ_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_DISTRIBUTION_OBJECT_PG on TIMETABLE.DISTRIBUTION_OBJECT (PREF_GROUP_ID);
create index TIMETABLE.IDX_DISTRIBUTION_OBJECT_PREF on TIMETABLE.DISTRIBUTION_OBJECT (DIST_PREF_ID);

prompt
prompt Creating table DIST_TYPE_DEPT
prompt =============================
prompt
create table TIMETABLE.DIST_TYPE_DEPT
(
  DIST_TYPE_ID NUMBER(19),
  DEPT_ID      NUMBER(20)
)
;
alter table TIMETABLE.DIST_TYPE_DEPT
  add constraint PK_DIST_TYPE_DEPT primary key (DIST_TYPE_ID, DEPT_ID);
alter table TIMETABLE.DIST_TYPE_DEPT
  add constraint FK_DIST_TYPE_DEPT_DEPT foreign key (DEPT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.DIST_TYPE_DEPT
  add constraint FK_DIST_TYPE_DEPT_TYPE foreign key (DIST_TYPE_ID)
  references TIMETABLE.DISTRIBUTION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.DIST_TYPE_DEPT
  add constraint NN_DIST_TYPE_DEPT_DEPT_ID
  check ("DEPT_ID" IS NOT NULL);
alter table TIMETABLE.DIST_TYPE_DEPT
  add constraint NN_DIST_TYPE_DEPT_DIST_TYPE_ID
  check ("DIST_TYPE_ID" IS NOT NULL);

prompt
prompt Creating table EVENT_JOIN_EVENT_CONTACT
prompt =======================================
prompt
create table TIMETABLE.EVENT_JOIN_EVENT_CONTACT
(
  EVENT_ID         NUMBER(20),
  EVENT_CONTACT_ID NUMBER(20)
)
;
alter table TIMETABLE.EVENT_JOIN_EVENT_CONTACT
  add constraint FK_EVENT_CONTACT_JOIN foreign key (EVENT_CONTACT_ID)
  references TIMETABLE.EVENT_CONTACT (UNIQUEID) on delete cascade;
alter table TIMETABLE.EVENT_JOIN_EVENT_CONTACT
  add constraint FK_EVENT_ID_JOIN foreign key (EVENT_ID)
  references TIMETABLE.EVENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.EVENT_JOIN_EVENT_CONTACT
  add constraint NN_EVENT_JOIN_EVENT_CONTACT_ID
  check ("EVENT_CONTACT_ID" IS NOT NULL);
alter table TIMETABLE.EVENT_JOIN_EVENT_CONTACT
  add constraint NN_EVENT_JOIN_EVENT_ID
  check ("EVENT_ID" IS NOT NULL);

prompt
prompt Creating table STANDARD_EVENT_NOTE
prompt ==================================
prompt
create table TIMETABLE.STANDARD_EVENT_NOTE
(
  UNIQUEID  NUMBER(20),
  REFERENCE VARCHAR2(20),
  NOTE      VARCHAR2(1000)
)
;
alter table TIMETABLE.STANDARD_EVENT_NOTE
  add constraint PK_STANDARD_EVENT_NOTE primary key (UNIQUEID);
alter table TIMETABLE.STANDARD_EVENT_NOTE
  add constraint NN_STD_EVENT_NOTE_NOTE
  check ("NOTE" IS NOT NULL);
alter table TIMETABLE.STANDARD_EVENT_NOTE
  add constraint NN_STD_EVENT_NOTE_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.STANDARD_EVENT_NOTE
  add constraint NN_STD_EVENT_NOTE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EVENT_NOTE
prompt =========================
prompt
create table TIMETABLE.EVENT_NOTE
(
  UNIQUEID  NUMBER(20),
  EVENT_ID  NUMBER(20),
  NOTE_ID   NUMBER(20),
  TEXT_NOTE VARCHAR2(1000)
)
;
alter table TIMETABLE.EVENT_NOTE
  add constraint PK_EVENT_NOTE_UNIQUEID primary key (UNIQUEID);
alter table TIMETABLE.EVENT_NOTE
  add constraint FK_EVENT_NOTE_EVENT foreign key (EVENT_ID)
  references TIMETABLE.EVENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.EVENT_NOTE
  add constraint FK_EVENT_NOTE_STD_NOTE foreign key (NOTE_ID)
  references TIMETABLE.STANDARD_EVENT_NOTE (UNIQUEID) on delete set null;
alter table TIMETABLE.EVENT_NOTE
  add constraint NN_EVENT_NOTE_EVENT_UNIQUEID
  check ("EVENT_ID" IS NOT NULL);
alter table TIMETABLE.EVENT_NOTE
  add constraint NN_EVENT_NOTE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EXACT_TIME_MINS
prompt ==============================
prompt
create table TIMETABLE.EXACT_TIME_MINS
(
  UNIQUEID   NUMBER(20),
  MINS_MIN   NUMBER(4),
  MINS_MAX   NUMBER(4),
  NR_SLOTS   NUMBER(4),
  BREAK_TIME NUMBER(4)
)
;
alter table TIMETABLE.EXACT_TIME_MINS
  add constraint PK_EXACT_TIME_MINS primary key (UNIQUEID);
alter table TIMETABLE.EXACT_TIME_MINS
  add constraint NN_EXACT_TIME_MINS_BREAK
  check ("BREAK_TIME" IS NOT NULL);
alter table TIMETABLE.EXACT_TIME_MINS
  add constraint NN_EXACT_TIME_MINS_MAX
  check ("MINS_MAX" IS NOT NULL);
alter table TIMETABLE.EXACT_TIME_MINS
  add constraint NN_EXACT_TIME_MINS_MIN
  check ("MINS_MIN" IS NOT NULL);
alter table TIMETABLE.EXACT_TIME_MINS
  add constraint NN_EXACT_TIME_MINS_SLOTS
  check ("NR_SLOTS" IS NOT NULL);
alter table TIMETABLE.EXACT_TIME_MINS
  add constraint NN_EXACT_TIME_MINS_UID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_EXACT_TIME_MINS on TIMETABLE.EXACT_TIME_MINS (MINS_MIN, MINS_MAX);

prompt
prompt Creating table EXAM_PERIOD
prompt ==========================
prompt
create table TIMETABLE.EXAM_PERIOD
(
  UNIQUEID      NUMBER(20),
  SESSION_ID    NUMBER(20),
  DATE_OFS      NUMBER(10),
  START_SLOT    NUMBER(10),
  LENGTH        NUMBER(10),
  PREF_LEVEL_ID NUMBER(20),
  EXAM_TYPE     NUMBER(10) default 0
)
;
alter table TIMETABLE.EXAM_PERIOD
  add constraint PK_EXAM_PERIOD primary key (UNIQUEID);
alter table TIMETABLE.EXAM_PERIOD
  add constraint FK_EXAM_PERIOD_PREF foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_PERIOD
  add constraint FK_EXAM_PERIOD_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_PERIOD
  add constraint NN_EXAM_PERIOD_DATE_OFS
  check ("DATE_OFS" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD
  add constraint NN_EXAM_PERIOD_LENGTH
  check ("LENGTH" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD
  add constraint NN_EXAM_PERIOD_PREF
  check ("PREF_LEVEL_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD
  add constraint NN_EXAM_PERIOD_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD
  add constraint NN_EXAM_PERIOD_START_SLOT
  check ("START_SLOT" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD
  add constraint NN_EXAM_PERIOD_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EXAM
prompt ===================
prompt
create table TIMETABLE.EXAM
(
  UNIQUEID            NUMBER(20),
  SESSION_ID          NUMBER(20),
  NAME                VARCHAR2(100),
  NOTE                VARCHAR2(1000),
  LENGTH              NUMBER(10),
  MAX_NBR_ROOMS       NUMBER(10) default 1,
  SEATING_TYPE        NUMBER(10),
  ASSIGNED_PERIOD     NUMBER(20),
  ASSIGNED_PREF       VARCHAR2(100),
  EXAM_TYPE           NUMBER(10) default 0,
  EVENT_ID            NUMBER(20),
  AVG_PERIOD          NUMBER(10),
  UID_ROLLED_FWD_FROM NUMBER(20)
)
;
alter table TIMETABLE.EXAM
  add constraint PK_EXAM primary key (UNIQUEID);
alter table TIMETABLE.EXAM
  add constraint FK_EXAM_EVENT foreign key (EVENT_ID)
  references TIMETABLE.EVENT (UNIQUEID) on delete set null;
alter table TIMETABLE.EXAM
  add constraint FK_EXAM_PERIOD foreign key (ASSIGNED_PERIOD)
  references TIMETABLE.EXAM_PERIOD (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM
  add constraint FK_EXAM_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM
  add constraint NN_EXAM_LENGTH
  check ("LENGTH" IS NOT NULL);
alter table TIMETABLE.EXAM
  add constraint NN_EXAM_NBR_ROOMS
  check ("MAX_NBR_ROOMS" IS NOT NULL);
alter table TIMETABLE.EXAM
  add constraint NN_EXAM_SEATING
  check ("SEATING_TYPE" IS NOT NULL);
alter table TIMETABLE.EXAM
  add constraint NN_EXAM_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.EXAM
  add constraint NN_EXAM_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EXAM_INSTRUCTOR
prompt ==============================
prompt
create table TIMETABLE.EXAM_INSTRUCTOR
(
  EXAM_ID       NUMBER(20),
  INSTRUCTOR_ID NUMBER(20)
)
;
alter table TIMETABLE.EXAM_INSTRUCTOR
  add constraint PK_EXAM_INSTRUCTOR primary key (EXAM_ID, INSTRUCTOR_ID);
alter table TIMETABLE.EXAM_INSTRUCTOR
  add constraint FK_EXAM_INSTRUCTOR_EXAM foreign key (EXAM_ID)
  references TIMETABLE.EXAM (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_INSTRUCTOR
  add constraint FK_EXAM_INSTRUCTOR_INSTRUCTOR foreign key (INSTRUCTOR_ID)
  references TIMETABLE.DEPARTMENTAL_INSTRUCTOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_INSTRUCTOR
  add constraint NN_EXAM_INSTRUCTOR_EXAM
  check ("EXAM_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_INSTRUCTOR
  add constraint NN_EXAM_INSTRUCTOR_INSTRUCTOR
  check ("INSTRUCTOR_ID" IS NOT NULL);

prompt
prompt Creating table EXAM_LOCATION_PREF
prompt =================================
prompt
create table TIMETABLE.EXAM_LOCATION_PREF
(
  UNIQUEID      NUMBER(20),
  LOCATION_ID   NUMBER(20),
  PREF_LEVEL_ID NUMBER(20),
  PERIOD_ID     NUMBER(20)
)
;
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint PK_EXAM_LOCATION_PREF primary key (UNIQUEID);
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint FK_EXAM_LOCATION_PREF_PERIOD foreign key (PERIOD_ID)
  references TIMETABLE.EXAM_PERIOD (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint FK_EXAM_LOCATION_PREF_PREF foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint NN_EXAM_LOCATION_PREF_OWNER
  check ("LOCATION_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint NN_EXAM_LOCATION_PREF_PERIOD
  check ("PERIOD_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint NN_EXAM_LOCATION_PREF_PREF
  check ("PREF_LEVEL_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_LOCATION_PREF
  add constraint NN_EXAM_LOCATION_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_EXAM_LOCATION_PREF on TIMETABLE.EXAM_LOCATION_PREF (LOCATION_ID);

prompt
prompt Creating table EXAM_OWNER
prompt =========================
prompt
create table TIMETABLE.EXAM_OWNER
(
  UNIQUEID   NUMBER(20),
  EXAM_ID    NUMBER(20),
  OWNER_ID   NUMBER(20),
  OWNER_TYPE NUMBER(10),
  COURSE_ID  NUMBER(20)
)
;
alter table TIMETABLE.EXAM_OWNER
  add constraint PK_EXAM_OWNER primary key (UNIQUEID);
alter table TIMETABLE.EXAM_OWNER
  add constraint FK_EXAM_OWNER_COURSE foreign key (COURSE_ID)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_OWNER
  add constraint FK_EXAM_OWNER_EXAM foreign key (EXAM_ID)
  references TIMETABLE.EXAM (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_OWNER
  add constraint NN_EXAM_OWNER_COURSE
  check (course_id is not null);
alter table TIMETABLE.EXAM_OWNER
  add constraint NN_EXAM_OWNER_EXAM_ID
  check ("EXAM_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_OWNER
  add constraint NN_EXAM_OWNER_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_OWNER
  add constraint NN_EXAM_OWNER_OWNER_TYPE
  check ("OWNER_TYPE" IS NOT NULL);
alter table TIMETABLE.EXAM_OWNER
  add constraint NN_EXAM_OWNER_UNIQUE_ID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_EXAM_OWNER_COURSE on TIMETABLE.EXAM_OWNER (COURSE_ID);
create index TIMETABLE.IDX_EXAM_OWNER_EXAM on TIMETABLE.EXAM_OWNER (EXAM_ID);
create index TIMETABLE.IDX_EXAM_OWNER_OWNER on TIMETABLE.EXAM_OWNER (OWNER_ID, OWNER_TYPE);

prompt
prompt Creating table EXAM_PERIOD_PREF
prompt ===============================
prompt
create table TIMETABLE.EXAM_PERIOD_PREF
(
  UNIQUEID      NUMBER(20),
  OWNER_ID      NUMBER(20),
  PREF_LEVEL_ID NUMBER(20),
  PERIOD_ID     NUMBER(20)
)
;
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint PK_EXAM_PERIOD_PREF primary key (UNIQUEID);
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint FK_EXAM_PERIOD_PREF_PERIOD foreign key (PERIOD_ID)
  references TIMETABLE.EXAM_PERIOD (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint FK_EXAM_PERIOD_PREF_PREF foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint NN_EXAM_PERIOD_PREF_OWNER
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint NN_EXAM_PERIOD_PREF_PERIOD
  check ("PERIOD_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint NN_EXAM_PERIOD_PREF_PREF
  check ("PREF_LEVEL_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_PERIOD_PREF
  add constraint NN_EXAM_PERIOD_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table EXAM_ROOM_ASSIGNMENT
prompt ===================================
prompt
create table TIMETABLE.EXAM_ROOM_ASSIGNMENT
(
  EXAM_ID     NUMBER(20),
  LOCATION_ID NUMBER(20)
)
;
alter table TIMETABLE.EXAM_ROOM_ASSIGNMENT
  add constraint PK_EXAM_ROOM_ASSIGNMENT primary key (EXAM_ID, LOCATION_ID);
alter table TIMETABLE.EXAM_ROOM_ASSIGNMENT
  add constraint FK_EXAM_ROOM_EXAM foreign key (EXAM_ID)
  references TIMETABLE.EXAM (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXAM_ROOM_ASSIGNMENT
  add constraint NN_EXAM_ROOM_EXAM_ID
  check ("EXAM_ID" IS NOT NULL);
alter table TIMETABLE.EXAM_ROOM_ASSIGNMENT
  add constraint NN_EXAM_ROOM_LOCATION_ID
  check ("LOCATION_ID" IS NOT NULL);

prompt
prompt Creating table EXTERNAL_BUILDING
prompt ================================
prompt
create table TIMETABLE.EXTERNAL_BUILDING
(
  UNIQUEID     NUMBER(20) not null,
  SESSION_ID   NUMBER(20),
  EXTERNAL_UID VARCHAR2(40),
  ABBREVIATION VARCHAR2(10),
  COORDINATE_X NUMBER(10),
  COORDINATE_Y NUMBER(10),
  DISPLAY_NAME VARCHAR2(100)
)
;
alter table TIMETABLE.EXTERNAL_BUILDING
  add constraint PK_EXTERNAL_BLDG primary key (UNIQUEID);
alter table TIMETABLE.EXTERNAL_BUILDING
  add constraint NN_EXTERNAL_BLDG_ABBV
  check ("ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_BUILDING
  add constraint NN_EXTERNAL_BLDG_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
create index TIMETABLE.IDX_EXTERNAL_BUILDING on TIMETABLE.EXTERNAL_BUILDING (SESSION_ID, ABBREVIATION);

prompt
prompt Creating table EXTERNAL_ROOM
prompt ============================
prompt
create table TIMETABLE.EXTERNAL_ROOM
(
  UNIQUEID            NUMBER(20) not null,
  EXTERNAL_BLDG_ID    NUMBER(20),
  EXTERNAL_UID        VARCHAR2(40),
  ROOM_NUMBER         VARCHAR2(10),
  COORDINATE_X        NUMBER(10),
  COORDINATE_Y        NUMBER(10),
  CAPACITY            NUMBER(10),
  CLASSIFICATION      VARCHAR2(20),
  SCHEDULED_ROOM_TYPE VARCHAR2(20),
  INSTRUCTIONAL       NUMBER(1),
  DISPLAY_NAME        VARCHAR2(100),
  EXAM_CAPACITY       NUMBER(10)
)
;
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint PK_EXTERNAL_ROOM primary key (UNIQUEID);
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint FK_EXT_ROOM_BUILDING foreign key (EXTERNAL_BLDG_ID)
  references TIMETABLE.EXTERNAL_BUILDING (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint NN_EXTERNAL_RM_BLDG_ID
  check ("EXTERNAL_BLDG_ID" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint NN_EXTERNAL_RM_CAPACITY
  check ("CAPACITY" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint NN_EXTERNAL_RM_CLASS
  check ("CLASSIFICATION" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint NN_EXTERNAL_RM_INSTR
  check ("INSTRUCTIONAL" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint NN_EXTERNAL_RM_NBR
  check ("ROOM_NUMBER" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM
  add constraint NN_EXTERNAL_RM_SCHED_TYPE
  check ("SCHEDULED_ROOM_TYPE" IS NOT NULL);
create index TIMETABLE.IDX_EXTERNAL_ROOM on TIMETABLE.EXTERNAL_ROOM (EXTERNAL_BLDG_ID, ROOM_NUMBER);

prompt
prompt Creating table EXTERNAL_ROOM_DEPARTMENT
prompt =======================================
prompt
create table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
(
  UNIQUEID         NUMBER(20) not null,
  EXTERNAL_ROOM_ID NUMBER(20),
  DEPARTMENT_CODE  VARCHAR2(50),
  PERCENT          NUMBER(10),
  ASSIGNMENT_TYPE  VARCHAR2(20)
)
;
alter table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
  add constraint PK_EXTERNAL_ROOM_DEPT primary key (UNIQUEID);
alter table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
  add constraint FK_EXT_DEPT_ROOM foreign key (EXTERNAL_ROOM_ID)
  references TIMETABLE.EXTERNAL_ROOM (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
  add constraint NN_EXTERNAL_RM_DEPT_ASSGN
  check ("ASSIGNMENT_TYPE" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
  add constraint NN_EXTERNAL_RM_DEPT_CODE
  check ("DEPARTMENT_CODE" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
  add constraint NN_EXTERNAL_RM_DEPT_PCNT
  check ("PERCENT" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM_DEPARTMENT
  add constraint NN_EXTERNAL_RM_DEPT_ROOM_ID
  check ("EXTERNAL_ROOM_ID" IS NOT NULL);

prompt
prompt Creating table EXTERNAL_ROOM_FEATURE
prompt ====================================
prompt
create table TIMETABLE.EXTERNAL_ROOM_FEATURE
(
  UNIQUEID         NUMBER(20) not null,
  EXTERNAL_ROOM_ID NUMBER(20),
  NAME             VARCHAR2(20),
  VALUE            VARCHAR2(20)
)
;
alter table TIMETABLE.EXTERNAL_ROOM_FEATURE
  add constraint PK_EXTERNAL_ROOM_FEATURE primary key (UNIQUEID);
alter table TIMETABLE.EXTERNAL_ROOM_FEATURE
  add constraint FK_EXT_FTR_ROOM foreign key (EXTERNAL_ROOM_ID)
  references TIMETABLE.EXTERNAL_ROOM (UNIQUEID) on delete cascade;
alter table TIMETABLE.EXTERNAL_ROOM_FEATURE
  add constraint NN_EXTERNAL_RM_FTR_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM_FEATURE
  add constraint NN_EXTERNAL_RM_FTR_ROOM_ID
  check ("EXTERNAL_ROOM_ID" IS NOT NULL);
alter table TIMETABLE.EXTERNAL_ROOM_FEATURE
  add constraint NN_EXTERNAL_RM_FTR_VALUE
  check ("VALUE" IS NOT NULL);

prompt
prompt Creating table HISTORY
prompt ======================
prompt
create table TIMETABLE.HISTORY
(
  UNIQUEID   NUMBER(20),
  SUBCLASS   VARCHAR2(10),
  OLD_VALUE  VARCHAR2(20),
  NEW_VALUE  VARCHAR2(20),
  OLD_NUMBER VARCHAR2(20),
  NEW_NUMBER VARCHAR2(20),
  SESSION_ID NUMBER(20)
)
;
alter table TIMETABLE.HISTORY
  add constraint PK_HISTORY primary key (UNIQUEID);
alter table TIMETABLE.HISTORY
  add constraint FK_HISTORY_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.HISTORY
  add constraint NN_HISTORY_NEW_VALUE
  check ("NEW_VALUE" IS NOT NULL);
alter table TIMETABLE.HISTORY
  add constraint NN_HISTORY_OLD_VALUE
  check ("OLD_VALUE" IS NOT NULL);
alter table TIMETABLE.HISTORY
  add constraint NN_HISTORY_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.HISTORY
  add constraint NN_HISTORY_SUBCLASS
  check ("SUBCLASS" IS NOT NULL);
alter table TIMETABLE.HISTORY
  add constraint NN_HISTORY_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_HISTORY_SESSION on TIMETABLE.HISTORY (SESSION_ID);

prompt
prompt Creating table INDIVIDUAL_RESERVATION
prompt =====================================
prompt
create table TIMETABLE.INDIVIDUAL_RESERVATION
(
  UNIQUEID           NUMBER(20),
  OWNER              NUMBER(20),
  RESERVATION_TYPE   NUMBER(20),
  PRIORITY           NUMBER(5),
  EXTERNAL_UID       VARCHAR2(40),
  OVER_LIMIT         NUMBER(1),
  EXPIRATION_DATE    DATE,
  OWNER_CLASS_ID     VARCHAR2(1),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint PK_INDIVIDUAL_RESV primary key (UNIQUEID);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint FK_INDIVIDUAL_RESV_TYPE foreign key (RESERVATION_TYPE)
  references TIMETABLE.RESERVATION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_EXP_DATE
  check ("EXPIRATION_DATE" IS NOT NULL);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_OVERLIMIT
  check ("OVER_LIMIT" IS NOT NULL);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_OWNER
  check ("OWNER" IS NOT NULL);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_OWNER_CLSID
  check ("OWNER_CLASS_ID" IS NOT NULL);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_PRIORITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_RESERV_TYPE
  check ("RESERVATION_TYPE" IS NOT NULL);
alter table TIMETABLE.INDIVIDUAL_RESERVATION
  add constraint NN_INDIVIDUAL_RESV_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_INDIVIDUAL_RESV_OWNER on TIMETABLE.INDIVIDUAL_RESERVATION (OWNER);
create index TIMETABLE.IDX_INDIVIDUAL_RESV_OWNER_CLS on TIMETABLE.INDIVIDUAL_RESERVATION (OWNER_CLASS_ID);
create index TIMETABLE.IDX_INDIVIDUAL_RESV_TYPE on TIMETABLE.INDIVIDUAL_RESERVATION (RESERVATION_TYPE);

prompt
prompt Creating table JENRL
prompt ====================
prompt
create table TIMETABLE.JENRL
(
  UNIQUEID    NUMBER(20),
  JENRL       FLOAT,
  SOLUTION_ID NUMBER(20),
  CLASS1_ID   NUMBER(20),
  CLASS2_ID   NUMBER(20)
)
;
alter table TIMETABLE.JENRL
  add constraint PK_JENRL primary key (UNIQUEID);
alter table TIMETABLE.JENRL
  add constraint FK_JENRL_CLASS1 foreign key (CLASS1_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.JENRL
  add constraint FK_JENRL_CLASS2 foreign key (CLASS2_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.JENRL
  add constraint FK_JENRL_SOLUTION foreign key (SOLUTION_ID)
  references TIMETABLE.SOLUTION (UNIQUEID) on delete cascade;
alter table TIMETABLE.JENRL
  add constraint NN_JENRL_CLASS1_ID
  check ("CLASS1_ID" IS NOT NULL);
alter table TIMETABLE.JENRL
  add constraint NN_JENRL_CLASS2_ID
  check ("CLASS2_ID" IS NOT NULL);
alter table TIMETABLE.JENRL
  add constraint NN_JENRL_JENRL
  check ("JENRL" IS NOT NULL);
alter table TIMETABLE.JENRL
  add constraint NN_JENRL_SOLUTION_ID
  check ("SOLUTION_ID" IS NOT NULL);
alter table TIMETABLE.JENRL
  add constraint NN_JENRL_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_JENRL on TIMETABLE.JENRL (SOLUTION_ID);
create index TIMETABLE.IDX_JENRL_CLASS1 on TIMETABLE.JENRL (CLASS1_ID);
create index TIMETABLE.IDX_JENRL_CLASS2 on TIMETABLE.JENRL (CLASS2_ID);

prompt
prompt Creating table LASTLIKE_COURSE_DEMAND
prompt =====================================
prompt
create table TIMETABLE.LASTLIKE_COURSE_DEMAND
(
  UNIQUEID        NUMBER(20),
  STUDENT_ID      NUMBER(20),
  SUBJECT_AREA_ID NUMBER(20),
  COURSE_NBR      VARCHAR2(10),
  PRIORITY        NUMBER(10) default (0),
  COURSE_PERM_ID  VARCHAR2(20)
)
;
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint PK_LASTLIKE_COURSE_DEMAND primary key (UNIQUEID);
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint FK_LL_COURSE_DEMAND_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint FK_LL_COURSE_DEMAND_SUBJAREA foreign key (SUBJECT_AREA_ID)
  references TIMETABLE.SUBJECT_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint NN_LL_COURSE_DEMAND_AREA
  check ("SUBJECT_AREA_ID" IS NOT NULL);
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint NN_LL_COURSE_DEMAND_COURSENBR
  check ("COURSE_NBR" IS NOT NULL);
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint NN_LL_COURSE_DEMAND_PRIRITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint NN_LL_COURSE_DEMAND_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.LASTLIKE_COURSE_DEMAND
  add constraint NN_LL_COURSE_DEMAND_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_LL_COURSE_DEMAND_COURSE on TIMETABLE.LASTLIKE_COURSE_DEMAND (SUBJECT_AREA_ID, COURSE_NBR);
create index TIMETABLE.IDX_LL_COURSE_DEMAND_PERMID on TIMETABLE.LASTLIKE_COURSE_DEMAND (COURSE_PERM_ID);
create index TIMETABLE.IDX_LL_COURSE_DEMAND_STUDENT on TIMETABLE.LASTLIKE_COURSE_DEMAND (STUDENT_ID);

prompt
prompt Creating table SETTINGS
prompt =======================
prompt
create table TIMETABLE.SETTINGS
(
  UNIQUEID       NUMBER(20),
  NAME           VARCHAR2(30),
  DEFAULT_VALUE  VARCHAR2(100),
  ALLOWED_VALUES VARCHAR2(500),
  DESCRIPTION    VARCHAR2(100)
)
;
alter table TIMETABLE.SETTINGS
  add constraint PK_SETTINGS primary key (UNIQUEID);
alter table TIMETABLE.SETTINGS
  add constraint NN_SETTINGS_ALLOWED_VALUES
  check ("ALLOWED_VALUES" IS NOT NULL);
alter table TIMETABLE.SETTINGS
  add constraint NN_SETTINGS_DEFAULT_VALUE
  check ("DEFAULT_VALUE" IS NOT NULL);
alter table TIMETABLE.SETTINGS
  add constraint NN_SETTINGS_DESCRIPTION
  check ("DESCRIPTION" IS NOT NULL);
alter table TIMETABLE.SETTINGS
  add constraint NN_SETTINGS_KEY
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.SETTINGS
  add constraint NN_SETTINGS_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table MANAGER_SETTINGS
prompt ===============================
prompt
create table TIMETABLE.MANAGER_SETTINGS
(
  UNIQUEID      NUMBER(20),
  KEY_ID        NUMBER(20),
  VALUE         VARCHAR2(100),
  USER_UNIQUEID NUMBER(20)
)
;
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint PK_MANAGER_SETTINGS primary key (UNIQUEID);
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint FK_MANAGER_SETTINGS_KEY foreign key (KEY_ID)
  references TIMETABLE.SETTINGS (UNIQUEID) on delete cascade;
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint FK_MANAGER_SETTINGS_USER foreign key (USER_UNIQUEID)
  references TIMETABLE.TIMETABLE_MANAGER (UNIQUEID) on delete cascade;
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint NN_MANAGER_SETTINGS_KEY_ID
  check ("KEY_ID" IS NOT NULL);
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint NN_MANAGER_SETTINGS_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint NN_MANAGER_SETTINGS_USER_ID
  check ("USER_UNIQUEID" IS NOT NULL);
alter table TIMETABLE.MANAGER_SETTINGS
  add constraint NN_MANAGER_SETTINGS_VALUE
  check ("VALUE" IS NOT NULL);
create index TIMETABLE.IDX_MANAGER_SETTINGS_KEY on TIMETABLE.MANAGER_SETTINGS (KEY_ID);
create index TIMETABLE.IDX_MANAGER_SETTINGS_MANAGER on TIMETABLE.MANAGER_SETTINGS (USER_UNIQUEID);

prompt
prompt Creating table MEETING
prompt ======================
prompt
create table TIMETABLE.MEETING
(
  UNIQUEID           NUMBER(20),
  EVENT_ID           NUMBER(20),
  EVENT_TYPE         NUMBER(20),
  MEETING_DATE       DATE,
  START_PERIOD       NUMBER(10),
  START_OFFSET       NUMBER(10),
  STOP_PERIOD        NUMBER(10),
  STOP_OFFSET        NUMBER(10),
  LOCATION_PERM_ID   NUMBER(20),
  CLASS_CAN_OVERRIDE NUMBER(1),
  APPROVED_DATE      DATE
)
;
alter table TIMETABLE.MEETING
  add constraint PK_MEETING_UNIQUEID primary key (UNIQUEID);
alter table TIMETABLE.MEETING
  add constraint FK_MEETING_EVENT foreign key (EVENT_ID)
  references TIMETABLE.EVENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.MEETING
  add constraint FK_MEETING_EVENT_TYPE foreign key (EVENT_TYPE)
  references TIMETABLE.EVENT_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_DATE
  check ("MEETING_DATE" IS NOT NULL);
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_EVENT_ID
  check ("EVENT_ID" IS NOT NULL);
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_EVENT_TYPE
  check ("EVENT_TYPE" IS NOT NULL);
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_OVERRIDE
  check ("CLASS_CAN_OVERRIDE" IS NOT NULL);
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_START_PERIOD
  check ("START_PERIOD" IS NOT NULL);
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_STOP_PERIOD
  check ("STOP_PERIOD" IS NOT NULL);
alter table TIMETABLE.MEETING
  add constraint NN_MEETING_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table NON_UNIVERSITY_LOCATION
prompt ======================================
prompt
create table TIMETABLE.NON_UNIVERSITY_LOCATION
(
  UNIQUEID          NUMBER(20),
  SESSION_ID        NUMBER(20),
  NAME              VARCHAR2(20),
  CAPACITY          NUMBER(10),
  COORDINATE_X      NUMBER(10),
  COORDINATE_Y      NUMBER(10),
  IGNORE_TOO_FAR    NUMBER(1),
  MANAGER_IDS       VARCHAR2(200),
  PATTERN           VARCHAR2(350),
  IGNORE_ROOM_CHECK NUMBER(1) default (0),
  DISPLAY_NAME      VARCHAR2(100),
  EXAM_CAPACITY     NUMBER(10) default 0,
  PERMANENT_ID      NUMBER(20) not null,
  EXAM_TYPE         NUMBER(10) default 0
)
;
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint PK_NON_UNIV_LOC primary key (UNIQUEID);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint FK_NON_UNIV_LOC_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_CAPACITY
  check ("CAPACITY" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_COORD_X
  check ("COORDINATE_X" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_COORD_Y
  check ("COORDINATE_Y" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_IGN_TM_CHECK
  check ("IGNORE_ROOM_CHECK" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_IGN_TOO_FAR
  check ("IGNORE_TOO_FAR" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.NON_UNIVERSITY_LOCATION
  add constraint NN_NON_UNIV_LOC_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_NON_UNIV_LOC_SESSION on TIMETABLE.NON_UNIVERSITY_LOCATION (SESSION_ID);

prompt
prompt Creating table OFFR_GROUP
prompt =========================
prompt
create table TIMETABLE.OFFR_GROUP
(
  UNIQUEID      NUMBER(20),
  SESSION_ID    NUMBER(20),
  NAME          VARCHAR2(20),
  DESCRIPTION   VARCHAR2(200),
  DEPARTMENT_ID NUMBER(20)
)
;
alter table TIMETABLE.OFFR_GROUP
  add constraint PK_OFFR_GROUP_UID primary key (UNIQUEID);
alter table TIMETABLE.OFFR_GROUP
  add constraint FK_OFFR_GROUP_DEPT foreign key (DEPARTMENT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.OFFR_GROUP
  add constraint FK_OFFR_GROUP_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.OFFR_GROUP
  add constraint NN_OFFR_GROUP_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.OFFR_GROUP
  add constraint NN_OFFR_GROUP_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.OFFR_GROUP
  add constraint NN_OFFR_GROUP_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_OFFR_GROUP_DEPT on TIMETABLE.OFFR_GROUP (DEPARTMENT_ID);
create index TIMETABLE.IDX_OFFR_GROUP_SESSION on TIMETABLE.OFFR_GROUP (SESSION_ID);

prompt
prompt Creating table OFFR_GROUP_OFFERING
prompt ==================================
prompt
create table TIMETABLE.OFFR_GROUP_OFFERING
(
  OFFR_GROUP_ID     NUMBER(20),
  INSTR_OFFERING_ID NUMBER(20)
)
;
alter table TIMETABLE.OFFR_GROUP_OFFERING
  add constraint PK_OFFR_GROUP_OFFERING primary key (OFFR_GROUP_ID, INSTR_OFFERING_ID);
alter table TIMETABLE.OFFR_GROUP_OFFERING
  add constraint FK_OFFR_GROUP_INSTR_OFFR foreign key (INSTR_OFFERING_ID)
  references TIMETABLE.INSTRUCTIONAL_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.OFFR_GROUP_OFFERING
  add constraint FK_OFFR_GROUP_OFFR_OFFR_GRP foreign key (OFFR_GROUP_ID)
  references TIMETABLE.OFFR_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.OFFR_GROUP_OFFERING
  add constraint NN_OFFR_GROUP_OFFERING_GRP_ID
  check ("OFFR_GROUP_ID" IS NOT NULL);
alter table TIMETABLE.OFFR_GROUP_OFFERING
  add constraint NN_OFFR_GROUP_OFFERING_OFFR_ID
  check ("INSTR_OFFERING_ID" IS NOT NULL);

prompt
prompt Creating table POSITION_CODE_TO_TYPE
prompt ====================================
prompt
create table TIMETABLE.POSITION_CODE_TO_TYPE
(
  POSITION_CODE CHAR(5),
  POS_CODE_TYPE NUMBER(20)
)
;
alter table TIMETABLE.POSITION_CODE_TO_TYPE
  add constraint PK_POS_CODE_TO_TYPE primary key (POSITION_CODE);
alter table TIMETABLE.POSITION_CODE_TO_TYPE
  add constraint FK_POS_CODE_TO_TYPE_CODE_TYPE foreign key (POS_CODE_TYPE)
  references TIMETABLE.POSITION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.POSITION_CODE_TO_TYPE
  add constraint NN_POS_CODE_TO_TYPE_CODE_TYPE
  check ("POS_CODE_TYPE" IS NOT NULL);
alter table TIMETABLE.POSITION_CODE_TO_TYPE
  add constraint NN_POS_CODE_TO_TYPE_POS_CODE
  check ("POSITION_CODE" IS NOT NULL);
create index TIMETABLE.IDX_POS_CODE_TO_TYPE_TYPE on TIMETABLE.POSITION_CODE_TO_TYPE (POS_CODE_TYPE);

prompt
prompt Creating table POS_MAJOR
prompt ========================
prompt
create table TIMETABLE.POS_MAJOR
(
  UNIQUEID     NUMBER(20),
  CODE         VARCHAR2(10),
  NAME         VARCHAR2(50),
  EXTERNAL_UID VARCHAR2(20),
  SESSION_ID   NUMBER(20)
)
;
alter table TIMETABLE.POS_MAJOR
  add constraint PK_POS_MAJOR primary key (UNIQUEID);
alter table TIMETABLE.POS_MAJOR
  add constraint FK_POS_MAJOR_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_MAJOR
  add constraint NN_POS_MAJOR_CODE
  check ("CODE" IS NOT NULL);
alter table TIMETABLE.POS_MAJOR
  add constraint NN_POS_MAJOR_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.POS_MAJOR
  add constraint NN_POS_MAJOR_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.POS_MAJOR
  add constraint NN_POS_MAJOR_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table POS_ACAD_AREA_MAJOR
prompt ==================================
prompt
create table TIMETABLE.POS_ACAD_AREA_MAJOR
(
  ACADEMIC_AREA_ID NUMBER(20),
  MAJOR_ID         NUMBER(20)
)
;
alter table TIMETABLE.POS_ACAD_AREA_MAJOR
  add constraint PK_POS_ACAD_AREA_MAJOR primary key (ACADEMIC_AREA_ID, MAJOR_ID);
alter table TIMETABLE.POS_ACAD_AREA_MAJOR
  add constraint FK_POS_ACAD_AREA_MAJOR_AREA foreign key (ACADEMIC_AREA_ID)
  references TIMETABLE.ACADEMIC_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_ACAD_AREA_MAJOR
  add constraint FK_POS_ACAD_AREA_MAJOR_MAJOR foreign key (MAJOR_ID)
  references TIMETABLE.POS_MAJOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_ACAD_AREA_MAJOR
  add constraint NN_POS_ACAD_AREA_MAJOR_AREA
  check ("ACADEMIC_AREA_ID" IS NOT NULL);
alter table TIMETABLE.POS_ACAD_AREA_MAJOR
  add constraint NN_POS_ACAD_AREA_MAJOR_MAJOR
  check ("MAJOR_ID" IS NOT NULL);

prompt
prompt Creating table POS_MINOR
prompt ========================
prompt
create table TIMETABLE.POS_MINOR
(
  UNIQUEID     NUMBER(20),
  CODE         VARCHAR2(10),
  NAME         VARCHAR2(50),
  EXTERNAL_UID VARCHAR2(40),
  SESSION_ID   NUMBER(20)
)
;
alter table TIMETABLE.POS_MINOR
  add constraint PK_POS_MINOR primary key (UNIQUEID);
alter table TIMETABLE.POS_MINOR
  add constraint FK_POS_MINOR_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_MINOR
  add constraint NN_POS_MINOR_CODE
  check ("CODE" IS NOT NULL);
alter table TIMETABLE.POS_MINOR
  add constraint NN_POS_MINOR_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.POS_MINOR
  add constraint NN_POS_MINOR_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.POS_MINOR
  add constraint NN_POS_MINOR_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table POS_ACAD_AREA_MINOR
prompt ==================================
prompt
create table TIMETABLE.POS_ACAD_AREA_MINOR
(
  ACADEMIC_AREA_ID NUMBER(20),
  MINOR_ID         NUMBER(20)
)
;
alter table TIMETABLE.POS_ACAD_AREA_MINOR
  add constraint PK_POS_ACAD_AREA_MINOR primary key (ACADEMIC_AREA_ID, MINOR_ID);
alter table TIMETABLE.POS_ACAD_AREA_MINOR
  add constraint FK_POS_ACAD_AREA_MINOR_AREA foreign key (ACADEMIC_AREA_ID)
  references TIMETABLE.ACADEMIC_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_ACAD_AREA_MINOR
  add constraint FK_POS_ACAD_AREA_MINOR_MINOR foreign key (MINOR_ID)
  references TIMETABLE.POS_MINOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_ACAD_AREA_MINOR
  add constraint NN_POS_ACAD_AREA_MINOR_AREA
  check ("ACADEMIC_AREA_ID" IS NOT NULL);
alter table TIMETABLE.POS_ACAD_AREA_MINOR
  add constraint NN_POS_ACAD_AREA_MINOR_MINOR
  check ("MINOR_ID" IS NOT NULL);

prompt
prompt Creating table POS_RESERVATION
prompt ==============================
prompt
create table TIMETABLE.POS_RESERVATION
(
  UNIQUEID             NUMBER(20),
  OWNER                NUMBER(20),
  RESERVATION_TYPE     NUMBER(20),
  ACAD_CLASSIFICATION  NUMBER(20),
  POS_MAJOR            NUMBER(20),
  PRIORITY             NUMBER(5),
  RESERVED             NUMBER(10),
  PRIOR_ENROLLMENT     NUMBER(10),
  PROJECTED_ENROLLMENT NUMBER(10),
  OWNER_CLASS_ID       VARCHAR2(1),
  REQUESTED            NUMBER(10),
  LAST_MODIFIED_TIME   TIMESTAMP(6)
)
;
alter table TIMETABLE.POS_RESERVATION
  add constraint PK_POS_RESV primary key (UNIQUEID);
alter table TIMETABLE.POS_RESERVATION
  add constraint FK_POS_RESV_ACAD_CLASS foreign key (ACAD_CLASSIFICATION)
  references TIMETABLE.ACADEMIC_CLASSIFICATION (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_RESERVATION
  add constraint FK_POS_RESV_MAJOR foreign key (POS_MAJOR)
  references TIMETABLE.POS_MAJOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_RESERVATION
  add constraint FK_POS_RESV_TYPE foreign key (RESERVATION_TYPE)
  references TIMETABLE.RESERVATION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESC_RESERVED
  check ("RESERVED" IS NOT NULL);
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESV_OWNER
  check ("OWNER" IS NOT NULL);
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESV_OWNER_CLS_ID
  check ("OWNER_CLASS_ID" IS NOT NULL);
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESV_POS_MAJOR
  check ("POS_MAJOR" IS NOT NULL);
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESV_PRIORITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESV_RESERV_TYPE
  check ("RESERVATION_TYPE" IS NOT NULL);
alter table TIMETABLE.POS_RESERVATION
  add constraint NN_POS_RESV_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_POS_RESV_ACAD_CLASS on TIMETABLE.POS_RESERVATION (ACAD_CLASSIFICATION);
create index TIMETABLE.IDX_POS_RESV_MAJOR on TIMETABLE.POS_RESERVATION (POS_MAJOR);
create index TIMETABLE.IDX_POS_RESV_OWNER on TIMETABLE.POS_RESERVATION (OWNER);
create index TIMETABLE.IDX_POS_RESV_OWNER_CLS on TIMETABLE.POS_RESERVATION (OWNER_CLASS_ID);
create index TIMETABLE.IDX_POS_RESV_TYPE on TIMETABLE.POS_RESERVATION (RESERVATION_TYPE);

prompt
prompt Creating table RELATED_COURSE_INFO
prompt ==================================
prompt
create table TIMETABLE.RELATED_COURSE_INFO
(
  UNIQUEID   NUMBER(20),
  EVENT_ID   NUMBER(20),
  OWNER_ID   NUMBER(20),
  OWNER_TYPE NUMBER(10),
  COURSE_ID  NUMBER(20)
)
;
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint PK_RELATED_CRS_INFO primary key (UNIQUEID);
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint FK_EVENT_OWNER_COURSE foreign key (COURSE_ID)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint FK_EVENT_OWNER_EVENT foreign key (EVENT_ID)
  references TIMETABLE.EVENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint NN_REL_CRS_INFO_COURSE_ID
  check ("COURSE_ID" IS NOT NULL);
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint NN_REL_CRS_INFO_EVENT_ID
  check ("EVENT_ID" IS NOT NULL);
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint NN_REL_CRS_INFO_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint NN_REL_CRS_INFO_OWNER_TYPE
  check ("OWNER_TYPE" IS NOT NULL);
alter table TIMETABLE.RELATED_COURSE_INFO
  add constraint NN_REL_CRS_INFO_UNIQUE_ID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_EVENT_OWNER_EVENT on TIMETABLE.RELATED_COURSE_INFO (EVENT_ID);
create index TIMETABLE.IDX_EVENT_OWNER_OWNER on TIMETABLE.RELATED_COURSE_INFO (OWNER_ID, OWNER_TYPE);

prompt
prompt Creating table ROLES
prompt ====================
prompt
create table TIMETABLE.ROLES
(
  ROLE_ID   NUMBER(20),
  REFERENCE VARCHAR2(20),
  ABBV      VARCHAR2(40)
)
;
alter table TIMETABLE.ROLES
  add constraint PK_ROLES primary key (ROLE_ID);
alter table TIMETABLE.ROLES
  add constraint UK_ROLES_ABBV unique (ABBV);
alter table TIMETABLE.ROLES
  add constraint UK_ROLES_REFERENCE unique (REFERENCE);
alter table TIMETABLE.ROLES
  add constraint NN_ROLES_ABBV
  check ("ABBV" IS NOT NULL);
alter table TIMETABLE.ROLES
  add constraint NN_ROLES_REFERENCE
  check ("REFERENCE" IS NOT NULL);
alter table TIMETABLE.ROLES
  add constraint NN_ROLES_ROLE_ID
  check ("ROLE_ID" IS NOT NULL);

prompt
prompt Creating table ROOM
prompt ===================
prompt
create table TIMETABLE.ROOM
(
  UNIQUEID            NUMBER(20),
  EXTERNAL_UID        VARCHAR2(40),
  SESSION_ID          NUMBER(20),
  BUILDING_ID         NUMBER(20),
  ROOM_NUMBER         VARCHAR2(10),
  CAPACITY            NUMBER(10),
  COORDINATE_X        NUMBER(10),
  COORDINATE_Y        NUMBER(10),
  SCHEDULED_ROOM_TYPE VARCHAR2(20),
  IGNORE_TOO_FAR      NUMBER(1),
  MANAGER_IDS         VARCHAR2(200),
  PATTERN             VARCHAR2(350),
  IGNORE_ROOM_CHECK   NUMBER(1) default (0),
  CLASSIFICATION      VARCHAR2(20),
  DISPLAY_NAME        VARCHAR2(100),
  EXAM_CAPACITY       NUMBER(10) default 0,
  PERMANENT_ID        NUMBER(20) not null,
  EXAM_TYPE           NUMBER(10) default 0
)
;
alter table TIMETABLE.ROOM
  add constraint PK_ROOM primary key (UNIQUEID);
alter table TIMETABLE.ROOM
  add constraint UK_ROOM unique (SESSION_ID, BUILDING_ID, ROOM_NUMBER);
alter table TIMETABLE.ROOM
  add constraint FK_ROOM_BUILDING foreign key (BUILDING_ID)
  references TIMETABLE.BUILDING (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM
  add constraint FK_ROOM_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_BUILDING_ID
  check ("BUILDING_ID" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_CAPACITY
  check ("CAPACITY" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_CONSTRAINT
  check ("IGNORE_ROOM_CHECK" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_COORDINATE_X
  check ("COORDINATE_X" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_COORDINATE_Y
  check ("COORDINATE_Y" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_IGNORE_TOO_FAR
  check ("IGNORE_TOO_FAR" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_ROOM_NUMBER
  check ("ROOM_NUMBER" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_SCHEDULED_ROOM_TYPE
  check ("SCHEDULED_ROOM_TYPE" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.ROOM
  add constraint NN_ROOM_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_BUILDING on TIMETABLE.ROOM (BUILDING_ID);

prompt
prompt Creating table ROOM_DEPT
prompt ========================
prompt
create table TIMETABLE.ROOM_DEPT
(
  UNIQUEID      NUMBER(20),
  ROOM_ID       NUMBER(20),
  DEPARTMENT_ID NUMBER(20),
  IS_CONTROL    NUMBER(1) default 0
)
;
alter table TIMETABLE.ROOM_DEPT
  add constraint PK_ROOM_DEPT primary key (UNIQUEID);
alter table TIMETABLE.ROOM_DEPT
  add constraint FK_ROOM_DEPT_DEPT foreign key (DEPARTMENT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_DEPT
  add constraint NN_ROOM_DEPT_CONTROL
  check ("IS_CONTROL" IS NOT NULL);
alter table TIMETABLE.ROOM_DEPT
  add constraint NN_ROOM_DEPT_DEPARTMENT_ID
  check ("DEPARTMENT_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_DEPT
  add constraint NN_ROOM_DEPT_ROOM_ID
  check ("ROOM_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_DEPT
  add constraint NN_ROOM_DEPT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_DEPT_DEPT on TIMETABLE.ROOM_DEPT (DEPARTMENT_ID);
create index TIMETABLE.IDX_ROOM_DEPT_ROOM on TIMETABLE.ROOM_DEPT (ROOM_ID);

prompt
prompt Creating table ROOM_FEATURE
prompt ===========================
prompt
create table TIMETABLE.ROOM_FEATURE
(
  UNIQUEID      NUMBER(20),
  DISCRIMINATOR VARCHAR2(10),
  LABEL         VARCHAR2(20),
  SIS_REFERENCE VARCHAR2(20),
  SIS_VALUE     VARCHAR2(20),
  DEPARTMENT_ID NUMBER(20),
  ABBV          VARCHAR2(20)
)
;
alter table TIMETABLE.ROOM_FEATURE
  add constraint PK_ROOM_FEATURE primary key (UNIQUEID);
alter table TIMETABLE.ROOM_FEATURE
  add constraint FK_ROOM_FEATURE_DEPT foreign key (DEPARTMENT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_FEATURE
  add constraint NN_ROOM_FEATURE_DISCRIMINATOR
  check ("DISCRIMINATOR" IS NOT NULL);
alter table TIMETABLE.ROOM_FEATURE
  add constraint NN_ROOM_FEATURE_LABEL
  check ("LABEL" IS NOT NULL);
alter table TIMETABLE.ROOM_FEATURE
  add constraint NN_ROOM_FEATURE_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_FEATURE_DEPT on TIMETABLE.ROOM_FEATURE (DEPARTMENT_ID);

prompt
prompt Creating table ROOM_FEATURE_PREF
prompt ================================
prompt
create table TIMETABLE.ROOM_FEATURE_PREF
(
  UNIQUEID           NUMBER(20),
  OWNER_ID           NUMBER(20),
  PREF_LEVEL_ID      NUMBER(20),
  ROOM_FEATURE_ID    NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.ROOM_FEATURE_PREF
  add constraint PK_ROOM_FEAT_PREF primary key (UNIQUEID);
alter table TIMETABLE.ROOM_FEATURE_PREF
  add constraint FK_ROOM_FEAT_PREF_LEVEL foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_FEATURE_PREF
  add constraint FK_ROOM_FEAT_PREF_ROOM_FEAT foreign key (ROOM_FEATURE_ID)
  references TIMETABLE.ROOM_FEATURE (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_FEATURE_PREF
  add constraint NN_ROOM_FEAT_PREF_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_FEATURE_PREF
  add constraint NN_ROOM_FEAT_PREF_ROOM_FEAT_ID
  check ("ROOM_FEATURE_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_FEATURE_PREF
  add constraint NN_ROOM_FEAT_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_FEAT_PREF_LEVEL on TIMETABLE.ROOM_FEATURE_PREF (PREF_LEVEL_ID);
create index TIMETABLE.IDX_ROOM_FEAT_PREF_OWNER on TIMETABLE.ROOM_FEATURE_PREF (OWNER_ID);
create index TIMETABLE.IDX_ROOM_FEAT_PREF_ROOM_FEAT on TIMETABLE.ROOM_FEATURE_PREF (ROOM_FEATURE_ID);

prompt
prompt Creating table ROOM_GROUP
prompt =========================
prompt
create table TIMETABLE.ROOM_GROUP
(
  UNIQUEID      NUMBER(20),
  SESSION_ID    NUMBER(20),
  NAME          VARCHAR2(20),
  DESCRIPTION   VARCHAR2(200),
  GLOBAL        NUMBER(1),
  DEFAULT_GROUP NUMBER(1),
  DEPARTMENT_ID NUMBER(20),
  ABBV          VARCHAR2(20)
)
;
alter table TIMETABLE.ROOM_GROUP
  add constraint PK_ROOM_GROUP_UID primary key (UNIQUEID);
alter table TIMETABLE.ROOM_GROUP
  add constraint FK_ROOM_GROUP_DEPT foreign key (DEPARTMENT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_GROUP
  add constraint FK_ROOM_GROUP_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_GROUP
  add constraint NN_ROOM_GROUP_DEFAULT_GROUP
  check ("DEFAULT_GROUP" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP
  add constraint NN_ROOM_GROUP_GLOBAL
  check ("GLOBAL" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP
  add constraint NN_ROOM_GROUP_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP
  add constraint NN_ROOM_GROUP_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP
  add constraint NN_ROOM_GROUP_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_GROUP_DEPT on TIMETABLE.ROOM_GROUP (DEPARTMENT_ID);
create index TIMETABLE.IDX_ROOM_GROUP_SESSION on TIMETABLE.ROOM_GROUP (SESSION_ID);

prompt
prompt Creating table ROOM_GROUP_PREF
prompt ==============================
prompt
create table TIMETABLE.ROOM_GROUP_PREF
(
  UNIQUEID           NUMBER(20),
  OWNER_ID           NUMBER(20),
  PREF_LEVEL_ID      NUMBER(20),
  ROOM_GROUP_ID      NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.ROOM_GROUP_PREF
  add constraint PK_ROOM_GROUP_PREF primary key (UNIQUEID);
alter table TIMETABLE.ROOM_GROUP_PREF
  add constraint FK_ROOM_GROUP_PREF_LEVEL foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_GROUP_PREF
  add constraint FK_ROOM_GROUP_PREF_ROOM_GRP foreign key (ROOM_GROUP_ID)
  references TIMETABLE.ROOM_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_GROUP_PREF
  add constraint NN_ROOM_GROUP_PREF_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP_PREF
  add constraint NN_ROOM_GROUP_PREF_ROOM_GRP_ID
  check ("ROOM_GROUP_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP_PREF
  add constraint NN_ROOM_GROUP_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_GROUP_PREF_LEVEL on TIMETABLE.ROOM_GROUP_PREF (PREF_LEVEL_ID);
create index TIMETABLE.IDX_ROOM_GROUP_PREF_OWNER on TIMETABLE.ROOM_GROUP_PREF (OWNER_ID);
create index TIMETABLE.IDX_ROOM_GROUP_PREF_ROOM_GRP on TIMETABLE.ROOM_GROUP_PREF (ROOM_GROUP_ID);

prompt
prompt Creating table ROOM_GROUP_ROOM
prompt ==============================
prompt
create table TIMETABLE.ROOM_GROUP_ROOM
(
  ROOM_GROUP_ID NUMBER(20),
  ROOM_ID       NUMBER(20)
)
;
alter table TIMETABLE.ROOM_GROUP_ROOM
  add constraint PK_ROOM_GROUP_ROOM primary key (ROOM_GROUP_ID, ROOM_ID);
alter table TIMETABLE.ROOM_GROUP_ROOM
  add constraint FK_ROOM_GROUP_ROOM_ROOM_GRP foreign key (ROOM_GROUP_ID)
  references TIMETABLE.ROOM_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_GROUP_ROOM
  add constraint NN_ROOM_GROUP_ROOM_ROOM_GRP_ID
  check ("ROOM_GROUP_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_GROUP_ROOM
  add constraint NN_ROOM_GROUP_ROOM_ROOM_ID
  check ("ROOM_ID" IS NOT NULL);

prompt
prompt Creating table ROOM_JOIN_ROOM_FEATURE
prompt =====================================
prompt
create table TIMETABLE.ROOM_JOIN_ROOM_FEATURE
(
  ROOM_ID    NUMBER(20),
  FEATURE_ID NUMBER(20)
)
;
alter table TIMETABLE.ROOM_JOIN_ROOM_FEATURE
  add constraint UK_ROOM_JOIN_ROOM_FEAT_RM_FEAT unique (ROOM_ID, FEATURE_ID);
alter table TIMETABLE.ROOM_JOIN_ROOM_FEATURE
  add constraint FK_ROOM_JOIN_ROOM_FEAT_RM_FEAT foreign key (FEATURE_ID)
  references TIMETABLE.ROOM_FEATURE (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_JOIN_ROOM_FEATURE
  add constraint NN_ROOM_JOIN_ROOM_FEAT_FEAT_ID
  check ("FEATURE_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_JOIN_ROOM_FEATURE
  add constraint NN_ROOM_JOIN_ROOM_FEAT_ROOM_ID
  check ("ROOM_ID" IS NOT NULL);

prompt
prompt Creating table ROOM_PREF
prompt ========================
prompt
create table TIMETABLE.ROOM_PREF
(
  UNIQUEID           NUMBER(20),
  OWNER_ID           NUMBER(20),
  PREF_LEVEL_ID      NUMBER(20),
  ROOM_ID            NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.ROOM_PREF
  add constraint PK_ROOM_PREF primary key (UNIQUEID);
alter table TIMETABLE.ROOM_PREF
  add constraint FK_ROOM_PREF_LEVEL foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.ROOM_PREF
  add constraint NN_ROOM_PREF_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_PREF
  add constraint NN_ROOM_PREF_ROOM_ID
  check ("ROOM_ID" IS NOT NULL);
alter table TIMETABLE.ROOM_PREF
  add constraint NN_ROOM_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_ROOM_PREF_LEVEL on TIMETABLE.ROOM_PREF (PREF_LEVEL_ID);
create index TIMETABLE.IDX_ROOM_PREF_OWNER on TIMETABLE.ROOM_PREF (OWNER_ID);

prompt
prompt Creating table SECTIONING_INFO
prompt ==============================
prompt
create table TIMETABLE.SECTIONING_INFO
(
  UNIQUEID          NUMBER(20),
  CLASS_ID          NUMBER(20),
  NBR_EXP_STUDENTS  FLOAT,
  NBR_HOLD_STUDENTS FLOAT
)
;
alter table TIMETABLE.SECTIONING_INFO
  add constraint PK_SECTIONING_INFO primary key (UNIQUEID);
alter table TIMETABLE.SECTIONING_INFO
  add constraint FK_SECTIONING_INFO_CLASS foreign key (CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.SECTIONING_INFO
  add constraint NN_SECTIONING_INFO_CLASS
  check ("CLASS_ID" IS NOT NULL);
alter table TIMETABLE.SECTIONING_INFO
  add constraint NN_SECTIONING_INFO_EXP
  check ("NBR_EXP_STUDENTS" IS NOT NULL);
alter table TIMETABLE.SECTIONING_INFO
  add constraint NN_SECTIONING_INFO_HOLD
  check ("NBR_HOLD_STUDENTS" IS NOT NULL);
alter table TIMETABLE.SECTIONING_INFO
  add constraint NN_SECTIONING_INFO_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table SOLVER_GR_TO_TT_MGR
prompt ==================================
prompt
create table TIMETABLE.SOLVER_GR_TO_TT_MGR
(
  SOLVER_GROUP_ID  NUMBER(20),
  TIMETABLE_MGR_ID NUMBER(20)
)
;
alter table TIMETABLE.SOLVER_GR_TO_TT_MGR
  add constraint PK_SOLVER_GR_TO_TT_MGR primary key (SOLVER_GROUP_ID, TIMETABLE_MGR_ID);
alter table TIMETABLE.SOLVER_GR_TO_TT_MGR
  add constraint FK_SOLVER_GR_TO_TT_MGR_SOLVGRP foreign key (SOLVER_GROUP_ID)
  references TIMETABLE.SOLVER_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_GR_TO_TT_MGR
  add constraint FK_SOLVER_GR_TO_TT_MGR_TT_MGR foreign key (TIMETABLE_MGR_ID)
  references TIMETABLE.TIMETABLE_MANAGER (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_GR_TO_TT_MGR
  add constraint NN_SOLVER_GR_TO_TT_MGR_SOLVGRP
  check ("SOLVER_GROUP_ID" IS NOT NULL);
alter table TIMETABLE.SOLVER_GR_TO_TT_MGR
  add constraint NN_SOLVER_GR_TO_TT_MGR_TT_MGR
  check ("TIMETABLE_MGR_ID" IS NOT NULL);

prompt
prompt Creating table SOLVER_PARAMETER_GROUP
prompt =====================================
prompt
create table TIMETABLE.SOLVER_PARAMETER_GROUP
(
  UNIQUEID    NUMBER(20),
  NAME        VARCHAR2(100),
  DESCRIPTION VARCHAR2(1000),
  CONDITION   VARCHAR2(250),
  ORD         NUMBER(10),
  PARAM_TYPE  NUMBER(10) default 0
)
;
alter table TIMETABLE.SOLVER_PARAMETER_GROUP
  add constraint PK_SOLVER_PARAM_GROUP primary key (UNIQUEID);
alter table TIMETABLE.SOLVER_PARAMETER_GROUP
  add constraint NN_SOLVER_PARAM_GROUP_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table SOLVER_PARAMETER_DEF
prompt ===================================
prompt
create table TIMETABLE.SOLVER_PARAMETER_DEF
(
  UNIQUEID              NUMBER(20),
  NAME                  VARCHAR2(100),
  DEFAULT_VALUE         VARCHAR2(2048),
  DESCRIPTION           VARCHAR2(1000),
  TYPE                  VARCHAR2(250),
  ORD                   NUMBER(10),
  VISIBLE               NUMBER(1),
  SOLVER_PARAM_GROUP_ID NUMBER(20)
)
;
alter table TIMETABLE.SOLVER_PARAMETER_DEF
  add constraint PK_SOLV_PARAM_DEF primary key (UNIQUEID);
alter table TIMETABLE.SOLVER_PARAMETER_DEF
  add constraint FK_SOLV_PARAM_DEF_SOLV_PAR_GRP foreign key (SOLVER_PARAM_GROUP_ID)
  references TIMETABLE.SOLVER_PARAMETER_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_PARAMETER_DEF
  add constraint NN_SOLV_PARAM_DEF_SOLV_PAR_GRP
  check ("SOLVER_PARAM_GROUP_ID" IS NOT NULL);
alter table TIMETABLE.SOLVER_PARAMETER_DEF
  add constraint NN_SOLV_PARAM_DEF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_SOLV_PARAM_DEF_GR on TIMETABLE.SOLVER_PARAMETER_DEF (SOLVER_PARAM_GROUP_ID);

prompt
prompt Creating table SOLVER_PREDEF_SETTING
prompt ====================================
prompt
create table TIMETABLE.SOLVER_PREDEF_SETTING
(
  UNIQUEID    NUMBER(20),
  NAME        VARCHAR2(100),
  DESCRIPTION VARCHAR2(1000),
  APPEARANCE  NUMBER(10)
)
;
alter table TIMETABLE.SOLVER_PREDEF_SETTING
  add constraint PK_SOLV_PREDEF_SETTG primary key (UNIQUEID);
alter table TIMETABLE.SOLVER_PREDEF_SETTING
  add constraint NN_SOLV_PREDEF_SETTG_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table SOLVER_PARAMETER
prompt ===============================
prompt
create table TIMETABLE.SOLVER_PARAMETER
(
  UNIQUEID                 NUMBER(20),
  VALUE                    VARCHAR2(2048),
  SOLVER_PARAM_DEF_ID      NUMBER(20),
  SOLUTION_ID              NUMBER(20),
  SOLVER_PREDEF_SETTING_ID NUMBER(20)
)
;
alter table TIMETABLE.SOLVER_PARAMETER
  add constraint FK_SOLVER_PARAM_DEF foreign key (SOLVER_PARAM_DEF_ID)
  references TIMETABLE.SOLVER_PARAMETER_DEF (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_PARAMETER
  add constraint FK_SOLVER_PARAM_PREDEF_STG foreign key (SOLVER_PREDEF_SETTING_ID)
  references TIMETABLE.SOLVER_PREDEF_SETTING (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_PARAMETER
  add constraint FK_SOLVER_PARAM_SOLUTION foreign key (SOLUTION_ID)
  references TIMETABLE.SOLUTION (UNIQUEID) on delete cascade;
alter table TIMETABLE.SOLVER_PARAMETER
  add constraint NN_SOLVER_PARAM_SOLV_PARAM_DEF
  check ("SOLVER_PARAM_DEF_ID" IS NOT NULL);
alter table TIMETABLE.SOLVER_PARAMETER
  add constraint NN_SOLVER_PARAM_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_SOLVER_PARAM_DEF on TIMETABLE.SOLVER_PARAMETER (SOLVER_PARAM_DEF_ID);
create index TIMETABLE.IDX_SOLVER_PARAM_PREDEF on TIMETABLE.SOLVER_PARAMETER (SOLVER_PREDEF_SETTING_ID);
create index TIMETABLE.IDX_SOLVER_PARAM_SOLUTION on TIMETABLE.SOLVER_PARAMETER (SOLUTION_ID);

prompt
prompt Creating table STAFF
prompt ====================
prompt
create table TIMETABLE.STAFF
(
  UNIQUEID     NUMBER(20),
  EXTERNAL_UID VARCHAR2(40),
  FNAME        VARCHAR2(50),
  MNAME        VARCHAR2(50),
  LNAME        VARCHAR2(100),
  POS_CODE     VARCHAR2(20),
  DEPT         VARCHAR2(50),
  EMAIL        VARCHAR2(200)
)
;
alter table TIMETABLE.STAFF
  add constraint PK_STAFF primary key (UNIQUEID);
alter table TIMETABLE.STAFF
  add constraint NN_STAFF_LNAME
  check ("LNAME" IS NOT NULL);
alter table TIMETABLE.STAFF
  add constraint NN_STAFF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table STUDENT_ACAD_AREA
prompt ================================
prompt
create table TIMETABLE.STUDENT_ACAD_AREA
(
  UNIQUEID      NUMBER(20),
  STUDENT_ID    NUMBER(20),
  ACAD_CLASF_ID NUMBER(20),
  ACAD_AREA_ID  NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint PK_STUDENT_ACAD_AREA primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint UK_STUDENT_ACAD_AREA unique (STUDENT_ID, ACAD_CLASF_ID, ACAD_AREA_ID);
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint FK_STUDENT_ACAD_AREA_AREA foreign key (ACAD_AREA_ID)
  references TIMETABLE.ACADEMIC_AREA (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint FK_STUDENT_ACAD_AREA_CLASF foreign key (ACAD_CLASF_ID)
  references TIMETABLE.ACADEMIC_CLASSIFICATION (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint FK_STUDENT_ACAD_AREA_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint NN_ACAD_AREA_AREA
  check ("ACAD_AREA_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint NN_ACAD_AREA_CLASF
  check ("ACAD_CLASF_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint NN_ACAD_AREA_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ACAD_AREA
  add constraint NN_ACAD_AREA_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STUDENT_ACAD_AREA on TIMETABLE.STUDENT_ACAD_AREA (STUDENT_ID, ACAD_AREA_ID, ACAD_CLASF_ID);

prompt
prompt Creating table STUDENT_ACCOMODATION
prompt ===================================
prompt
create table TIMETABLE.STUDENT_ACCOMODATION
(
  UNIQUEID     NUMBER(20),
  NAME         VARCHAR2(50),
  ABBREVIATION VARCHAR2(20),
  EXTERNAL_UID VARCHAR2(40),
  SESSION_ID   NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_ACCOMODATION
  add constraint PK_STUDENT_ACCOMODATION primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_ACCOMODATION
  add constraint FK_STUDENT_ACCOM_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ACCOMODATION
  add constraint NN_STUDENT_ACCOM_ABBV
  check ("ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.STUDENT_ACCOMODATION
  add constraint NN_STUDENT_ACCOM_NAME
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.STUDENT_ACCOMODATION
  add constraint NN_STUDENT_ACCOM_SESSION
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ACCOMODATION
  add constraint NN_STUDENT_ACCOM_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table STUDENT_CLASS_ENRL
prompt =================================
prompt
create table TIMETABLE.STUDENT_CLASS_ENRL
(
  UNIQUEID           NUMBER(20),
  STUDENT_ID         NUMBER(20),
  COURSE_REQUEST_ID  NUMBER(20),
  CLASS_ID           NUMBER(20),
  TIMESTAMP          DATE,
  COURSE_OFFERING_ID NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint PK_STUDENT_CLASS_ENRL primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint FK_STUDENT_CLASS_ENRL_CLASS foreign key (CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint FK_STUDENT_CLASS_ENRL_COURSE foreign key (COURSE_OFFERING_ID)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint FK_STUDENT_CLASS_ENRL_REQUEST foreign key (COURSE_REQUEST_ID)
  references TIMETABLE.COURSE_REQUEST (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint FK_STUDENT_CLASS_ENRL_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint NN_STUDENT_CLASS_ENRL_CLASS
  check ("CLASS_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint NN_STUDENT_CLASS_ENRL_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint NN_STUDENT_CLASS_ENRL_TIMESTMP
  check ("TIMESTAMP" IS NOT NULL);
alter table TIMETABLE.STUDENT_CLASS_ENRL
  add constraint NN_STUDENT_CLASS_ENRL_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STUDENT_CLASS_ENRL_CLASS on TIMETABLE.STUDENT_CLASS_ENRL (CLASS_ID);
create index TIMETABLE.IDX_STUDENT_CLASS_ENRL_REQ on TIMETABLE.STUDENT_CLASS_ENRL (COURSE_REQUEST_ID);
create index TIMETABLE.IDX_STUDENT_CLASS_ENRL_STUDENT on TIMETABLE.STUDENT_CLASS_ENRL (STUDENT_ID);

prompt
prompt Creating table STUDENT_ENRL
prompt ===========================
prompt
create table TIMETABLE.STUDENT_ENRL
(
  UNIQUEID           NUMBER(20),
  STUDENT_ID         NUMBER(20),
  SOLUTION_ID        NUMBER(20),
  CLASS_ID           NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.STUDENT_ENRL
  add constraint PK_STUDENT_ENRL primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_ENRL
  add constraint FK_STUDENT_ENRL_CLASS foreign key (CLASS_ID)
  references TIMETABLE.CLASS_ (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ENRL
  add constraint FK_STUDENT_ENRL_SOLUTION foreign key (SOLUTION_ID)
  references TIMETABLE.SOLUTION (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ENRL
  add constraint NN_STUDENT_ENRL_CLASS_ID
  check ("CLASS_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL
  add constraint NN_STUDENT_ENRL_SOLUTION_ID
  check ("SOLUTION_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL
  add constraint NN_STUDENT_ENRL_STUDENT_ID
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL
  add constraint NN_STUDENT_ENRL_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STUDENT_ENRL on TIMETABLE.STUDENT_ENRL (SOLUTION_ID);
create index TIMETABLE.IDX_STUDENT_ENRL_CLASS on TIMETABLE.STUDENT_ENRL (CLASS_ID);

prompt
prompt Creating table STUDENT_ENRL_MSG
prompt ===============================
prompt
create table TIMETABLE.STUDENT_ENRL_MSG
(
  UNIQUEID         NUMBER(20),
  MESSAGE          VARCHAR2(255),
  MSG_LEVEL        NUMBER(10) default (0),
  TYPE             NUMBER(10) default (0),
  TIMESTAMP        DATE,
  COURSE_DEMAND_ID NUMBER(20),
  ORD              NUMBER(10)
)
;
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint PK_STUDENT_ENRL_MSG primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint FK_STUDENT_ENRL_MSG_DEMAND foreign key (COURSE_DEMAND_ID)
  references TIMETABLE.COURSE_DEMAND (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_DEMAND
  check ("COURSE_DEMAND_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_LEV
  check ("MSG_LEVEL" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_MSG
  check ("MESSAGE" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_ORDER
  check ("ORD" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_TS
  check ("TIMESTAMP" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_TYPE
  check ("TYPE" IS NOT NULL);
alter table TIMETABLE.STUDENT_ENRL_MSG
  add constraint NN_STUDENT_ENRL_MSG_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STUDENT_ENRL_MSG_DEM on TIMETABLE.STUDENT_ENRL_MSG (COURSE_DEMAND_ID);

prompt
prompt Creating table STUDENT_GROUP
prompt ============================
prompt
create table TIMETABLE.STUDENT_GROUP
(
  UNIQUEID           NUMBER(20),
  SESSION_ID         NUMBER(20),
  GROUP_ABBREVIATION VARCHAR2(30),
  GROUP_NAME         VARCHAR2(90),
  EXTERNAL_UID       VARCHAR2(40)
)
;
alter table TIMETABLE.STUDENT_GROUP
  add constraint PK_STUDENT_GROUP primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_GROUP
  add constraint UK_STUDENT_GROUP_SESSION_SIS unique (SESSION_ID, GROUP_ABBREVIATION);
alter table TIMETABLE.STUDENT_GROUP
  add constraint FK_STUDENT_GROUP_SESSION foreign key (SESSION_ID)
  references TIMETABLE.SESSIONS (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_GROUP
  add constraint NN_STUDENT_GROUP_GROUP_ABBREVI
  check ("GROUP_ABBREVIATION" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP
  add constraint NN_STUDENT_GROUP_GROUP_NAME
  check ("GROUP_NAME" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP
  add constraint NN_STUDENT_GROUP_SESSION_ID
  check ("SESSION_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP
  add constraint NN_STUDENT_GROUP_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table STUDENT_GROUP_RESERVATION
prompt ========================================
prompt
create table TIMETABLE.STUDENT_GROUP_RESERVATION
(
  UNIQUEID             NUMBER(20),
  OWNER                NUMBER(20),
  RESERVATION_TYPE     NUMBER(20),
  STUDENT_GROUP        NUMBER(20),
  PRIORITY             NUMBER(5),
  RESERVED             NUMBER(10),
  PRIOR_ENROLLMENT     NUMBER(10),
  PROJECTED_ENROLLMENT NUMBER(10),
  OWNER_CLASS_ID       VARCHAR2(1),
  REQUESTED            NUMBER(10),
  LAST_MODIFIED_TIME   TIMESTAMP(6)
)
;
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint PK_STU_GRP_RESV primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint FK_STU_GRP_RESV_RESERV_TYPE foreign key (RESERVATION_TYPE)
  references TIMETABLE.RESERVATION_TYPE (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint FK_STU_GRP_RESV_STU_GRP foreign key (STUDENT_GROUP)
  references TIMETABLE.STUDENT_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_OWNER
  check ("OWNER" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_OWNER_CLS_ID
  check ("OWNER_CLASS_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_PRIORITY
  check ("PRIORITY" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_RESERVED
  check ("RESERVED" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_RESERV_TYPE
  check ("RESERVATION_TYPE" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_STU_GRP
  check ("STUDENT_GROUP" IS NOT NULL);
alter table TIMETABLE.STUDENT_GROUP_RESERVATION
  add constraint NN_STU_GRP_RESV_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STU_GRP_RESV_OWNER on TIMETABLE.STUDENT_GROUP_RESERVATION (OWNER);
create index TIMETABLE.IDX_STU_GRP_RESV_OWNER_CLS on TIMETABLE.STUDENT_GROUP_RESERVATION (OWNER_CLASS_ID);
create index TIMETABLE.IDX_STU_GRP_RESV_STUDENT_GROUP on TIMETABLE.STUDENT_GROUP_RESERVATION (STUDENT_GROUP);
create index TIMETABLE.IDX_STU_GRP_RESV_TYPE on TIMETABLE.STUDENT_GROUP_RESERVATION (RESERVATION_TYPE);

prompt
prompt Creating table STUDENT_MAJOR
prompt ============================
prompt
create table TIMETABLE.STUDENT_MAJOR
(
  STUDENT_ID NUMBER(20),
  MAJOR_ID   NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_MAJOR
  add constraint PK_STUDENT_MAJOR primary key (STUDENT_ID, MAJOR_ID);
alter table TIMETABLE.STUDENT_MAJOR
  add constraint FK_STUDENT_MAJOR_MAJOR foreign key (MAJOR_ID)
  references TIMETABLE.POS_MAJOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_MAJOR
  add constraint FK_STUDENT_MAJOR_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_MAJOR
  add constraint NN_STUDENT_MAJOR_MAJOR
  check ("MAJOR_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_MAJOR
  add constraint NN_STUDENT_MAJOR_STUDENT
  check ("STUDENT_ID" IS NOT NULL);

prompt
prompt Creating table STUDENT_MINOR
prompt ============================
prompt
create table TIMETABLE.STUDENT_MINOR
(
  STUDENT_ID NUMBER(20),
  MINOR_ID   NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_MINOR
  add constraint PK_STUDENT_MINOR primary key (STUDENT_ID, MINOR_ID);
alter table TIMETABLE.STUDENT_MINOR
  add constraint FK_STUDENT_MINOR_MINOR foreign key (MINOR_ID)
  references TIMETABLE.POS_MINOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_MINOR
  add constraint FK_STUDENT_MINOR_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_MINOR
  add constraint NN_STUDENT_MINOR_MINOR
  check ("MINOR_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_MINOR
  add constraint NN_STUDENT_MINOR_STUDENT
  check ("STUDENT_ID" IS NOT NULL);

prompt
prompt Creating table STUDENT_SECT_HIST
prompt ================================
prompt
create table TIMETABLE.STUDENT_SECT_HIST
(
  UNIQUEID   NUMBER(20),
  STUDENT_ID NUMBER(20),
  DATA       BLOB,
  TYPE       NUMBER(10),
  TIMESTAMP  DATE
)
;
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint PK_STUDENT_SECT_HIST primary key (UNIQUEID);
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint FK_STUDENT_SECT_HIST_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint NN_STUDENT_SECTH_DATA
  check ("DATA" IS NOT NULL);
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint NN_STUDENT_SECTH_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint NN_STUDENT_SECTH_TS
  check ("TIMESTAMP" IS NOT NULL);
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint NN_STUDENT_SECTH_TYPE
  check ("TYPE" IS NOT NULL);
alter table TIMETABLE.STUDENT_SECT_HIST
  add constraint NN_STUDENT_SECTH_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_STUDENT_SECT_HIST_STUDENT on TIMETABLE.STUDENT_SECT_HIST (STUDENT_ID);

prompt
prompt Creating table STUDENT_TO_ACOMODATION
prompt =====================================
prompt
create table TIMETABLE.STUDENT_TO_ACOMODATION
(
  STUDENT_ID      NUMBER(20),
  ACCOMODATION_ID NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_TO_ACOMODATION
  add constraint PK_STUDENT_TO_ACOMODATION primary key (STUDENT_ID, ACCOMODATION_ID);
alter table TIMETABLE.STUDENT_TO_ACOMODATION
  add constraint FK_STUDENT_ACOMODATION_ACCOM foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_TO_ACOMODATION
  add constraint FK_STUDENT_ACOMODATION_STUDENT foreign key (ACCOMODATION_ID)
  references TIMETABLE.STUDENT_ACCOMODATION (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_TO_ACOMODATION
  add constraint NN_STUDENT_TO_ACOMOD_ACOMOD
  check ("ACCOMODATION_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_TO_ACOMODATION
  add constraint NN_STUDENT_TO_ACOMOD_STUDENT
  check ("STUDENT_ID" IS NOT NULL);

prompt
prompt Creating table STUDENT_TO_GROUP
prompt ===============================
prompt
create table TIMETABLE.STUDENT_TO_GROUP
(
  STUDENT_ID NUMBER(20),
  GROUP_ID   NUMBER(20)
)
;
alter table TIMETABLE.STUDENT_TO_GROUP
  add constraint PK_STUDENT_TO_GROUP primary key (STUDENT_ID, GROUP_ID);
alter table TIMETABLE.STUDENT_TO_GROUP
  add constraint FK_STUDENT_GROUP_GROUP foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_TO_GROUP
  add constraint FK_STUDENT_GROUP_STUDENT foreign key (GROUP_ID)
  references TIMETABLE.STUDENT_GROUP (UNIQUEID) on delete cascade;
alter table TIMETABLE.STUDENT_TO_GROUP
  add constraint NN_STUDENT_TO_GROUP_GROUP
  check ("GROUP_ID" IS NOT NULL);
alter table TIMETABLE.STUDENT_TO_GROUP
  add constraint NN_STUDENT_TO_GROUP_STUDENT
  check ("STUDENT_ID" IS NOT NULL);

prompt
prompt Creating table TIME_PATTERN_DAYS
prompt ================================
prompt
create table TIMETABLE.TIME_PATTERN_DAYS
(
  UNIQUEID        NUMBER(20),
  DAY_CODE        NUMBER(10),
  TIME_PATTERN_ID NUMBER(20)
)
;
alter table TIMETABLE.TIME_PATTERN_DAYS
  add constraint PK_TIME_PATTERN_DAYS primary key (UNIQUEID);
alter table TIMETABLE.TIME_PATTERN_DAYS
  add constraint FK_TIME_PATTERN_DAYS_TIME_PATT foreign key (TIME_PATTERN_ID)
  references TIMETABLE.TIME_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PATTERN_DAYS
  add constraint NN_TIME_PATTERN_DAYS_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_TIME_PATTERN_DAYS on TIMETABLE.TIME_PATTERN_DAYS (TIME_PATTERN_ID);

prompt
prompt Creating table TIME_PATTERN_DEPT
prompt ================================
prompt
create table TIMETABLE.TIME_PATTERN_DEPT
(
  DEPT_ID    NUMBER(20),
  PATTERN_ID NUMBER(20)
)
;
alter table TIMETABLE.TIME_PATTERN_DEPT
  add constraint PK_TIME_PATTERN_DEPT primary key (DEPT_ID, PATTERN_ID);
alter table TIMETABLE.TIME_PATTERN_DEPT
  add constraint FK_TIME_PATTERN_DEPT_DEPT foreign key (DEPT_ID)
  references TIMETABLE.DEPARTMENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PATTERN_DEPT
  add constraint FK_TIME_PATTERN_DEPT_PATTERN foreign key (PATTERN_ID)
  references TIMETABLE.TIME_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PATTERN_DEPT
  add constraint NN_TIME_PATTERN_DEPT_DEPT_ID
  check ("DEPT_ID" IS NOT NULL);
alter table TIMETABLE.TIME_PATTERN_DEPT
  add constraint NN_TIME_PATTERN_DEPT_PATT_ID
  check ("PATTERN_ID" IS NOT NULL);

prompt
prompt Creating table TIME_PATTERN_TIME
prompt ================================
prompt
create table TIMETABLE.TIME_PATTERN_TIME
(
  UNIQUEID        NUMBER(20),
  START_SLOT      NUMBER(10),
  TIME_PATTERN_ID NUMBER(20)
)
;
alter table TIMETABLE.TIME_PATTERN_TIME
  add constraint PK_TIME_PATTERN_TIME primary key (UNIQUEID);
alter table TIMETABLE.TIME_PATTERN_TIME
  add constraint FK_TIME_PATTERN_TIME foreign key (TIME_PATTERN_ID)
  references TIMETABLE.TIME_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PATTERN_TIME
  add constraint NN_TIME_PATTERN_TIME_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_TIME_PATTERN_TIME on TIMETABLE.TIME_PATTERN_TIME (TIME_PATTERN_ID);

prompt
prompt Creating table TIME_PREF
prompt ========================
prompt
create table TIMETABLE.TIME_PREF
(
  UNIQUEID           NUMBER(20),
  OWNER_ID           NUMBER(20),
  PREF_LEVEL_ID      NUMBER(20),
  PREFERENCE         VARCHAR2(2048),
  TIME_PATTERN_ID    NUMBER(20),
  LAST_MODIFIED_TIME TIMESTAMP(6)
)
;
alter table TIMETABLE.TIME_PREF
  add constraint PK_TIME_PREF primary key (UNIQUEID);
alter table TIMETABLE.TIME_PREF
  add constraint FK_TIME_PREF_PREF_LEVEL foreign key (PREF_LEVEL_ID)
  references TIMETABLE.PREFERENCE_LEVEL (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PREF
  add constraint FK_TIME_PREF_TIME_PTRN foreign key (TIME_PATTERN_ID)
  references TIMETABLE.TIME_PATTERN (UNIQUEID) on delete cascade;
alter table TIMETABLE.TIME_PREF
  add constraint NN_TIME_PREF_OWNER_ID
  check ("OWNER_ID" IS NOT NULL);
alter table TIMETABLE.TIME_PREF
  add constraint NN_TIME_PREF_PREF_LEVEL_ID
  check ("PREF_LEVEL_ID" IS NOT NULL);
alter table TIMETABLE.TIME_PREF
  add constraint NN_TIME_PREF_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_TIME_PREF_OWNER on TIMETABLE.TIME_PREF (OWNER_ID);
create index TIMETABLE.IDX_TIME_PREF_PREF_LEVEL on TIMETABLE.TIME_PREF (PREF_LEVEL_ID);
create index TIMETABLE.IDX_TIME_PREF_TIME_PTRN on TIMETABLE.TIME_PREF (TIME_PATTERN_ID);

prompt
prompt Creating table TMTBL_MGR_TO_ROLES
prompt =================================
prompt
create table TIMETABLE.TMTBL_MGR_TO_ROLES
(
  MANAGER_ID NUMBER(20),
  ROLE_ID    NUMBER(20),
  UNIQUEID   NUMBER(20),
  IS_PRIMARY NUMBER(1)
)
;
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint PK_TMTBL_MGR_TO_ROLES primary key (UNIQUEID);
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint UK_TMTBL_MGR_TO_ROLES_MGR_ROLE unique (MANAGER_ID, ROLE_ID);
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint FK_TMTBL_MGR_TO_ROLES_MANAGER foreign key (MANAGER_ID)
  references TIMETABLE.TIMETABLE_MANAGER (UNIQUEID) on delete cascade;
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint FK_TMTBL_MGR_TO_ROLES_ROLE foreign key (ROLE_ID)
  references TIMETABLE.ROLES (ROLE_ID) on delete cascade;
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint NN_TMTBL_MGR_TO_ROLES_MGR_ID
  check ("MANAGER_ID" IS NOT NULL);
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint NN_TMTBL_MGR_TO_ROLES_PRIMARY
  check ("IS_PRIMARY" IS NOT NULL);
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint NN_TMTBL_MGR_TO_ROLES_ROLE_ID
  check ("ROLE_ID" IS NOT NULL);
alter table TIMETABLE.TMTBL_MGR_TO_ROLES
  add constraint NN_TMTBL_MGR_TO_ROLES_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table USERS
prompt ====================
prompt
create table TIMETABLE.USERS
(
  USERNAME     VARCHAR2(15) not null,
  PASSWORD     VARCHAR2(25),
  EXTERNAL_UID VARCHAR2(40)
)
;
alter table TIMETABLE.USERS
  add constraint PK_USERS primary key (USERNAME);
alter table TIMETABLE.USERS
  add constraint NN_USERS_PASSWD
  check (password is not null);

prompt
prompt Creating table USER_DATA
prompt ========================
prompt
create table TIMETABLE.USER_DATA
(
  EXTERNAL_UID VARCHAR2(12),
  NAME         VARCHAR2(100),
  VALUE        VARCHAR2(2048)
)
;
alter table TIMETABLE.USER_DATA
  add constraint PK_USER_DATA primary key (EXTERNAL_UID, NAME);
alter table TIMETABLE.USER_DATA
  add constraint NN_USER_DATA_KEY
  check ("NAME" IS NOT NULL);
alter table TIMETABLE.USER_DATA
  add constraint NN_USER_DATA_PUID
  check ("EXTERNAL_UID" IS NOT NULL);
alter table TIMETABLE.USER_DATA
  add constraint NN_USER_DATA_VALUE
  check ("VALUE" IS NOT NULL);

prompt
prompt Creating table WAITLIST
prompt =======================
prompt
create table TIMETABLE.WAITLIST
(
  UNIQUEID           NUMBER(20),
  STUDENT_ID         NUMBER(20),
  COURSE_OFFERING_ID NUMBER(20),
  TYPE               NUMBER(10) default (0),
  TIMESTAMP          DATE
)
;
alter table TIMETABLE.WAITLIST
  add constraint PK_WAITLIST primary key (UNIQUEID);
alter table TIMETABLE.WAITLIST
  add constraint FK_WAITLIST_COURSE_OFFERING foreign key (COURSE_OFFERING_ID)
  references TIMETABLE.COURSE_OFFERING (UNIQUEID) on delete cascade;
alter table TIMETABLE.WAITLIST
  add constraint FK_WAITLIST_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.WAITLIST
  add constraint NN_WAITLIST_OFFERING
  check ("COURSE_OFFERING_ID" IS NOT NULL);
alter table TIMETABLE.WAITLIST
  add constraint NN_WAITLIST_STUDENT
  check ("STUDENT_ID" IS NOT NULL);
alter table TIMETABLE.WAITLIST
  add constraint NN_WAITLIST_TS
  check ("TIMESTAMP" IS NOT NULL);
alter table TIMETABLE.WAITLIST
  add constraint NN_WAITLIST_TYPE
  check ("TYPE" IS NOT NULL);
alter table TIMETABLE.WAITLIST
  add constraint NN_WAITLIST_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);
create index TIMETABLE.IDX_WAITLIST_OFFERING on TIMETABLE.WAITLIST (COURSE_OFFERING_ID);
create index TIMETABLE.IDX_WAITLIST_STUDENT on TIMETABLE.WAITLIST (STUDENT_ID);

prompt
prompt Creating table XCONFLICT
prompt ========================
prompt
create table TIMETABLE.XCONFLICT
(
  UNIQUEID      NUMBER(20),
  CONFLICT_TYPE NUMBER(10),
  DISTANCE      FLOAT
)
;
alter table TIMETABLE.XCONFLICT
  add constraint PK_XCONFLICT primary key (UNIQUEID);
alter table TIMETABLE.XCONFLICT
  add constraint NN_XCONFLICT_TYPE
  check ("CONFLICT_TYPE" IS NOT NULL);
alter table TIMETABLE.XCONFLICT
  add constraint NN_XCONFLICT_UNIQUEID
  check ("UNIQUEID" IS NOT NULL);

prompt
prompt Creating table XCONFLICT_EXAM
prompt =============================
prompt
create table TIMETABLE.XCONFLICT_EXAM
(
  CONFLICT_ID NUMBER(20),
  EXAM_ID     NUMBER(20)
)
;
alter table TIMETABLE.XCONFLICT_EXAM
  add constraint PK_XCONFLICT_EXAM primary key (CONFLICT_ID, EXAM_ID);
alter table TIMETABLE.XCONFLICT_EXAM
  add constraint FK_XCONFLICT_EX_CONF foreign key (CONFLICT_ID)
  references TIMETABLE.XCONFLICT (UNIQUEID) on delete cascade;
alter table TIMETABLE.XCONFLICT_EXAM
  add constraint FK_XCONFLICT_EX_EXAM foreign key (EXAM_ID)
  references TIMETABLE.EXAM (UNIQUEID) on delete cascade;
alter table TIMETABLE.XCONFLICT_EXAM
  add constraint NN_XCONFLICT_EX_CONF
  check ("CONFLICT_ID" IS NOT NULL);
alter table TIMETABLE.XCONFLICT_EXAM
  add constraint NN_XCONFLICT_EX_EXAM
  check ("EXAM_ID" IS NOT NULL);
create index TIMETABLE.IDX_XCONFLICT_EXAM on TIMETABLE.XCONFLICT_EXAM (EXAM_ID);

prompt
prompt Creating table XCONFLICT_INSTRUCTOR
prompt ===================================
prompt
create table TIMETABLE.XCONFLICT_INSTRUCTOR
(
  CONFLICT_ID   NUMBER(20),
  INSTRUCTOR_ID NUMBER(20)
)
;
alter table TIMETABLE.XCONFLICT_INSTRUCTOR
  add constraint PK_XCONFLICT_INSTRUCTOR primary key (CONFLICT_ID, INSTRUCTOR_ID);
alter table TIMETABLE.XCONFLICT_INSTRUCTOR
  add constraint FK_XCONFLICT_IN_CONF foreign key (CONFLICT_ID)
  references TIMETABLE.XCONFLICT (UNIQUEID) on delete cascade;
alter table TIMETABLE.XCONFLICT_INSTRUCTOR
  add constraint FK_XCONFLICT_IN_INSTRUCTOR foreign key (INSTRUCTOR_ID)
  references TIMETABLE.DEPARTMENTAL_INSTRUCTOR (UNIQUEID) on delete cascade;
alter table TIMETABLE.XCONFLICT_INSTRUCTOR
  add constraint NN_XCONFLICT_IN_CONF
  check ("CONFLICT_ID" IS NOT NULL);
alter table TIMETABLE.XCONFLICT_INSTRUCTOR
  add constraint NN_XCONFLICT_IN_STUDENT
  check ("INSTRUCTOR_ID" IS NOT NULL);

prompt
prompt Creating table XCONFLICT_STUDENT
prompt ================================
prompt
create table TIMETABLE.XCONFLICT_STUDENT
(
  CONFLICT_ID NUMBER(20),
  STUDENT_ID  NUMBER(20)
)
;
alter table TIMETABLE.XCONFLICT_STUDENT
  add constraint PK_XCONFLICT_STUDENT primary key (CONFLICT_ID, STUDENT_ID);
alter table TIMETABLE.XCONFLICT_STUDENT
  add constraint FK_XCONFLICT_ST_CONF foreign key (CONFLICT_ID)
  references TIMETABLE.XCONFLICT (UNIQUEID) on delete cascade;
alter table TIMETABLE.XCONFLICT_STUDENT
  add constraint FK_XCONFLICT_ST_STUDENT foreign key (STUDENT_ID)
  references TIMETABLE.STUDENT (UNIQUEID) on delete cascade;
alter table TIMETABLE.XCONFLICT_STUDENT
  add constraint NN_XCONFLICT_ST_CONF
  check ("CONFLICT_ID" IS NOT NULL);
alter table TIMETABLE.XCONFLICT_STUDENT
  add constraint NN_XCONFLICT_ST_STUDENT
  check ("STUDENT_ID" IS NOT NULL);

prompt
prompt Creating sequence ACADEMIC_AREA_SEQ
prompt ===================================
prompt
create sequence TIMETABLE.ACADEMIC_AREA_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 141
increment by 1
cache 20;

prompt
prompt Creating sequence ACAD_CLASS_SEQ
prompt ================================
prompt
create sequence TIMETABLE.ACAD_CLASS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence ASSIGNMENT_SEQ
prompt ================================
prompt
create sequence TIMETABLE.ASSIGNMENT_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 142457
increment by 1
cache 20;

prompt
prompt Creating sequence BUILDING_SEQ
prompt ==============================
prompt
create sequence TIMETABLE.BUILDING_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1782
increment by 1
cache 20;

prompt
prompt Creating sequence CLASS_INSTRUCTOR_SEQ
prompt ======================================
prompt
create sequence TIMETABLE.CLASS_INSTRUCTOR_SEQ
minvalue 1
maxvalue 9999999999
start with 38108
increment by 1
cache 20;

prompt
prompt Creating sequence CRS_CREDIT_UNIG_CFG_SEQ
prompt =========================================
prompt
create sequence TIMETABLE.CRS_CREDIT_UNIG_CFG_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 27621
increment by 1
cache 20;

prompt
prompt Creating sequence CRS_OFFR_DEMAND_SEQ
prompt =====================================
prompt
create sequence TIMETABLE.CRS_OFFR_DEMAND_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 5992578
increment by 1
cache 20;

prompt
prompt Creating sequence CRS_OFFR_SEQ
prompt ==============================
prompt
create sequence TIMETABLE.CRS_OFFR_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 135753
increment by 1
cache 20;

prompt
prompt Creating sequence DATE_PATTERN_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.DATE_PATTERN_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 853
increment by 1
cache 20;

prompt
prompt Creating sequence DESIGNATOR_SEQ
prompt ================================
prompt
create sequence TIMETABLE.DESIGNATOR_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 3827
increment by 1
cache 20;

prompt
prompt Creating sequence DIST_OBJ_SEQ
prompt ==============================
prompt
create sequence TIMETABLE.DIST_OBJ_SEQ
minvalue 1
maxvalue 9999999999
start with 5752
increment by 1
cache 20;

prompt
prompt Creating sequence HISTORY_SEQ
prompt =============================
prompt
create sequence TIMETABLE.HISTORY_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence INSTRUCTOR_SEQ
prompt ================================
prompt
create sequence TIMETABLE.INSTRUCTOR_SEQ
minvalue 1
maxvalue 9999999999
start with 86446
increment by 1
cache 20;

prompt
prompt Creating sequence INSTR_OFFR_CONFIG_SEQ
prompt =======================================
prompt
create sequence TIMETABLE.INSTR_OFFR_CONFIG_SEQ
minvalue 1
maxvalue 9999999999
start with 36986
increment by 1
cache 20;

prompt
prompt Creating sequence INSTR_OFFR_PERMID_SEQ
prompt =======================================
prompt
create sequence TIMETABLE.INSTR_OFFR_PERMID_SEQ
minvalue 1
maxvalue 9999999999
start with 166820
increment by 1
cache 20;

prompt
prompt Creating sequence INSTR_OFFR_SEQ
prompt ================================
prompt
create sequence TIMETABLE.INSTR_OFFR_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 132351
increment by 1
cache 20;

prompt
prompt Creating sequence JENRL_SEQ
prompt ===========================
prompt
create sequence TIMETABLE.JENRL_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence LOC_PERM_ID_SEQ
prompt =================================
prompt
create sequence TIMETABLE.LOC_PERM_ID_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence POS_MAJOR_SEQ
prompt ===============================
prompt
create sequence TIMETABLE.POS_MAJOR_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1201
increment by 1
cache 20;

prompt
prompt Creating sequence PREF_GROUP_SEQ
prompt ================================
prompt
create sequence TIMETABLE.PREF_GROUP_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 231179
increment by 1
cache 20;

prompt
prompt Creating sequence PREF_LEVEL_SEQ
prompt ================================
prompt
create sequence TIMETABLE.PREF_LEVEL_SEQ
minvalue 1
maxvalue 9999999999
start with 8
increment by 1
cache 20;

prompt
prompt Creating sequence PREF_SEQ
prompt ==========================
prompt
create sequence TIMETABLE.PREF_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 123160
increment by 1
cache 20;

prompt
prompt Creating sequence QX__$TRIG_NUM
prompt ===============================
prompt
create sequence TIMETABLE.QX__$TRIG_NUM
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence REF_TABLE_SEQ
prompt ===============================
prompt
create sequence TIMETABLE.REF_TABLE_SEQ
minvalue 1
maxvalue 1000000
start with 425
increment by 1
cache 20;

prompt
prompt Creating sequence RESERVATION_SEQ
prompt =================================
prompt
create sequence TIMETABLE.RESERVATION_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 29643
increment by 1
cache 20;

prompt
prompt Creating sequence ROLE_SEQ
prompt ==========================
prompt
create sequence TIMETABLE.ROLE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence ROOM_DEPT_SEQ
prompt ===============================
prompt
create sequence TIMETABLE.ROOM_DEPT_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 4141
increment by 1
cache 20;

prompt
prompt Creating sequence ROOM_FEATURE_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.ROOM_FEATURE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 568
increment by 1
cache 20;

prompt
prompt Creating sequence ROOM_GROUP_SEQ
prompt ================================
prompt
create sequence TIMETABLE.ROOM_GROUP_SEQ
minvalue 1
maxvalue 9999999999
start with 6229
increment by 1
nocache;

prompt
prompt Creating sequence ROOM_SEQ
prompt ==========================
prompt
create sequence TIMETABLE.ROOM_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 7995
increment by 1
cache 20;

prompt
prompt Creating sequence ROOM_SHARING_GROUP_SEQ
prompt ========================================
prompt
create sequence TIMETABLE.ROOM_SHARING_GROUP_SEQ
minvalue 1
maxvalue 9999999999
start with 12627
increment by 1
cache 20;

prompt
prompt Creating sequence SETTINGS_SEQ
prompt ==============================
prompt
create sequence TIMETABLE.SETTINGS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 188
increment by 1
cache 20;

prompt
prompt Creating sequence SOLUTION_SEQ
prompt ==============================
prompt
create sequence TIMETABLE.SOLUTION_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 826
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_GROUP_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.SOLVER_GROUP_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 365
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_INFO_DEF_SEQ
prompt =====================================
prompt
create sequence TIMETABLE.SOLVER_INFO_DEF_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_INFO_SEQ
prompt =================================
prompt
create sequence TIMETABLE.SOLVER_INFO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 274999
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_PARAMETER_DEF_SEQ
prompt ==========================================
prompt
create sequence TIMETABLE.SOLVER_PARAMETER_DEF_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 301
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_PARAMETER_GROUP_SEQ
prompt ============================================
prompt
create sequence TIMETABLE.SOLVER_PARAMETER_GROUP_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 101
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_PARAMETER_SEQ
prompt ======================================
prompt
create sequence TIMETABLE.SOLVER_PARAMETER_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 95016
increment by 1
cache 20;

prompt
prompt Creating sequence SOLVER_PREDEF_SETTING_SEQ
prompt ===========================================
prompt
create sequence TIMETABLE.SOLVER_PREDEF_SETTING_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 121
increment by 1
cache 20;

prompt
prompt Creating sequence STAFF_SEQ
prompt ===========================
prompt
create sequence TIMETABLE.STAFF_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 3463061
increment by 1
cache 20;

prompt
prompt Creating sequence STUDENT_CONFLICT_SEQ
prompt ======================================
prompt
create sequence TIMETABLE.STUDENT_CONFLICT_SEQ
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence STUDENT_ENRL_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.STUDENT_ENRL_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 7619058
increment by 1
cache 20;

prompt
prompt Creating sequence STUDENT_GROUP_SEQ
prompt ===================================
prompt
create sequence TIMETABLE.STUDENT_GROUP_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence STUDENT_INFO_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.STUDENT_INFO_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 74861
increment by 1
cache 20;

prompt
prompt Creating sequence SUBJECT_AREA_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.SUBJECT_AREA_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 799
increment by 1
cache 20;

prompt
prompt Creating sequence TIMETABLE_GLOBAL_INFO_SEQ
prompt ===========================================
prompt
create sequence TIMETABLE.TIMETABLE_GLOBAL_INFO_SEQ
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence TIMETABLE_INFO_SEQ
prompt ====================================
prompt
create sequence TIMETABLE.TIMETABLE_INFO_SEQ
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence TIMETABLE_MGR_SEQ
prompt ===================================
prompt
create sequence TIMETABLE.TIMETABLE_MGR_SEQ
minvalue 1
maxvalue 99999999999999999999
start with 510
increment by 1
cache 20;

prompt
prompt Creating sequence TIMETABLE_SEQ
prompt ===============================
prompt
create sequence TIMETABLE.TIMETABLE_SEQ
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence TIMETABLE_SOLVER_PARAMETER_SEQ
prompt ================================================
prompt
create sequence TIMETABLE.TIMETABLE_SOLVER_PARAMETER_SEQ
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence TIME_PATTERN_DAYS_SEQ
prompt =======================================
prompt
create sequence TIMETABLE.TIME_PATTERN_DAYS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 4658
increment by 1
cache 20;

prompt
prompt Creating sequence TIME_PATTERN_SEQ
prompt ==================================
prompt
create sequence TIMETABLE.TIME_PATTERN_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1529
increment by 1
cache 20;

prompt
prompt Creating sequence TIME_PATTERN_TIMES_SEQ
prompt ========================================
prompt
create sequence TIMETABLE.TIME_PATTERN_TIMES_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 8861
increment by 1
cache 20;

prompt
prompt Creating sequence TMTBL_MGR_TO_ROLES_SEQ
prompt ========================================
prompt
create sequence TIMETABLE.TMTBL_MGR_TO_ROLES_SEQ
minvalue 1
maxvalue 9999999999
start with 550
increment by 1
cache 20;

prompt
prompt Creating sequence USER_SETTINGS_SEQ
prompt ===================================
prompt
create sequence TIMETABLE.USER_SETTINGS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 944
increment by 1
cache 20;

commit;

prompt
prompt Creating a job to compute statistics to run at 5:00am
prompt =====================================================
prompt
SET SERVEROUTPUT ON
DECLARE
  l_job  NUMBER;
BEGIN
  DBMS_JOB.submit(l_job,
                  'BEGIN DBMS_STATS.gather_schema_stats(ownname => ''TIMETABLE'', estimate_percent => 100, method_opt=>''for all columns size auto'', cascade=>true, options => ''GATHER''); END;',
                  trunc(SYSDATE),
                  'trunc(sysdate)+1+5/24');
  COMMIT;
  DBMS_OUTPUT.put_line('Timetable Stats Collection Job: ' || l_job);
END;
/

commit;

spool off