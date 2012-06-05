From: Guozhonghua <guozhonghua@h3c.com>
Date: Tue, 5 Jun 2012 03:17:50 +0000
Subject: [Ocfs2-devel] one issue, someone may give some help,thanks
In-Reply-To: <mailman.2442.1338605978.11176.ocfs2-devel@oss.oracle.com>
References: <mailman.2442.1338605978.11176.ocfs2-devel@oss.oracle.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC1D5F@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

??Hi? I am using ocfs2 for test and find one issue, would someone give some help about it.
??
??The background is that we are using ocfs2 over iSCSI on Ubuntu 12.04, with kernel version 3.2.0-23.
??Linux 3.2.0-23-generic x86_64 GNU/Linux
??
??We changed the configuration file of iSCSI, initiatorname.iscsi file, so as to restart the iSCSI service with the command "service open-iscsi restart".
??After the restart of iscsi service, the device that ocfs2 using is missed, and the log is written to kern.log as below:
??Jun  5 09:10:06 vmc-7 kernel: [45946.187897] sd 6:0:0:13: [sde] Attached SCSI disk
??Jun  5 09:10:07 vmc-7 kernel: [45946.439225] (o2hb-692FC96E2F,2786,5):o2hb_bio_end_io:389 ERROR: IO Error -19
??Jun  5 09:10:07 vmc-7 kernel: [45946.439673] (o2hb-692FC96E2F,2786,5):o2hb_do_disk_heartbeat:1017 ERROR: status = -19
??Jun  5 09:10:07 vmc-7 kernel: [45947.117979] (o2hb-58592532BC,2804,2):o2hb_bio_end_io:389 ERROR: IO Error -19
??Jun  5 09:10:07 vmc-7 kernel: [45947.118413]
??... ... .... ...
?? (o2hb-58592532BC,2804,0):o2hb_bio_end_io:389 ERROR: IO Error -19
??Jun  5 09:10:53 vmc-7 kernel: [45993.143578] (o2hb-58592532BC,2804,0):o2hb_do_disk_heartbeat:1017 ERROR: status = -19
??
??The heartbeat timeout is 31 seconds configured as below.
??# O2CB_HEARTBEAT_THRESHOLD: Iterations before a node is considered dead.
??O2CB_HEARTBEAT_THRESHOLD=31
??
??root at vmc-7:/sys/kernel/config/cluster/iPool/heartbeat# cat dead_threshold
??31
??
??Why elapse more than 50 seconds, the server does not reset?
??
??I review the code of kernel with version 3.2.2, and puzzled with heartbeat code as below, is it right that the loop does not break out so as the server does not reset.
??static int o2hb_thread(void *data)
??{
??      ... ... ...
??
?? while (!kthread_should_stop() &&
??             !reg->hr_unclean_stop && !reg->hr_aborted_start) {
??
??  }
??}
??
??In the function o2hb_do_disk_heartbeat(struct o2hb_region *reg), while
??ret = o2hb_read_slots(reg, highest_node + 1); error with 19, ENODEV, the device may be does not existed for the iSCSI service restart.
??
??Is anything wrong with it?
??
??Thanks.
??
??
??***************************************************************************************
???????????H3C????????????????????????????????????????????????????????????????????????????????????????????????????????
??**************************************************************************************
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
