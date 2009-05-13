From: Oleg Gawriloff <barzog@telecom.by>
Date: Wed, 13 May 2009 21:44:57 +0300
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode()	call
In-Reply-To: <20090513183924.GE32316@mail.oracle.com>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
	<4A0AFEB4.2080000@telecom.by>
	<20090513183924.GE32316@mail.oracle.com>
Message-ID: <4A0B1529.6030701@telecom.by>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker ?????:
> 	There's no other error messages?  Can you give us a larger
> snippet of the log?
Here:
May 13 19:51:18 falcon-cl5
May 13 19:51:18 falcon-cl5 (8824,2):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 19:51:18 falcon-cl5
May 13 19:51:18 falcon-cl5 (8824,2):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 19:51:18 falcon-cl5
May 13 19:51:18 falcon-cl5 (8824,6):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 19:51:18 falcon-cl5
May 13 19:51:18 falcon-cl5 (8824,1):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 19:51:18 falcon-cl5
till 21:15 all the same:
May 13 21:15:35 falcon-cl5 (9246,6):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:15:35 falcon-cl5
May 13 21:15:35 falcon-cl5 (9246,4):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:15:35 falcon-cl5
May 13 21:15:35 falcon-cl5 (9246,5):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:15:35 falcon-cl5
May 13 21:15:35 falcon-cl5 (9246,7):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:15:35 falcon-cl5
May 13 21:15:35 falcon-cl5 (9246,0):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:15:35 falcon-cl5
May 13 21:15:35 falcon-cl5 (9246,2):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:15:35 falcon-cl5

Then I rebooted first node:
May 13 21:15:35 falcon-cl5 (9246,1):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:30:58 falcon-cl5 o2net: no longer connected to node falcon-cl1 
(num 0) at 172.16.2.228:7777
May 13 21:31:00 falcon-cl5 (5819,6):dlm_send_proxy_ast_msg:458 ERROR: 
status = -107
May 13 21:31:00 falcon-cl5 (5819,6):dlm_flush_asts:584 ERROR: status = -107
May 13 21:31:00 falcon-cl5 (5819,6):dlm_send_proxy_ast_msg:458 ERROR: 
status = -107
May 13 21:31:00 falcon-cl5 (5819,6):dlm_flush_asts:584 ERROR: status = -107
May 13 21:31:01 falcon-cl5 (5819,6):dlm_send_proxy_ast_msg:458 ERROR: 
status = -107
May 13 21:31:01 falcon-cl5 (5819,6):dlm_flush_asts:584 ERROR: status = -107
May 13 21:31:01 falcon-cl5 (5819,6):dlm_send_proxy_ast_msg:458 ERROR: 
status = -107
May 13 21:31:01 falcon-cl5 (5819,6):dlm_flush_asts:584 ERROR: status = -107
May 13 21:31:03 falcon-cl5 (9319,6):dlm_do_master_request:1352 ERROR: 
link to 0 went down!
May 13 21:31:03 falcon-cl5 (9319,6):dlm_get_lock_resource:929 ERROR: 
status = -107
some of same lines skipped:
May 13 21:31:03 falcon-cl5 (9319,6):dlm_do_master_request:1352 ERROR: 
link to 0 went down!
May 13 21:31:03 falcon-cl5 (9319,6):dlm_get_lock_resource:929 ERROR: 
status = -107
May 13 21:31:04 falcon-cl5 (344,6):dlm_send_remote_unlock_request:359 
ERROR: status = -107
May 13 21:31:04 falcon-cl5 (344,6):dlm_send_remote_unlock_request:359 
ERROR: status = -107
May 13 21:31:04 falcon-cl5 (344,6):dlm_send_remote_unlock_request:359 
ERROR: status = -107

Then first node starts:
May 13 21:33:38 falcon-cl5 (5762,6):o2net_connect_expired:1659 ERROR: no 
connection established with node 0 after 160.0 seconds, giving up and 
returning errors.
May 13 21:33:41 falcon-cl5 (344,6):dlm_send_remote_unlock_request:359 
ERROR: status = -107
May 13 21:33:41 falcon-cl5 (344,6):dlm_send_remote_unlock_request:359 
ERROR: status = -107
May 13 21:33:41 falcon-cl5 (344,6):dlm_send_remote_unlock_request:359 
ERROR: status = -107
May 13 21:33:49 falcon-cl5 (5819,3):dlm_drop_lockres_ref:2229 ERROR: 
status = -107
May 13 21:33:49 falcon-cl5 (5819,3):dlm_purge_lockres:190 ERROR: status 
= -107
May 13 21:33:49 falcon-cl5 (5819,3):dlm_drop_lockres_ref:2229 ERROR: 
status = -107
May 13 21:33:49 falcon-cl5 (5819,3):dlm_purge_lockres:190 ERROR: status 
= -107
May 13 21:33:49 falcon-cl5 (5819,3):dlm_drop_lockres_ref:2229 ERROR: 
status = -107
May 13 21:33:49 falcon-cl5 (5819,3):dlm_purge_lockres:190 ERROR: status 
= -107
May 13 21:35:31 falcon-cl5 (5837,7):o2dlm_eviction_cb:258 o2dlm has 
evicted node 0 from group 558A175E1CC94570940D9BEFCAE48B8E
May 13 21:35:31 falcon-cl5 (5837,7):o2dlm_eviction_cb:258 o2dlm has 
evicted node 0 from group 0AF561B8464D47C78DCC544ADC5273A5
May 13 21:35:31 falcon-cl5 (9367,2):dlm_get_lock_resource:856 
558A175E1CC94570940D9BEFCAE48B8E:M000000000000000000002682719dd6: at 
least one node (0) to recover before lock mastery can begin
May 13 21:35:31 falcon-cl5 (5837,0):o2dlm_eviction_cb:258 o2dlm has 
evicted node 0 from group A474A15478334D959A30A50ED6530ABE
May 13 21:35:31 falcon-cl5 (9368,7):dlm_get_lock_resource:856 
0AF561B8464D47C78DCC544ADC5273A5:M00000000000000000000a65cc0060a: at 
least one node (0) to recover before lock mastery can begin
May 13 21:35:31 falcon-cl5 (9369,0):dlm_get_lock_resource:856 
A474A15478334D959A30A50ED6530ABE:M00000000000000000000260046dbbf: at 
least one node (0) to recover before lock mastery can begin
May 13 21:35:32 falcon-cl5 (9367,2):dlm_get_lock_resource:910 
558A175E1CC94570940D9BEFCAE48B8E:M000000000000000000002682719dd6: at 
least one node (0) to recover before lock mastery can begin
May 13 21:35:32 falcon-cl5 (9368,7):dlm_get_lock_resource:910 
0AF561B8464D47C78DCC544ADC5273A5:M00000000000000000000a65cc0060a: at 
least one node (0) to recover before lock mastery can begin
May 13 21:35:32 falcon-cl5 (9369,0):dlm_get_lock_resource:910 
A474A15478334D959A30A50ED6530ABE:M00000000000000000000260046dbbf: at 
least one node (0) to recover before lock mastery can begin
May 13 21:35:34 falcon-cl5 (6309,6):dlm_restart_lock_mastery:1235 ERROR: 
node down! 0
May 13 21:35:34 falcon-cl5 (6309,6):dlm_wait_for_lock_mastery:1052 
ERROR: status = -11
May 13 21:35:34 falcon-cl5 (5840,3):dlm_get_lock_resource:856 
A474A15478334D959A30A50ED6530ABE:$RECOVERY: at least one node (0) to 
recover before lock mastery can begin
May 13 21:35:34 falcon-cl5 (5840,3):dlm_get_lock_resource:890 
A474A15478334D959A30A50ED6530ABE: recovery map is not empty, but must 
master $RECOVERY lock now
May 13 21:35:34 falcon-cl5 (5840,3):dlm_do_recovery:524 (5840) Node 4 is 
the Recovery Master for the Dead Node 0 for Domain 
A474A15478334D959A30A50ED6530ABE
May 13 21:35:34 falcon-cl5 (5830,7):dlm_get_lock_resource:856 
0AF561B8464D47C78DCC544ADC5273A5:$RECOVERY: at least one node (0) to 
recover before lock mastery can begin
May 13 21:35:34 falcon-cl5 (5830,7):dlm_get_lock_resource:890 
0AF561B8464D47C78DCC544ADC5273A5: recovery map is not empty, but must 
master $RECOVERY lock now
May 13 21:35:34 falcon-cl5 (5830,7):dlm_do_recovery:524 (5830) Node 4 is 
the Recovery Master for the Dead Node 0 for Domain 
0AF561B8464D47C78DCC544ADC5273A5
May 13 21:35:35 falcon-cl5 (6309,6):dlm_get_lock_resource:910 
558A175E1CC94570940D9BEFCAE48B8E:N0000000000a7b250: at least one node 
(0) to recover before lock mastery can begin
May 13 21:35:35 falcon-cl5 (5820,2):dlm_get_lock_resource:856 
558A175E1CC94570940D9BEFCAE48B8E:$RECOVERY: at least one node (0) to 
recover before lock mastery can begin
May 13 21:35:35 falcon-cl5 (5820,2):dlm_get_lock_resource:890 
558A175E1CC94570940D9BEFCAE48B8E: recovery map is not empty, but must 
master $RECOVERY lock now
May 13 21:35:35 falcon-cl5 (5820,2):dlm_do_recovery:524 (5820) Node 4 is 
the Recovery Master for the Dead Node 0 for Domain 
558A175E1CC94570940D9BEFCAE48B8E
May 13 21:35:43 falcon-cl5 (9367,1):ocfs2_replay_journal:1470 Recovering 
node 0 from slot 2 on device (8,64)
May 13 21:35:43 falcon-cl5 (9368,0):ocfs2_replay_journal:1470 Recovering 
node 0 from slot 2 on device (8,48)
May 13 21:35:43 falcon-cl5 (9369,3):ocfs2_replay_journal:1470 Recovering 
node 0 from slot 2 on device (8,32)
May 13 21:35:54 falcon-cl5 kjournald2 starting: pid 9370, dev sde:38, 
commit interval 5 seconds
May 13 21:35:54 falcon-cl5 kjournald2 starting: pid 9371, dev sdd:166, 
commit interval 5 seconds
May 13 21:35:54 falcon-cl5 (9367,3):ocfs2_begin_quota_recovery:374 
Beginning quota recovery in slot 2
May 13 21:35:54 falcon-cl5 (9368,2):ocfs2_begin_quota_recovery:374 
Beginning quota recovery in slot 2
May 13 21:35:54 falcon-cl5 kjournald2 starting: pid 9372, dev sdc:38, 
commit interval 5 seconds
May 13 21:35:55 falcon-cl5 (9369,5):ocfs2_begin_quota_recovery:374 
Beginning quota recovery in slot 2
May 13 21:35:55 falcon-cl5 (3127,2):ocfs2_finish_quota_recovery:564 
Finishing quota recovery in slot 2
May 13 21:35:56 falcon-cl5 (3127,4):ocfs2_finish_quota_recovery:564 
Finishing quota recovery in slot 2
May 13 21:35:56 falcon-cl5 (3127,4):ocfs2_finish_quota_recovery:564 
Finishing quota recovery in slot 2
May 13 21:35:57 falcon-cl5 o2net: connected to node falcon-cl1 (num 0) 
at 172.16.2.228:7777
May 13 21:36:01 falcon-cl5 ocfs2_dlm: Node 0 joins domain 
558A175E1CC94570940D9BEFCAE48B8E
May 13 21:36:01 falcon-cl5 ocfs2_dlm: Nodes in domain 
("558A175E1CC94570940D9BEFCAE48B8E"): 0 1 4
May 13 21:36:05 falcon-cl5 ocfs2_dlm: Node 0 joins domain 
0AF561B8464D47C78DCC544ADC5273A5
May 13 21:36:05 falcon-cl5 ocfs2_dlm: Nodes in domain 
("0AF561B8464D47C78DCC544ADC5273A5"): 0 1 4
May 13 21:36:10 falcon-cl5 ocfs2_dlm: Node 0 joins domain 
A474A15478334D959A30A50ED6530ABE
May 13 21:36:10 falcon-cl5 ocfs2_dlm: Nodes in domain 
("A474A15478334D959A30A50ED6530ABE"): 0 1 4
May 13 21:38:54 falcon-cl5

and all the same.
May 13 21:38:54 falcon-cl5 (9337,2):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:38:54 falcon-cl5
May 13 21:38:54 falcon-cl5 (9337,7):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:38:54 falcon-cl5
May 13 21:38:54 falcon-cl5 (9337,5):ocfs2_read_locked_inode:466 ERROR: 
status = -22
May 13 21:38:54 falcon-cl5
