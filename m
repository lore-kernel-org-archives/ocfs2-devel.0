From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 31 Jul 2013 10:51:38 +0000
Subject: [Ocfs2-devel] Heart beat source code review and test,
 founding it may be not correct. Is the changes OK,
 requesting reviews and advices.
Message-ID: <71604351584F6A4EBAE558C676F37CA417BDDA26@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I find some code may be not correct as reviewing the heart beat code and test that.
The heart beat writing onto disk.
I have another question that why not encapsulate the o2hb_wait_on_io into the function o2hb_issue_node_write, just as the function o2hb_read_slots.
I don't know whether the changes is correct.
Requesting reviews of the changes? Thanks.


diff -p -C 6 cluster-old/heartbeat.c cluster-new/heartbeat.c
*** cluster-old/heartbeat.c    2013-07-31 18:18:35.625069131 +0800
--- cluster-new/heartbeat.c    2013-07-31 18:18:35.613069052 +0800
*************** static int o2hb_do_disk_heartbeat(struct
*** 1029,1046 ****
      ret = o2hb_issue_node_write(reg, &write_wc);
      if (ret < 0) {
              mlog_errno(ret);
              goto bail;
      }

-      i = -1;
-      while((i = find_next_bit(configured_nodes,
-                               O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
-              membership_change |= o2hb_check_slot(reg, &reg->hr_slots[i]);
-      }
-
      /*
       * We have to be sure we've advertised ourselves on disk
       * before we can go to steady state.  This ensures that
       * people we find in our steady state have seen us.
       */
      o2hb_wait_on_io(reg, &write_wc);
--- 1029,1040 ----
*************** static int o2hb_do_disk_heartbeat(struct
*** 1058,1069 ****
--- 1052,1069 ----
      if (own_slot_ok) {
              o2hb_set_quorum_device(reg);
              o2hb_arm_write_timeout(reg);
      }

  bail:
+     i = -1;
+     while((i = find_next_bit(configured_nodes,
+                              O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
+             membership_change |= o2hb_check_slot(reg, &reg->hr_slots[i]);
+     }
+
      /* let the person who launched us know when things are steady */
      if (atomic_read(&reg->hr_steady_iterations) != 0) {
              if (!ret && own_slot_ok && !membership_change) {
                      if (atomic_dec_and_test(&reg->hr_steady_iterations))
                              wake_up(&o2hb_steady_queue);
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130731/6b7e3589/attachment-0001.html 
