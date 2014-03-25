From: Sasha Levin <sasha.levin@oracle.com>
Date: Tue, 25 Mar 2014 13:21:58 -0400
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if cluster name exists before
	deref
Message-ID: <1395768118-21368-1-git-send-email-sasha.levin@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit c74a3bdd9b "ocfs2: add clustername to cluster connection"
is trying to strlcpy a string which was explicitly passed as NULL
in the very same patch, triggering a NULL ptr deref.

[  640.225193] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  640.230224] IP: strlcpy (lib/string.c:388 lib/string.c:151)
[  640.230224] PGD 82a93a067 PUD 82a93b067 PMD 0 
[  640.230224] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  640.230224] Dumping ftrace buffer:
[  640.230224]    (ftrace buffer empty)
[  640.230224] Modules linked in:
[  640.230224] CPU: 19 PID: 19426 Comm: trinity-c19 Tainted: G        W     3.14.0-rc7-next-20140325-sasha-00014-g9476368-dirty #274
[  640.230224] task: ffff88082bc53000 ti: ffff88082b674000 task.ti: ffff88082b674000
[  640.230224] RIP:  strlcpy (lib/string.c:388 lib/string.c:151)
[  640.230224] RSP: 0018:ffff88082b675d88  EFLAGS: 00010296
[  640.230224] RAX: 0000000000000007 RBX: ffffffff8853b260 RCX: 000000006f6d7366
[  640.230224] RDX: 0000000000000011 RSI: 0000000000000000 RDI: ffff88052bcd3518  
[  640.230224] RBP: ffff88082b675da8 R08: 00000000746e756f R09: 0000000000000000  
[  640.230224] R10: ffff88052bcd34d0 R11: 0000000000000000 R12: ffff88052bcd3518  
[  640.230224] R13: ffff88052c003fb8 R14: ffff88052bcd34d0 R15: 00000000ffffffea
[  640.230224] FS:  00007f04ae7a6700(0000) GS:ffff88052cc00000(0000) knlGS:0000000000000000
[  640.230224] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  640.230224] CR2: 0000000000000000 CR3: 000000082115b000 CR4: 00000000000006a0
[  640.230224] DR0: 0000000000698000 DR1: 0000000000698000 DR2: 0000000000000000
[  640.230224] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000602
[  640.230224] Stack:
[  640.230224]  ffffffff86b3c260 ffffffff8853b260 ffffffff86b3c260 ffff88052c003fb8
[  640.230224]  ffff88082b675df8 ffffffff818a3a5d 0000000000000000 0000000700000000
[  640.230224]  0000000000000282 ffff88052c003f48 ffff88003e6b01a0 ffff88052c0f81a0
[  640.230224] Call Trace:
[  640.230224]  ocfs2_cluster_connect (fs/ocfs2/stackglue.c:350)
[  640.230224]  ocfs2_cluster_connect_agnostic (fs/ocfs2/stackglue.c:396)
[  640.230224]  ? ocfs2_control_open (fs/ocfs2/dlmfs/userdlm.c:660)
[  640.230224]  user_dlm_register (fs/ocfs2/dlmfs/userdlm.c:679)
[  640.230224]  ? dlmfs_get_inode (fs/ocfs2/dlmfs/dlmfs.c:468)
[  640.230224]  dlmfs_mkdir (fs/ocfs2/dlmfs/dlmfs.c:503)
[  640.230224]  ? security_inode_permission (security/security.c:555)
[  640.230224]  ? __inode_permission (fs/namei.c:414)
[  640.230224]  vfs_mkdir (fs/namei.c:3467)
[  640.230224]  SyS_mkdirat (fs/namei.c:3488 fs/namei.c:3472)
[  640.230224]  tracesys (arch/x86/kernel/entry_64.S:749)  
[  640.230224] Code: 41 c6 44 1d 00 00 48 83 c4 08 5b 4c 89 e0 41 5c 41 5d 5d c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 55 41 54 49 89 fc 53 48 83 ec 08 <80> 3e 00 74 1c 48 89 f0 0f 1f 84 00 00 00 00 00 48 83 c0 01 80 
[  640.230224] RIP  strlcpy (lib/string.c:388 lib/string.c:151)
[  640.230224]  RSP <ffff88082b675d88>
[  640.230224] CR2: 0000000000000000

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

As a side note, how the hell was this new code path tested?
It's obviously broken and there's no way it even passes
a very basic test.

 fs/ocfs2/stackglue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 5e4d314..83f1a66 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -346,7 +346,9 @@ int ocfs2_cluster_connect(const char *stack_name,
 
 	strlcpy(new_conn->cc_name, group, GROUP_NAME_MAX + 1);
 	new_conn->cc_namelen = grouplen;
-	strlcpy(new_conn->cc_cluster_name, cluster_name, CLUSTER_NAME_MAX + 1);
+	if (cluster_name_len)
+		strlcpy(new_conn->cc_cluster_name, cluster_name,
+			CLUSTER_NAME_MAX + 1);
 	new_conn->cc_cluster_name_len = cluster_name_len;
 	new_conn->cc_recovery_handler = recovery_handler;
 	new_conn->cc_recovery_data = recovery_data;
-- 
1.7.10.4
