From: Guozhonghua <guozhonghua@h3c.com>
Date: Sat, 7 May 2016 11:30:12 +0000
Subject: [Ocfs2-devel] Dead lock and cluster blocked,
	any advices will be appreciated.
Message-ID: <71604351584F6A4EBAE558C676F37CA482951330@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, we had find one dead lock scenario.

Suddenly, the Node 2 is rebooted(fenced) for IO error accessing storage. So its slot 2 is remained valid on storage disk.
The node 1 which is in the same cluster with node 2, is to mount the same disk.  At the same time, the node 2 restarted and mount the same disk.

So the work flow is as below.

 Node 1                                                   Node 2
 ocfs2_dlm_init                                                                  ocfs2_dlm_init
 ocfs2_super_lock                                                                    waiting ocfs2_super_lock
 ocfs2_find_slot
 ocfs2_check_volume
 ocfs2_mark_dead_nodes
   ocfs2_slot_to_node_num_locked
   Finding node slot 2 is valid
   and set it into recovery map

   ocfs2_trylock_journal
     This time, try lock journal:0002
     will successfully for node 2 is
     waiting super lock.

     ocfs2_recovery_thread
        Starting recovery for node 2
   ocfs2_super_unlock
                                                                                                                 ocfs2_dlm_init
                                                                                                                 ocfs2_super_lock
                                                                                                                 ocfs2_find_slot
                                                                                                                    Grant the journal:0002 lock with slot 2
                                                                                                                 ocfs2_super_unlock
  __ocfs2_recovery_thread
        ocfs2_super_lock
        ocfs2_recover_node
           Recovering node 2, to granted journal:0002
           Node 1 will still waiting for node 2.
           And Node 2 will never release the journal:0002            .... ....
                                                             ocfs2_super_lock
                                                                                                                     At this time node 2 will waiting node 1 to release super lock;
                                                                                                                         So One dead lock occurred.




Stack, and lock res infos:
        122 /dev/dm-1: LABEL="o20160426150630" UUID="83269946-3428-4a04-8d78-1d76053b3f28" TYPE="ocfs2"
        123
        124     find deadlock on /dev/dm-1
        125 Lockres: M000000000000000000026a863e451d  Mode: No Lock
        126 Flags: Initialized Attached Busy
        127 RO Holders: 0  EX Holders: 0
        128 Pending Action: Convert  Pending Unlock Action: None
        129 Requested Mode: Exclusive  Blocking Mode: No Lock
        130 PR > Gets: 0  Fails: 0    Waits Total: 0us  Max: 0us  Avg: 0ns
        131 EX > Gets: 1  Fails: 0    Waits Total: 772us  Max: 772us  Avg: 772470ns
        132 Disk Refreshes: 1
        133
        134     inode of lock: M000000000000000000026a863e451d is 000000000000026a, file is:
        135         618     //journal:0002
        136     lock: M000000000000000000026a863e451d on local is:
        137 Lockres: M000000000000000000026a863e451d   Owner: 1    State: 0x0
        138 Last Used: 0      ASTs Reserved: 0    Inflight: 0    Migration Pending: No
        139 Refs: 4    Locks: 2    On Lists: None
        140 Reference Map: 2
        141  Lock-Queue  Node  Level  Conv  Cookie           Refs  AST  BAST  Pending-Action
        142  Granted     2     EX     -1    2:18553          2     No   No    None
        143  Converting  1     NL     EX    1:15786          2     No   No    None
        144
        145     Local host is the Owner of M000000000000000000026a863e451d

Node 1
  ========= find hung_up process ==========
  2 16398 D    kworker/u128:0  ocfs2_wait_for_recovery
  3 35883 D    ocfs2rec-832699 ocfs2_cluster_lock.isra.37
  4 36601 D    df              ocfs2_wait_for_recovery
  5 54451 D    kworker/u128:2  chbk_store_chk_proc
  6 62872 D    kworker/u128:3  ocfs2_wait_for_recovery
  7
  8 ========== get stack of 16398 ==========
  9
 10 [<ffffffffc06367a5>] ocfs2_wait_for_recovery+0x75/0xc0 [ocfs2]
 11 [<ffffffffc0621d68>] ocfs2_inode_lock_full_nested+0x318/0xc50 [ocfs2]
 12 [<ffffffffc063b210>] ocfs2_complete_local_alloc_recovery+0x70/0x3f0 [ocfs2]
 13 [<ffffffffc063698e>] ocfs2_complete_recovery+0x19e/0xfa0 [ocfs2]
 14 [<ffffffff81096e64>] process_one_work+0x144/0x4c0
 15 [<ffffffff810978fd>] worker_thread+0x11d/0x540
 16 [<ffffffff8109def9>] kthread+0xc9/0xe0
 17 [<ffffffff817f6a22>] ret_from_fork+0x42/0x70
 18 [<ffffffffffffffff>] 0xffffffffffffffff
 19
 20 ========== get stack of 35883 ==========
 21
 22 [<ffffffffc0620260>] __ocfs2_cluster_lock.isra.37+0x2b0/0x9f0 [ocfs2]
 23 [<ffffffffc0621c4d>] ocfs2_inode_lock_full_nested+0x1fd/0xc50 [ocfs2]
 24 [<ffffffffc0638b72>] __ocfs2_recovery_thread+0x6f2/0x14d0 [ocfs2]
 25 [<ffffffff8109def9>] kthread+0xc9/0xe0
 26 [<ffffffff817f6a22>] ret_from_fork+0x42/0x70
 27 [<ffffffffffffffff>] 0xffffffffffffffff
 28
 29 ========== get stack of 36601 ==========
 30 df^@-BM^@-TP^@
 31 [<ffffffffc06367a5>] ocfs2_wait_for_recovery+0x75/0xc0 [ocfs2]
 32 [<ffffffffc0621d68>] ocfs2_inode_lock_full_nested+0x318/0xc50 [ocfs2]
 33 [<ffffffffc066a1e1>] ocfs2_statfs+0x81/0x400 [ocfs2]
 34 [<ffffffff81235969>] statfs_by_dentry+0x99/0x140
 35 [<ffffffff81235a2b>] vfs_statfs+0x1b/0xa0
 36 [<ffffffff81235af5>] user_statfs+0x45/0x80
 37 [<ffffffff81235bab>] SYSC_statfs+0x1b/0x40
 38 [<ffffffff81235cee>] SyS_statfs+0xe/0x10
 39 [<ffffffff817f65f2>] system_call_fastpath+0x16/0x75
 40 [<ffffffffffffffff>] 0xffffffffffffffff


Thanks

Guozhonghua
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
