From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 22 Dec 2015 16:08:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix flock panic issue
Message-ID: <1450771707-11568-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 4f6563677ae8 ("Move locks API users to locks_lock_inode_wait()")
move flock/posix lock indentify code to locks_lock_inode_wait(), but
missed to set fl_flags to FL_FLOCK which caused the following kernel
panic on 4.4.0_rc5.

[19343.650448] kernel BUG at fs/locks.c:1895!
[19343.650448] invalid opcode: 0000 [#1] SMP
[19343.650448] Modules linked in: ocfs2(O) ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O) ocfs2_nodemanager(O) ocfs2_stackglue(O) iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi xen_kbdfront xen_netfront xen_fbfront xen_blkfront
[19343.650448] CPU: 0 PID: 20268 Comm: flock_unit_test Tainted: G           O    4.4.0-rc5-next-20151217 #1
[19343.650448] Hardware name: Xen HVM domU, BIOS 4.3.1OVM 05/14/2014
[19343.650448] task: ffff88007b3672c0 ti: ffff880028b58000 task.ti: ffff880028b58000
[19343.650448] RIP: 0010:[<ffffffff811def7e>]  [<ffffffff811def7e>] locks_lock_inode_wait+0x2e/0x160
[19343.650448] RSP: 0018:ffff880028b5bce8  EFLAGS: 00010293
[19343.650448] RAX: 0000000000000000 RBX: ffff880028b5bdb8 RCX: 0000000000000000
[19343.650448] RDX: 0000000000000007 RSI: ffff880028b5bdb8 RDI: ffff88006842bb08
[19343.650448] RBP: ffff880028b5bd98 R08: ffff88007d21b930 R09: ffff880076a005b0
[19343.650448] R10: ffff88007a0e9360 R11: ffff880028b5be78 R12: ffff880040b45408
[19343.650448] R13: ffff880079cbf000 R14: ffff88006842bb08 R15: 0000000000000001
[19343.650448] FS:  00007f17572c7700(0000) GS:ffff88007d200000(0000) knlGS:0000000000000000
[19343.650448] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19343.650448] CR2: 00007f17572d7000 CR3: 000000007b2cf000 CR4: 00000000000406f0
[19343.650448] Stack:
[19343.650448]  ffff880028a70a38 ffffffff0000005a ffff880028a70800 000000000000005a
[19343.650448]  ffff880028b5bda8 0000000100000001 000000000000005a ffff880028a70a30
[19343.650448]  0000000000000292 0000000000000001 0000000000000001 0000000000000292
[19343.650448] Call Trace:
[19343.650448]  [<ffffffff810a15ee>] ? __wake_up+0x4e/0x70
[19343.650448]  [<ffffffff810a1180>] ? bit_waitqueue+0x90/0x90
[19343.650448]  [<ffffffffa010ee01>] ocfs2_do_flock+0x91/0x160 [ocfs2]
[19343.650448]  [<ffffffffa010ef46>] ocfs2_flock+0x76/0xd0 [ocfs2]
[19343.650448]  [<ffffffff811df1bf>] SyS_flock+0x10f/0x1a0
[19343.650448]  [<ffffffff8191b6ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[19343.650448] Code: e5 41 57 41 56 49 89 fe 41 55 41 54 53 48 89 f3 48 81 ec 88 00 00 00 8b 46 40 83 e0 03 83 f8 01 0f 84 ad 00 00 00 83 f8 02 74 04 <0f> 0b eb fe 4c 8d ad 60 ff ff ff 4c 8d 7b 58 e8 0e 8e 73 00 4d
[19343.650448] RIP  [<ffffffff811def7e>] locks_lock_inode_wait+0x2e/0x160
[19343.650448]  RSP <ffff880028b5bce8>
[19343.819187] ---[ end trace dfca74ec9b5b274c ]---

Fixes: 4f6563677ae8 ("Move locks API users to locks_lock_inode_wait()")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/locks.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
index 652ece4a9d9e..d56f0079b858 100644
--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -67,7 +67,10 @@ static int ocfs2_do_flock(struct file *file, struct inode *inode,
 		 */
 
 		locks_lock_file_wait(file,
-				     &(struct file_lock){.fl_type = F_UNLCK});
+				&(struct file_lock) {
+					.fl_type = F_UNLCK,
+					.fl_flags = FL_FLOCK
+				});
 
 		ocfs2_file_unlock(file);
 	}
-- 
1.7.9.5
