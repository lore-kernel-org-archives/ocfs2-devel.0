From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 27 Dec 2012 05:30:58 +0000
Subject: [Ocfs2-devel] Hi, is it an ocfs2 issue,
 would you have some good ideas? Thanks.  ( Part II)
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC771B@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


The above error is not appeared again after 18:10:01.

At the time about 18:58:00, the node 4, server14, is rebooted.

On the Server16, the syslog is as below, after the 19:00 pm there are not any errors in syslog:

Dec 25 18:58:21 Server16 kernel: [11656.038213] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 has been idle for 30.42 secs, shutting it down.
Dec 25 18:58:21 Server16 kernel: [11656.038253] o2net: No longer connected to node server14 (num 4) at 192.168.20.14:7100
Dec 25 18:58:39 Server16 kernel: [11674.053498] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:42 Server16 kernel: [11677.052047] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:45 Server16 kernel: [11680.050594] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:48 Server16 kernel: [11683.049138] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:51 Server16 kernel: [11686.047637] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:51 Server16 kernel: [11686.103617] o2net: No connection established with node 4 after 30.0 seconds, giving up.
Dec 25 18:58:54 Server16 kernel: [11688.791530] o2cb: o2dlm has evicted node 4 from domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:58:54 Server16 kernel: [11689.382018] o2dlm: Begin recovery on domain 3B55DD8C17CA4A368C1195E040324DCE for node 4
Dec 25 18:58:54 Server16 kernel: [11689.388464] o2dlm: Node 9 (me) is the Recovery Master for the dead node 4 in domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:59:01 Server16 CRON[19809]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 18:59:01 Server16 CRON[19808]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 18:59:25 Server16 kernel: [11720.007116] o2net: Connection to node Server19 (num 6) at 192.168.20.19:7100 has been idle for 30.107 secs, shutting it down.
Dec 25 18:59:25 Server16 kernel: [11720.007152] o2net: No longer connected to node Server19 (num 6) at 192.168.20.19:7100
Dec 25 18:59:25 Server16 kernel: [11720.007238] (libvirtd,3622,5):dlm_do_master_request:1332 ERROR: link to 6 went down!
Dec 25 18:59:25 Server16 kernel: [11720.024181] (libvirtd,3622,5):dlm_get_lock_resource:917 ERROR: status = -112
Dec 25 18:59:25 Server16 kernel: [11720.032794] (libvirtd,3622,5):dlm_restart_lock_mastery:1221 ERROR: node down! 4
Dec 25 18:59:25 Server16 kernel: [11720.049430] (libvirtd,3622,5):dlm_wait_for_lock_mastery:1038 ERROR: status = -11
Dec 25 18:59:43 Server16 kernel: [11738.022388] o2net: Connection to node Server19 (num 6) at 192.168.20.19:7100 shutdown, state 7
Dec 25 18:59:46 Server16 kernel: [11741.020966] o2net: Connection to node Server19 (num 6) at 192.168.20.19:7100 shutdown, state 7
Dec 25 18:59:49 Server16 kernel: [11744.019521] o2net: Connection to node Server19 (num 6) at 192.168.20.19:7100 shutdown, state 7
Dec 25 18:59:52 Server16 kernel: [11747.018067] o2net: Connection to node Server19 (num 6) at 192.168.20.19:7100 shutdown, state 7
Dec 25 18:59:55 Server16 kernel: [11750.016610] o2net: Connection to node Server19 (num 6) at 192.168.20.19:7100 shutdown, state 7
Dec 25 18:59:55 Server16 kernel: [11750.072553] o2net: No connection established with node 6 after 30.0 seconds, giving up.
Dec 25 18:59:56 Server16 kernel: [11750.885081] o2cb: o2dlm has evicted node 6 from domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 19:00:01 Server16 CRON[19971]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 19:00:01 Server16 CRON[19972]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 19:00:01 Server16 CRON[19973]: (root) CMD (   /opt/bin/ocfs2_sync_task.sh)
Dec 25 19:00:01 Server16 CRON[19974]: (root) CMD (   /opt/bin/ha_cleanup.sh)
Dec 25 19:00:01 Server16 CRON[19975]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Dec 25 19:01:01 Server16 CRON[21342]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 19:01:01 Server16 CRON[21341]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 19:02:01 Server16 CRON[21501]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 19:02:01 Server16 CRON[21503]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 19:02:01 Server16 CRON[21502]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Dec 25 19:03:01 Server16 CRON[21841]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 19:03:01 Server16 CRON[21842]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 19:04:01 Server16 CRON[22162]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 19:04:01 Server16 CRON[22163]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Dec 25 19:04:01 Server16 CRON[22164]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 19:04:44 Server16 kernel: [12039.321932] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 19:04:46 Server16 kernel: [12041.323643] o2net: Connected to node server14 (num 4) at 192.168.20.14:7100
Dec 25 19:05:01 Server16 CRON[22541]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 19:05:01 Server16 CRON[22544]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
Dec 25 19:05:01 Server16 CRON[22542]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 19:05:01 Server16 CRON[22543]: (root) CMD (   /opt/bin/ha_cleanup.sh)
Dec 25 19:05:13 Server16 kernel: [12067.530385] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 8
Dec 25 19:05:13 Server16 kernel: [12067.530452] o2net: No longer connected to node server14 (num 4) at 192.168.20.14:7100

It is strange that there is "Begin recovery", and Server16 does not has any "End recovery" log still.
In the OCFS2 code, there would be "End recovery... " logs.
.... ........... ....
master_here:
        dlm_print_recovery_master(dlm);    // There log the message: "Node 9 (me) is the Recovery Master for the dead node 4 in domain

        status = dlm_remaster_locks(dlm, dlm->reco.dead_node);
        if (status < 0) {
                /* we should never hit this anymore */
                mlog(ML_ERROR, "%s: Error %d remastering locks for node %u, "
                     "retrying.\n", dlm->name, status, dlm->reco.dead_node);
                /* yield a bit to allow any final network messages
                * to get handled on remaining nodes */
                msleep(100);
        } else {
                /* success!  see if any other nodes need recovery */
                mlog(0, "DONE mastering recovery of %s:%u here(this=%u)!\n",
                     dlm->name, dlm->reco.dead_node, dlm->node_num);
                dlm_reset_recovery(dlm);
        }
        dlm_end_recovery(dlm);

        /* continue and look for another dead node */
        return -EAGAIN;
}

It about 18:58:39, the node 4, server14 is rebooted.

On the other nodes, such as Server13, Server15, Server17, and so on, the log message is repeated until all the OCFS2 umounted and the o2cb service stopped.
The error log information is as below:
Dec 25 18:58:01 Server18 CRON[11925]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 18:58:04 Server18 kernel: [15320.745062] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:07 Server18 kernel: [15323.738643] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:10 Server18 kernel: [15326.732267] o2net: Connection to node server14 (num 4) at 192.168.20.14:7100 shutdown, state 7
Dec 25 18:58:10 Server18 kernel: [15326.788131] o2net: No connection established with node 4 after 30.0 seconds, giving up.
Dec 25 18:58:12 Server18 kernel: [15328.502721] (dlm_thread,4375,10):dlm_send_proxy_ast_msg:484 ERROR: 3B55DD8C17CA4A368C1195E040324DCE: res S000000000000000000000200000000, error -107 send AST to node 4
Dec 25 18:58:12 Server18 kernel: [15328.503552] (dlm_thread,4375,10):dlm_flush_asts:605 ERROR: status = -107
Dec 25 18:58:12 Server18 kernel: [15328.852857] o2cb: o2dlm has evicted node 4 from domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:58:13 Server18 kernel: [15330.010501] o2cb: o2dlm has evicted node 4 from domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:58:14 Server18 kernel: [15330.619912] o2dlm: Begin recovery on domain 3B55DD8C17CA4A368C1195E040324DCE for node 4
Dec 25 18:58:14 Server18 kernel: [15330.619918] o2dlm: Node 9 (he) is the Recovery Master for the dead node 4 in domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:58:14 Server18 kernel: [15330.619923] o2dlm: End recovery on domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:58:19 Server18 kernel: [15335.609250] o2dlm: Begin recovery on domain 3B55DD8C17CA4A368C1195E040324DCE for node 4
Dec 25 18:58:19 Server18 kernel: [15335.609258] o2dlm: Node 9 (he) is the Recovery Master for the dead node 4 in domain 3B55DD8C17CA4A368C1195E040324DCE
Dec 25 18:58:19 Server18 kernel: [15335.609262] o2dlm: End recovery on domain 3B55DD8C17CA4A368C1195E040324DCE
... ... ... ... ...
.......... Same logs repeated, until the server reboot....
... ... ... ... ...

The mounted point on server13, server14, server15 cannot be list the files; so the ocfs2 cluster may be blocked.

I delete all the cluster.conf from all the hosts, and restart them, remount the storage target again, and the ocfs2 cluster is OK, all the node can access the same target storage.

The Server16 may be blocked at 18:02:01, and other nodes wait for it to take over all the resources had mastered by the reboot node 4, Server14.
So the ocfs2 cluster may be in a dead lock status after 19:00:00, so as to rebuild the ocfs2 cluster again to avoid it.

I have more log message to help you to found the under reason.

Any good ideas?

Thanks, Have A Good holiday.
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
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20121227/e89116f6/attachment-0001.html 
