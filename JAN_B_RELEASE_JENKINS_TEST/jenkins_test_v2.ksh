bteq << EOF 1>>/dev/null 2>>/home/CTS462404/Jenkins_POC/Jenkins_bkp/error_log_test.txt
.logon 10.243.115.119/cts595195,password
.SET ECHOREQ OFF
.SET TITLEDASHES OFF
.SET WIDTH 100

.EXPORT REPORT FILE=/home/CTS462404/Jenkins_POC/Jenkins_bkp/test_result.txt
select count(*)(title '')  from jenkins_test_automate_new;
.EXPORT RESET

 .IF ERRORCODE > 0 THEN .GOTO PROCESS_PARM_FETCH_FAILURE;

.QUIT 0;

.LABEL PROCESS_PARM_FETCH_FAILURE
.REMARK '       *** Error Fetching parameter values from ${MTDAT_DB}.${PRCS_PARM_TAB} table for PRCS_NM: ${PRCS_NM}.'
.LOGOFF;
.QUIT;

EOF


RC=$?

if [ ${RC} -eq 0 ]
then
 export var_len_NM=`eval cat /home/CTS462404/Jenkins_POC/Jenkins_bkp/test_result.txt`
 export var_len_NM_PC3=`echo $var_len_NM|awk '{$1 = sprintf("%d", $1); print}'`
 echo $var_len_NM_PC3
 if [ ${var_len_NM_PC3} -ge 0 ]
 then
 echo "test successfull and table jenkins_test_automate_new exits with ${var_len_NM_PC3} rows"
 rm /home/CTS462404/Jenkins_POC/Jenkins_bkp/test_result.txt
 exit 0
 else
  echo "Failure in file check  at `date ` as no rows found "
  rm /home/CTS462404/Jenkins_POC/Jenkins_bkp/test_result.txt
  exit 1
 fi
else
 echo "Failure in file check  at `date `  "
 rm /home/CTS462404/Jenkins_POC/Jenkins_bkp/test_result.txt
 exit 1
fi
