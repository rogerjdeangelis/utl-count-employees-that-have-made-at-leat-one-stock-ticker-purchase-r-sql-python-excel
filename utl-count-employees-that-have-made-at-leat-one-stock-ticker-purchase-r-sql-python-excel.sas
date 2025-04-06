%let pgm=utl-count-employees-that-have-made-at-leat-one-stock-ticker-purchase-r-sql-python-excel;

%stop_submission;

   Count employees that have made at leat one stock ticker purchase r sql python excel

   CONTENTS

     1 sas sql
       https://communities.sas.com/t5/user/viewprofilepage/user-id/309052
     2 r sql
     3 python sql
     4 excel sql
       not shown see
       https://tinyurl.com/4e6yaap8

github
https://tinyurl.com/yx3535eu
https://github.com/rogerjdeangelis/utl-count-employees-that-have-made-at-leat-one-stock-ticker-purchase-r-sql-python-excel

communities.sas.com
https://tinyurl.com/mtp75amz
https://communities.sas.com/t5/SAS-Programming/Condensing-observations-by-variables-and-number-of-events/m-p/840117#M332194



I have normalzed the onput data.
I also selected just the data that was needed.

/*****************************************************************************************************************************/
/*           INPUT                     |  PROCESS                                   |           OUTPUT                       */
/*           =====                     |  =======                                   |           ======                       */
/*                                     |                                            |                                        */
/*     Obs    EMPL    TICK             | 1 SAS SQL (SELF EXPLANTORY)                |         TICK    COUNT                  */
/*                                     | ========= (EASY TO MAINTAIN)               |                                        */
/*       1    1001    ABX              |                                            |         ABX       3*                   */
/*       2    1001    ATX              | SORTED FOR DOCUMENTATION                   |         ATX       3                    */
/*       3    1001    BTR              | PERPOSES ONLY                              |         BTR       4                    */
/*       4    1001    SXX              |                                            |         KUL       2                    */
/*       5    1001    XYZ              |               DISTINCT                     |         LOV       3                    */
/*       ....                          | EMPL    TICK  EMPL x TICK                  |         MYX       4                    */
/*                                     |                                            |         SXX       2                    */
/*       67   1004    ATX              | 1001    ABX                                |         XYZ       3                    */
/*       68   1004    XYZ              | 1001    ABX   1                            |                                        */
/*       69   1004    ABX              | 1003    ABX   1                            |                                        */
/*       70   1004    KUL              | 1004    ABX                                |                                        */
/*                                     | 1004    ABX   1                            |                                        */
/*  options validvarname=upcase;       |               3* 1001,1003,1004            |                                        */
/*  libname sd1 "d:/sd1";              | 1001    ATX                                |                                        */
/*  data sd1.have;                     | 1001    ATX                                |                                        */
/*    informat empl tick $4.;          | 1001    ATX                                |                                        */
/*    input empl tick @@;              | 1001    ATX                                |                                        */
/*  cards4;                            | 1001    ATX                                |                                        */
/*  1001 ABX 1001 LOV 1003 MYX         | 1001    ATX   1                            |                                        */
/*  1001 ATX 1001 KUL 1003 BTR         | 1002    ATX                                |                                        */
/*  1001 BTR 1001 MYX 1003 BTR         | 1002    ATX                                |                                        */
/*  1001 SXX 1001 SXX 1003 ABX         | 1002    ATX                                |                                        */
/*  1001 XYZ 1002 MYX 1003 MYX         | 1002    ATX   1                            |                                        */
/*  1001 ATX 1002 LOV 1003 BTR         | 1004    ATX   1                            |                                        */
/*  1001 ATX 1002 ATX 1004 SXX         | 1004    ATX                                |                                        */
/*  1001 MYX 1002 ATX 1004 MYX         |               3                            |                                        */
/*  1001 LOV 1002 BTR 1004 MYX         | 1001    BTR                                |                                        */
/*  1001 LOV 1002 MYX 1004 XYZ         | 1001    BTR                                |                                        */
/*  1001 LOV 1002 ATX 1004 XYZ         | 1001    BTR   1                            |                                        */
/*  1001 MYX 1002 BTR 1004 ATX         | 1002    BTR                                |                                        */
/*  1001 SXX 1002 ATX 1004 KUL         | 1002    BTR   1                            |                                        */
/*  1001 MYX 1002 MYX 1004 ABX         | 1003    BTR                                |                                        */
/*  1001 SXX 1003 BTR 1004 KUL         | 1003    BTR                                |                                        */
/*  1001 ABX 1003 MYX 1004 SXX         | 1003    BTR                                |                                        */
/*  1001 BTR 1003 XYZ 1004 BTR         | 1003    BTR   1                            |                                        */
/*  1001 LOV 1003 MYX 1004 LOV         | 1004    BTR   1                            |                                        */
/*  1001 BTR 1003 MYX 1004 MYX         |               4                            |                                        */
/*  1001 ATX 1003 MYX 1004 MYX         |                                            |                                        */
/*  1001 ATX 1003 MYX 1004 MYX         | proc sql;                                  |                                        */
/*  1001 ATX 1003 MYX 1004 KUL         |    create                                  |                                        */
/*  1004 ATX 1004 XYZ 1004 ABX         |       table want as                        |                                        */
/*  1004 KUL                           |    select                                  |                                        */
/*  ;;;;                               |       tick                                 |                                        */
/*  run;quit;                          |      ,count(distinct empl)                 |                                        */
/*                                     |         as count                           |                                        */
/*                                     |    from                                    |                                        */
/*                                     |       sd1.have                             |                                        */
/*                                     |    group                                   |                                        */
/*                                     |       by tick                              |                                        */
/*                                     | ;quit;                                     |                                        */
/*                                     |                                            |                                        */
/*                                     |                                            |                                        */
/*                                     | 2 R SQL                                    |                                        */
/*                                     | ================================           |                                        */
/*                                     |                                            |                                        */
/*                                     | %utl_rbeginx;                              |                                        */
/*                                     | parmcards4;                                |                                        */
/*                                     | library(haven)                             |                                        */
/*                                     | library(sqldf)                             |                                        */
/*                                     | source("c:/oto/fn_tosas9x.R")              |                                        */
/*                                     | have<-read_sas(                            |                                        */
/*                                     | "d:/sd1/have.sas7bdat")                    |                                        */
/*                                     | have                                       |                                        */
/*                                     | want<-sqldf('                              |                                        */
/*                                     |    select                                  |                                        */
/*                                     |       tick                                 |                                        */
/*                                     |      ,count(distinct empl)                 |                                        */
/*                                     |         as count                           |                                        */
/*                                     |    from                                    |                                        */
/*                                     |       have                                 |                                        */
/*                                     |    group                                   |                                        */
/*                                     |       by tick                              |                                        */
/*                                     |    ')                                      |                                        */
/*                                     | print(want)                                |                                        */
/*                                     | fn_tosas9x(                                |                                        */
/*                                     |       inp    = want                        |                                        */
/*                                     |      ,outlib ="d:/sd1/"                    |                                        */
/*                                     |      ,outdsn ="want"                       |                                        */
/*                                     |      )                                     |                                        */
/*                                     | ;;;;                                       |                                        */
/*                                     | %utl_rendx;                                |                                        */
/*                                     |                                            |                                        */
/*                                     |                                            |                                        */
/*                                     | 3 PYTHON SQL                               |                                        */
/*                                     | ================================           |                                        */
/*                                     | %utl_pybeginx;                             |                                        */
/*                                     | parmcards4;                                |                                        */
/*                                     | exec(open('c:/oto/fn_python.py').read());  |                                        */
/*                                     | have,meta =  \                             |                                        */
/*                                     | ps.read_sas7bdat('d:/sd1/have.sas7bdat');  |                                        */
/*                                     | want=pdsql('''                             |                                        */
/*                                     |    select                  \               |                                        */
/*                                     |       tick                 \               |                                        */
/*                                     |      ,count(distinct empl) \               |                                        */
/*                                     |         as count           \               |                                        */
/*                                     |    from                    \               |                                        */
/*                                     |       have                 \               |                                        */
/*                                     |    group                   \               |                                        */
/*                                     |       by tick                              |                                        */
/*                                     |    ''');                                   |                                        */
/*                                     | print(want);                               |                                        */
/*                                     | fn_tosas9x(want,outlib='d:/sd1/' \         |                                        */
/*                                     | ,outdsn='pywant',timeest=3);               |                                        */
/*                                     | ;;;;                                       |                                        */
/*                                     | %utl_pyendx;                               |                                        */
/*                                     |                                            |                                        */
/*****************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have ;
  informat empl tick $4.;
  input empl tick @@;
cards4;
1001 ABX 1001 LOV 1003 MYX
1001 ATX 1001 KUL 1003 BTR
1001 BTR 1001 MYX 1003 BTR
1001 SXX 1001 SXX 1003 ABX
1001 XYZ 1002 MYX 1003 MYX
1001 ATX 1002 LOV 1003 BTR
1001 ATX 1002 ATX 1004 SXX
1001 MYX 1002 ATX 1004 MYX
1001 LOV 1002 BTR 1004 MYX
1001 LOV 1002 MYX 1004 XYZ
1001 LOV 1002 ATX 1004 XYZ
1001 MYX 1002 BTR 1004 ATX
1001 SXX 1002 ATX 1004 KUL
1001 MYX 1002 MYX 1004 ABX
1001 SXX 1003 BTR 1004 KUL
1001 ABX 1003 MYX 1004 SXX
1001 BTR 1003 XYZ 1004 BTR
1001 LOV 1003 MYX 1004 LOV
1001 BTR 1003 MYX 1004 MYX
1001 ATX 1003 MYX 1004 MYX
1001 ATX 1003 MYX 1004 MYX
1001 ATX 1003 MYX 1004 KUL
1004 ATX 1004 XYZ 1004 ABX
1004 KUL
;;;;
run;quit;

/**************************************************************************************************************************/
/* Obs    EMPL    TICK                                                                                                    */
/*                                                                                                                        */
/*   1    1001    ABX                                                                                                     */
/*   2    1001    LOV                                                                                                     */
/*   3    1003    MYX                                                                                                     */
/*   4    1001    ATX                                                                                                     */
/*   5    1001    KUL                                                                                                     */
/*   6    1003    BTR                                                                                                     */
/*   7    1001    BTR                                                                                                     */
/*   8    1001    MYX                                                                                                     */
/*   9    1003    BTR                                                                                                     */
/*  10    1001    SXX                                                                                                     */
/*  ...                                                                                                                   */
/*  61    1001    ATX                                                                                                     */
/*  62    1003    MYX                                                                                                     */
/*  63    1004    MYX                                                                                                     */
/*  64    1001    ATX                                                                                                     */
/*  65    1003    MYX                                                                                                     */
/*  66    1004    KUL                                                                                                     */
/*  67    1004    ATX                                                                                                     */
/*  68    1004    XYZ                                                                                                     */
/*  69    1004    ABX                                                                                                     */
/*  70    1004    KUL                                                                                                     */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
   create
      table want as
   select
      tick
     ,count(distinct empl)
        as count
   from
      sd1.have
   group
      by tick
;quit;

/**************************************************************************************************************************/
/* Obs    TICK    COUNT                                                                                                   */
/*                                                                                                                        */
/*  1     ABX       3                                                                                                     */
/*  2     ATX       3                                                                                                     */
/*  3     BTR       4                                                                                                     */
/*  4     KUL       2                                                                                                     */
/*  5     LOV       3                                                                                                     */
/*  6     MYX       4                                                                                                     */
/*  7     SXX       2                                                                                                     */
/*  8     XYZ       3                                                                                                     */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas(
"d:/sd1/have.sas7bdat")
have
want<-sqldf('
   select
      tick
     ,count(distinct empl)
        as count
   from
      have
   group
      by tick
   ')
print(want)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* R             |  SAS                                                                                                   */
/*  TICK  COUNT  |  ROWNAMES    TICK    COUNT                                                                             */
/*               |                                                                                                        */
/*   ABX     3   |      1       ABX       3                                                                               */
/*   ATX     3   |      2       ATX       3                                                                               */
/*   BTR     4   |      3       BTR       4                                                                               */
/*   KUL     2   |      4       KUL       2                                                                               */
/*   LOV     3   |      5       LOV       3                                                                               */
/*   MYX     4   |      6       MYX       4                                                                               */
/*   SXX     2   |      7       SXX       2                                                                               */
/*   XYZ     3   |      8       XYZ       3                                                                               */
/**************************************************************************************************************************/



proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta =  \
ps.read_sas7bdat('d:/sd1/have.sas7bdat');
want=pdsql('''
   select                  \
      tick                 \
     ,count(distinct empl) \
        as count           \
   from                    \
      have                 \
   group                   \
      by tick
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/' \
,outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/* R              |    SAS                                                                                                */
/*   TICK  count  |    TICK    COUNT                                                                                      */
/*                |                                                                                                       */
/* 0  ABX      3  |    ABX       3                                                                                        */
/* 1  ATX      3  |    ATX       3                                                                                        */
/* 2  BTR      4  |    BTR       4                                                                                        */
/* 3  KUL      2  |    KUL       2                                                                                        */
/* 4  LOV      3  |    LOV       3                                                                                        */
/* 5  MYX      4  |    MYX       4                                                                                        */
/* 6  SXX      2  |    SXX       2                                                                                        */
/* 7  XYZ      3  |    XYZ       3                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
