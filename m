From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 26 Aug 2016 02:09:02 +0000
Subject: [Ocfs2-devel] One issue and its scenarios,
	the patch for reviews. Thank you.
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D30E19@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi, All;

38734:Jul 22 22:18:02 server171 kernel: [ 1284.747194] (dlm_reco-BE66E8,23324,5):dlm_get_lock_resource:995 BE66E8375C9A472D9472456A511B2835: res $RECOVERY, Node map changed, redo the master request now, blocked=1
38930:Jul 22 22:18:52 server171 kernel: [ 1334.786242] (dlm_reco-BE66E8,23324,5):dlm_get_lock_resource:995 BE66E8375C9A472D9472456A511B2835: res $RECOVERY, Node map changed, redo the master request now, blocked=1
39118:Jul 22 22:21:02 server171 kernel: [ 1464.887764] (dlm_reco-BE66E8,23324,14):dlm_get_lock_resource:995 BE66E8375C9A472D9472456A511B2835: res $RECOVERY, Node map changed, redo the master request now, blocked=1
39247:Jul 22 22:23:37 server171 kernel: [ 1620.008748] (dlm_reco-BE66E8,23324,4):dlm_wait_for_lock_mastery:1176 BE66E8375C9A472D9472456A511B2835:$RECOVERY: restart lock mastery againnot to recheck when sleep
39249:Jul 22 22:23:37 server171 kernel: [ 1620.008758] (dlm_reco-BE66E8,23324,4):dlm_get_lock_resource:995 BE66E8375C9A472D9472456A511B2835: res $RECOVERY, Node map changed, redo the master request now, blocked=1
39340:Jul 22 22:26:12 server171 kernel: [ 1775.129777] (dlm_reco-BE66E8,23324,3):dlm_wait_for_lock_mastery:1176 BE66E8375C9A472D9472456A511B2835:$RECOVERY: restart lock mastery againnot to recheck when sleep

Other information's:
root at server171:/sys/kernel/debug/o2dlm/BE66E8375C9A472D9472456A511B2835# cat dlm_state
Domain: BE66E8375C9A472D9472456A511B2835  Key: 0xa5a35693  Protocol: 1.2
Thread Pid: 23323  Node: 2  State: JOINED
Number of Joins: 1  Joining Node: 255
Domain Map: 2
Exit Domain Map:
Live Map: 1 2 4 5
Lock Resources: 49 (56)
MLEs: 1 (66)
  Blocking: 1 (17)
  Mastery: 0 (49)
  Migration: 0 (0)
Lists: Dirty=InUse  Purge=Empty  PendingASTs=Empty  PendingBASTs=Empty
Purge Count: 0  Refs: 1
Dead Node: 8
Recovery Pid: 23324  Master: 255  State: ACTIVE
Recovery Map: 1 3 4 5 6 7 8 9
Recovery Node State:

root at server171:/sys/kernel/debug/o2dlm/BE66E8375C9A472D9472456A511B2835# cat mle_state
Dumping MLEs for Domain: BE66E8375C9A472D9472456A511B2835
$RECOVERY       BLK     mas=255 new=255 evt=1   use=1   ref=  3
Maybe=
Vote=
Response=
Node=

Total: 1, Longest: 1


When all other nodes down, and mle's node map will be empty, so local node should not wait for other node response while voted done.

--- E:\dev\v1r3b01d000_newFeature_fence_bugfix\kernel\ocfs2\dlm\dlmmaster.c   2016-07-14 16:00:00.000000000 +0800
+++ E:\dev\project\ocfs2_fence_opt\ocfs2_fence_opt\ocfs2-ko-4.1.x\ocfs2\dlm\dlmmaster.c  2016-07-23 19:47:53.000000000 +0800
               }
               goto recheck;
       } else {
               if (!voting_done) {
                       mlog(0, "map not changed and voting not done "
                            "for %s:%.*s\n", dlm->name, res->lockname.len,
@@ -1120,24 +1121,26 @@
               /* another node has done an assert!
                * all done! */
               sleep = 0;
       } else {
               sleep = 1;
               /* have all nodes responded? */
-               if (voting_done && !*blocked) {
+              if (voting_done){
                       bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, 0);
-                       if (dlm->node_num <= bit) {
+                      mle_node = find_next_bit(mle->node_map, O2NM_MAX_NODES, 0);
+                      if ((!*blocked && dlm->node_num <= bit) || mle_node >= O2NM_MAX_NODES) {
                               /* my node number is lowest.
                                * now tell other nodes that I am
                                * mastering this. */
                               mle->master = dlm->node_num;
                               /* ref was grabbed in get_lock_resource
                                * will be dropped in dlmlock_master */
                               assert = 1;
                               sleep = 0;
                       }

                       /* if voting is done, but we have not received
                        * an assert master yet, we must sleep */
               }
       }

        spin_unlock(&mle->spinlock);



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
