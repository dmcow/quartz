{ }
{ Thanks to Keith Chew for submitting this. }
{ }
{ use the StdJDBCDelegate with Informix. }
{ }
{ note that Informix has a 18 cahracter limit on the table name, so the prefix had to be shortened to "q" instread of "qrtz_" }

CREATE TABLE qblob_triggers (
TRIGGER_NAME varchar(80) NOT NULL,
TRIGGER_GROUP varchar(80) NOT NULL,
BLOB_DATA byte in table
);


ALTER TABLE qblob_triggers
ADD CONSTRAINT PRIMARY KEY (TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qcalendars (
CALENDAR_NAME varchar(80) NOT NULL,
CALENDAR byte in table NOT NULL
);


ALTER TABLE qcalendars
ADD CONSTRAINT PRIMARY KEY (CALENDAR_NAME);


CREATE TABLE qcron_triggers (
TRIGGER_NAME varchar(80) NOT NULL,
TRIGGER_GROUP varchar(80) NOT NULL,
CRON_EXPRESSION varchar(120) NOT NULL,
TIME_ZONE_ID varchar(80)
);


ALTER TABLE qcron_triggers
ADD CONSTRAINT PRIMARY KEY (TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qfired_triggers (
ENTRY_ID varchar(95) NOT NULL,
TRIGGER_NAME varchar(80) NOT NULL,
TRIGGER_GROUP varchar(80) NOT NULL,
INSTANCE_NAME varchar(80) NOT NULL,
FIRED_TIME numeric(13) NOT NULL,
PRIORITY integer NOT NULL,
STATE varchar(16) NOT NULL,
JOB_NAME varchar(80),
JOB_GROUP varchar(80),
IS_NONCONCURRENT varchar(1),
REQUESTS_RECOVERY varchar(1) 
);


ALTER TABLE qfired_triggers
ADD CONSTRAINT PRIMARY KEY (ENTRY_ID);


CREATE TABLE qpaused_trigger_grps (
TRIGGER_GROUP  varchar(80) NOT NULL
);

ALTER TABLE qpaused_trigger_grps
ADD CONSTRAINT PRIMARY KEY (TRIGGER_GROUP);


CREATE TABLE qscheduler_state (
INSTANCE_NAME varchar(80) NOT NULL,
LAST_CHECKIN_TIME numeric(13) NOT NULL,
CHECKIN_INTERVAL numeric(13) NOT NULL
);

ALTER TABLE qscheduler_state
ADD CONSTRAINT PRIMARY KEY (INSTANCE_NAME);


CREATE TABLE qlocks (
LOCK_NAME  varchar(40) NOT NULL
);

ALTER TABLE qlocks
ADD CONSTRAINT PRIMARY KEY (LOCK_NAME);

INSERT INTO qlocks values('TRIGGER_ACCESS');
INSERT INTO qlocks values('JOB_ACCESS');
INSERT INTO qlocks values('CALENDAR_ACCESS');
INSERT INTO qlocks values('STATE_ACCESS');



CREATE TABLE qjob_details (
JOB_NAME varchar(80) NOT NULL,
JOB_GROUP varchar(80) NOT NULL,
DESCRIPTION varchar(120),
JOB_CLASS_NAME varchar(128) NOT NULL,
IS_DURABLE varchar(1) NOT NULL,
IS_NONCONCURRENT varchar(1) NOT NULL,
IS_UPDATE_DATA varchar(1) NOT NULL,
REQUESTS_RECOVERY varchar(1) NOT NULL,
JOB_DATA byte in table
);


ALTER TABLE qjob_details
ADD CONSTRAINT PRIMARY KEY (JOB_NAME, JOB_GROUP);


CREATE TABLE qsimple_triggers (
TRIGGER_NAME varchar(80) NOT NULL,
TRIGGER_GROUP varchar(80) NOT NULL,
REPEAT_COUNT numeric(7) NOT NULL,
REPEAT_INTERVAL numeric(12) NOT NULL,
TIMES_TRIGGERED numeric(10) NOT NULL
);


ALTER TABLE qsimple_triggers
ADD CONSTRAINT PRIMARY KEY (TRIGGER_NAME, TRIGGER_GROUP);


CREATE TABLE qtriggers (
TRIGGER_NAME varchar(80) NOT NULL,
TRIGGER_GROUP varchar(80) NOT NULL,
JOB_NAME varchar(80) NOT NULL,
JOB_GROUP varchar(80) NOT NULL,
DESCRIPTION varchar(120),
NEXT_FIRE_TIME numeric(13),
PREV_FIRE_TIME numeric(13),
PRIORITY integer,
TRIGGER_STATE varchar(16) NOT NULL,
TRIGGER_TYPE varchar(8) NOT NULL,
START_TIME numeric(13) NOT NULL,
END_TIME numeric(13),
CALENDAR_NAME varchar(80),
MISFIRE_INSTR numeric(2),
JOB_DATA byte in table
);


ALTER TABLE qtriggers
ADD CONSTRAINT PRIMARY KEY (TRIGGER_NAME, TRIGGER_GROUP);


ALTER TABLE qblob_triggers
ADD CONSTRAINT FOREIGN KEY (TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;


ALTER TABLE qcron_triggers
ADD CONSTRAINT FOREIGN KEY (TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;


ALTER TABLE qsimple_triggers
ADD CONSTRAINT FOREIGN KEY (TRIGGER_NAME, TRIGGER_GROUP)
REFERENCES qtriggers;


ALTER TABLE qtriggers
ADD CONSTRAINT FOREIGN KEY (JOB_NAME, JOB_GROUP)
REFERENCES qjob_details; 

########## INDEXES #########################
create index iqt_next_fire_time on qtriggers(NEXT_FIRE_TIME);
create index iqt_state on qtriggers(TRIGGER_STATE);
create index iqt_nf_st on qtriggers(TRIGGER_STATE,NEXT_FIRE_TIME);
create index iqft_trig_name on qfired_triggers(TRIGGER_NAME);
create index iqft_trig_group on qfired_triggers(TRIGGER_GROUP);
create index iqft_trig_n_g on qfired_triggers(TRIGGER_NAME,TRIGGER_GROUP);
create index iqft_trig_ins_name on qfired_triggers(INSTANCE_NAME);
create index iqft_job_name on qfired_triggers(JOB_NAME);
create index iqft_job_group on qfired_triggers(JOB_GROUP);
