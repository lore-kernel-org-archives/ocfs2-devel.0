From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 4 Apr 2014 09:17:37 +0000
Subject: [Ocfs2-devel] one  issue reports,
 is there any advice with the code reviewed? thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3F081@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, everyone

We setup 8 nodes to run ocfs2 as the storage pool providing storage service.
The test scenario is on the OS of Ubuntu with kernel version 3.13.6.
As the node 7 rebooted, all the other nodes blocked.
The other nodes is racing to be the master of DLM_RECOVERY_LOCK_NAME($RECOVERY), but there is not any one will be successfully, and all of them still loop and wait.
So all the other node running unstopped loop, and print the log info as below.
The debug level is changed about on Apr 2 18:00:00, so the debug info is begin about 18:02:16.


Apr  2 15:24:21 node-01 kernel: [64409.487556] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:24:26 node-01 kernel: [64414.350643] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:02:16 node-01 kernel: [73879.177060] (dlm_reco_thread,7871,3):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:02:16 node-01 kernel: [73879.177068] (dlm_reco_thread,7871,3):dlm_wait_for_lock_mastery:1046 map not changed and voting not done for 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY
Apr  2 18:02:21 node-01 kernel: [73884.174312] (dlm_reco_thread,7871,4):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
......  same as above.

Apr  2 15:24:09 node-02 kernel: [330500.807738] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:24:13 node-02 kernel: [330504.679296] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:57:38 node-02 kernel: [343302.676048] (dlm_reco_thread,39426,9):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:57:38 node-02 kernel: [343302.676055] (dlm_reco_thread,39426,9):dlm_wait_for_lock_mastery:1046 map not changed and voting not done for 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY
Apr  2 18:57:43 node-02 kernel: [343307.673271] (dlm_reco_thread,39426,10):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
......  same as above.

Apr  2 15:24:47 node-03 kernel: [105816.250867] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:24:49 node-03 kernel: [105818.291396] (dlm_thread,6493,8):dlm_send_proxy_ast_msg:482 ERROR: 2D2B1913CA08467896AC80B2F1AA80DB: res M00000000000000000002084cc0d288, error -107 send AST to node 4
Apr  2 15:24:50 node-03 kernel: [105819.679081] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:58:46 node-03 kernel: [118649.084903] (dlm_reco_thread,6494,9):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:58:46 node-03 kernel: [118649.084911] (dlm_reco_thread,6494,9):dlm_wait_for_lock_mastery:1046 map not changed and voting not done for 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY
Apr  2 18:58:51 node-03 kernel: [118654.082626] (dlm_reco_thread,6494,9):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
......  same as above.

Apr  2 15:24:50 node-04 kernel: [330501.154090] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:24:51 node-04 kernel: [330502.229376] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:59:09 node-04 kernel: [343353.348762] (dlm_reco_thread,38197,2):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:59:14 node-04 kernel: [343358.345980] (dlm_reco_thread,38197,2):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:59:19 node-04 kernel: [343363.343207] (dlm_reco_thread,38197,2):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:59:24 node-04 kernel: [343368.340485] (dlm_reco_thread,38197,3):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
......  same as above.

Apr  2 15:24:18 node-05 kernel: [330489.928160] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:24:21 node-05 kernel: [330492.969521] o2dlm: Waiting on the recovery of node 7 in domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:24:22 node-05 kernel: [330494.168849] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:58:52 node-05 kernel: [343357.161638] (dlm_reco_thread,24064,6):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:58:52 node-05 kernel: [343357.161644] (dlm_reco_thread,24064,6):dlm_wait_for_lock_mastery:1046 map not changed and voting not done for 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY
Apr  2 18:58:57 node-05 kernel: [343362.158919] (dlm_reco_thread,24064,7):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
......  same as above.

Apr  2 15:23:24 node-06 kernel: [330529.804363] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:23:28 node-06 kernel: [330533.733262] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:58:08 node-06 kernel: [343408.025502] (dlm_reco_thread,28213,5):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:58:08 node-06 kernel: [343408.025509] (dlm_reco_thread,28213,5):dlm_wait_for_lock_mastery:1046 map not changed and voting not done for 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY
Apr  2 18:58:13 node-06 kernel: [343413.023209] (dlm_reco_thread,28213,0):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again

Apr  2 18:24:26 node-07 kernel: [ 4010.492579] (mount.ocfs2,11993,2):dlm_join_domain:1932 Timed out joining dlm domain 2D2B1913CA08467896AC80B2F1AA80DB after 91200 msecs
Apr  2 18:33:04 node-07 kernel: [ 4528.414250] (mount.ocfs2,31116,11):dlm_register_domain:2138 register called for domain "2D2B1913CA08467896AC80B2F1AA80DB"
... ... ... ...
Apr  2 18:33:04 node-07 kernel: [ 4528.415465] (mount.ocfs2,31116,11):sc_put:417 [sc ffff8817f8f98000 refs 4 sock ffff8817fd3b8f00 node 1 page ffffea005fc67240 pg_off 0] put
Apr  2 18:33:04 node-07 kernel: [ 4528.415469] (mount.ocfs2,31116,11):dlm_request_join:1522 status 0, node 1 response is 0                                 Here the node 1 disallow the node 7 to join the domain.
Apr  2 18:33:04 node-07 kernel: [ 4528.415471] (mount.ocfs2,31116,11):dlm_should_restart_join:1598 Latest response of disallow -- should restart
Apr  2 18:33:04 node-07 kernel: [ 4528.415474] (mount.ocfs2,31116,11):dlm_try_to_join_domain:1724 returning -11
Apr  2 18:33:04 node-07 kernel: [ 4528.415476] (mount.ocfs2,31116,11):dlm_join_domain:1946 backoff 600
... ... ... ...
Apr  2 18:33:28 node-07 kernel: [ 4551.869493] (mount.ocfs2,31116,2):dlm_join_domain:1932 Timed out joining dlm domain 2D2B1913CA08467896AC80B2F1AA80DB after 91200 msecs
... ... ... ...
Apr  2 19:00:26 node-07 kernel: [ 6168.900707] (mount.ocfs2,19177,6):dlm_ctxt_release:338 freeing memory from domain 2D2B1913CA08467896AC80B2F1AA80DB

Apr  2 15:23:42 node-08 kernel: [330502.270181] o2cb: o2dlm has evicted node 7 from domain 2D2B1913CA08467896AC80B2F1AA80DB
Apr  2 15:23:43 node-08 kernel: [330503.054257] o2dlm: Begin recovery on domain 2D2B1913CA08467896AC80B2F1AA80DB for node 7
Apr  2 18:58:48 node-08 kernel: [343401.119756] (dlm_reco_thread,61931,10):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
Apr  2 18:58:48 node-08 kernel: [343401.119763] (dlm_reco_thread,61931,10):dlm_wait_for_lock_mastery:1046 map not changed and voting not done for 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY
Apr  2 18:58:53 node-08 kernel: [343406.116991] (dlm_reco_thread,61931,11):dlm_wait_for_lock_mastery:1092 2D2B1913CA08467896AC80B2F1AA80DB:$RECOVERY: waiting again
......  same as above.


As the code reviewed times, I think there is may be one bug in the function:
static int dlm_wait_for_lock_mastery(struct dlm_ctxt *dlm,
                                     struct dlm_lock_resource *res,
                                     struct dlm_master_list_entry *mle,
                                     int *blocked)
{
        ... ... ...
if (res->owner == O2NM_MAX_NODES) {
                        mlog(0, "%s:%.*s: waiting again\n", dlm->name,
                             res->lockname.len, res->lockname.name);

            // if ther network failure and not any tcp msg received(tcp package lost), map not changed, and the master racing should be retriggered again.
+           ret = -EAGAIN;
+           goto leave;
-           goto recheck;
              }
        ... ... ...

}



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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140404/2e0cf8a1/attachment-0001.html 
