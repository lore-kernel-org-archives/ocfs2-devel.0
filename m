From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:03 2008
Subject: [Ocfs2-devel] [PATCH 29/30] configfs: dir.c fix possible recursive
	locking
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-30-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joonwoo Park <joonwpark81@gmail.com>

From: Joonwoo Park <joonwpark81@gmail.com>

configfs_register_subsystem() with default_groups triggers recursive locking.
it seems that mutex_lock_nested is needed.

=============================================
[ INFO: possible recursive locking detected ]
2.6.24-rc6 #141
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca76f>] configfs_attach_group+0x4f/0x190

but task is already holding lock:
 (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca9d5>] configfs_register_subsystem+0x55/0x130

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca9d5>] configfs_register_subsystem+0x55/0x130

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.24-rc6 #141
 [<c40053ba>] show_trace_log_lvl+0x1a/0x30
 [<c4005e82>] show_trace+0x12/0x20
 [<c400687e>] dump_stack+0x6e/0x80
 [<c404ec72>] __lock_acquire+0xe62/0x1120
 [<c404efb2>] lock_acquire+0x82/0xa0
 [<c43fdad8>] mutex_lock_nested+0x98/0x2e0
 [<c40ca76f>] configfs_attach_group+0x4f/0x190
 [<c40caa46>] configfs_register_subsystem+0xc6/0x130
 [<c45c8186>] init_netconsole+0x2b6/0x300
 [<c45a75f2>] kernel_init+0x142/0x320
 [<c4004fb3>] kernel_thread_helper+0x7/0x14
 =======================

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/configfs/dir.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 50ed691..a48dc7d 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -546,7 +546,7 @@ static int populate_groups(struct config_group *group)
 		 * That said, taking our i_mutex is closer to mkdir
 		 * emulation, and shouldn't hurt.
 		 */
-		mutex_lock(&dentry->d_inode->i_mutex);
+		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 
 		for (i = 0; group->default_groups[i]; i++) {
 			new_group = group->default_groups[i];
@@ -1405,7 +1405,8 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 	sd = configfs_sb->s_root->d_fsdata;
 	link_group(to_config_group(sd->s_element), group);
 
-	mutex_lock(&configfs_sb->s_root->d_inode->i_mutex);
+	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
+			I_MUTEX_PARENT);
 
 	name.name = group->cg_item.ci_name;
 	name.len = strlen(name.name);
-- 
1.5.3.6
