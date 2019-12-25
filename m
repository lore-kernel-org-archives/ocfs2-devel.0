From: Gang He <GHe@suse.com>
Date: Wed, 25 Dec 2019 06:15:24 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix the crash due to call
 ocfs2_get_dlm_debug once less
Message-ID: <20191225061501.13587-1-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>
Cc: Gang He <GHe@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

Because ocfs2_get_dlm_debug() function is called once less here,
ocfs2 file system will trigger the system crash, usually after
ocfs2 file system is unmounted.
this system crash is caused by a generic memory corruption, these
crash backtraces are not always the same, for exapmle,

[ 4106.597432] ocfs2: Unmounting device (253,16) on (node 172167785)
[ 4116.230719] general protection fault: 0000 [#1] SMP PTI
[ 4116.230731] CPU: 3 PID: 14107 Comm: fence_legacy Kdump:
[ 4116.230737] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
[ 4116.230772] RIP: 0010:__kmalloc+0xa5/0x2a0
[ 4116.230778] Code: 00 00 4d 8b 07 65 4d 8b
[ 4116.230785] RSP: 0018:ffffaa1fc094bbe8 EFLAGS: 00010286
[ 4116.230790] RAX: 0000000000000000 RBX: d310a8800d7a3faf RCX: 0000000000000000
[ 4116.230794] RDX: 0000000000000000 RSI: 0000000000000dc0 RDI: ffff96e68fc036c0
[ 4116.230798] RBP: d310a8800d7a3faf R08: ffff96e6ffdb10a0 R09: 00000000752e7079
[ 4116.230802] R10: 000000000001c513 R11: 0000000004091041 R12: 0000000000000dc0
[ 4116.230806] R13: 0000000000000039 R14: ffff96e68fc036c0 R15: ffff96e68fc036c0
[ 4116.230811] FS:  00007f699dfba540(0000) GS:ffff96e6ffd80000(0000) knlGS:00000
[ 4116.230815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4116.230819] CR2: 000055f3a9d9b768 CR3: 000000002cd1c000 CR4: 00000000000006e0
[ 4116.230833] Call Trace:
[ 4116.230898]  ? ext4_htree_store_dirent+0x35/0x100 [ext4]
[ 4116.230924]  ext4_htree_store_dirent+0x35/0x100 [ext4]
[ 4116.230957]  htree_dirblock_to_tree+0xea/0x290 [ext4]
[ 4116.230989]  ext4_htree_fill_tree+0x1c1/0x2d0 [ext4]
[ 4116.231027]  ext4_readdir+0x67c/0x9d0 [ext4]
[ 4116.231040]  iterate_dir+0x8d/0x1a0
[ 4116.231056]  __x64_sys_getdents+0xab/0x130
[ 4116.231063]  ? iterate_dir+0x1a0/0x1a0
[ 4116.231076]  ? do_syscall_64+0x60/0x1f0
[ 4116.231080]  ? __ia32_sys_getdents+0x130/0x130
[ 4116.231086]  do_syscall_64+0x60/0x1f0
[ 4116.231151]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4116.231168] RIP: 0033:0x7f699d33a9fb

This regression problem was introduced by commit e581595ea29c ("ocfs:
no need to check return value of debugfs_create functions").

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/dlmglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1c4c51f3df60..cda1027d0819 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3282,6 +3282,7 @@ static void ocfs2_dlm_init_debug(struct ocfs2_super *osb)
 
 	debugfs_create_u32("locking_filter", 0600, osb->osb_debug_root,
 			   &dlm_debug->d_filter_secs);
+	ocfs2_get_dlm_debug(dlm_debug);
 }
 
 static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
-- 
2.12.3
