drop table MMatrix;
drop table NMatrix;
drop table MidMatrix;

create table MMatrix (
  mrow int,
  mcol int,
  mval double)
row format delimited fields terminated by ',' stored as textfile;

create table NMatrix (
  nrow int,
  ncol int,
  nval double)
row format delimited fields terminated by ',' stored as textfile;

create table MidMatrix (
  midrow int,
  midcol int,
  midval double)
row format delimited fields terminated by ',' stored as textfile;

load data local inpath '${hiveconf:M}' overwrite into table MMatrix;
load data local inpath '${hiveconf:N}' overwrite into table NMatrix;

INSERT OVERWRITE TABLE MidMatrix
select m.mrow,n.ncol,sum(m.mval*n.nval)
from MMatrix as m full outer join NMatrix as n on m.mcol = n.nrow
GROUP BY m.mrow,n.ncol;

Select count(midrow),avg(midval) from MidMatrix;
