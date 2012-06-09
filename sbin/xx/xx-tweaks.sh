#!/sbin/busybox sh

#### Optimize non-rotating storage ####
MMC=`ls -d /sys/block/mmc*`
SCHEDULER=`awk -F \[ '{print $2}' /sys/block/mmcblk0/queue/scheduler | awk -F \] '{print $1}'`

case $SCHEDULER in

  noop)
    for i in $MMC; do
      echo "noop" > $i/queue/scheduler
    done
  ;;

  deadline)
    for i in $MMC
    do
      echo 80 > $i/queue/iosched/read_expire
      echo 1 > $i/queue/iosched/fifo_batch
      echo 1 > $i/queue/iosched/front_merges
    done
    ;;

  cfq)
    for i in $MMC
    do
      echo "0" > $i/queue/rotational
      echo "1" > $i/queue/iosched/back_seek_penalty
      echo "1" > $i/queue/iosched/low_latency
      echo "3" > $i/queue/iosched/slice_idle
      echo "2048" > $i/queue/read_ahead_kb		# 128
      echo "1000000000" > $i/queue/iosched/back_seek_max
      echo "16" > $i/queue/iosched/quantum    		# 4
      echo "2048" > $i/queue/nr_requests		# 128
    done

    echo "0" > /proc/sys/kernel/sched_child_runs_first
  ;;

  bfq)
    for i in $MMC
    do
      echo "0" > $i/queue/rotational
      echo "1" > $i/queue/iosched/back_seek_penalty
      echo "3" > $i/queue/iosched/slice_idle
      echo "2048" > $i/queue/read_ahead_kb		# 128
      echo "1000000000" > $i/queue/iosched/back_seek_max
      echo "16" > $i/queue/iosched/quantum    		# 4
      echo "2048" > $i/queue/nr_requests		# 128
    done
  ;;

  *)

  ;;
esac

#### Optimize ondemand CPU governor ####
#echo "80000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
#echo "85" > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold


#### Tweak VM ####
echo "8192" > /proc/sys/vm/min_free_kbytes		# 3606
echo "90" > /proc/sys/vm/dirty_ratio			# 20
echo "20" > /proc/sys/vm/dirty_background_ratio 	# 5
echo "20" > /proc/sys/vm/vfs_cache_pressure		# 100
echo "0" > /proc/sys/vm/swappiness			# 60

#### Enable IDLE, AFTR, LPA ####
# 0 = IDLE
# 1 = AFTR
# 2 = LPA
# 3 = AFTR || LPA
echo "0" > /sys/module/cpuidle_exynos4/parameters/enable_mask

#### Enable SCHED_MC multicore scheduler, requires AFTR ####
# 0 = off (default)
# 1 = load core0 first
# 2 = distribute between cores
echo "0" > /sys/devices/system/cpu/sched_mc_power_savings

