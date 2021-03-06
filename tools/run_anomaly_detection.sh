#!/bin/bash
stackname=$1
run_number=$2
echo scp anomaly detection jar to spark/0:/tmp/anomaly-detection_2.10-1.0.jar
juju scp ./bin/anomaly-detection_2.10-1.0.jar spark/0:/tmp
echo scp anomaly detection LARGE jar to spark/0:/tmp/anomaly-detection_2.10-1.0-large.jar
juju scp ./bin/anomaly-detection_2.10-1.0-large.jar spark/0:/tmp
echo Submit job
juju run --timeout=120m30s --unit spark/0 "su hdfs -c 'date > /tmp/spark_job_results.txt ; time /usr/bin/spark-submit --class MainRun /tmp/anomaly-detection_2.10-1.0.jar --master yarn >> /tmp/spark_job_results.txt ; date >> /tmp/spark_job_results.txt'"
echo get results
juju scp spark/0:/tmp/spark_job_results.txt ../results/${stackname}/spark_job_results-${run_number}.txt
