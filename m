From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue,  5 Nov 2013 09:58:23 +0800
Subject: [Ocfs2-devel] [PATCH] configfs: fix race between dentry put and
	lookup
Message-ID: <1383616704-26083-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: stable@vger.kernel.org

A race window in configfs, it starts from one dentry is UNHASHED
and end before configfs_d_iput is called. In this window, if a lookup
happen, since the original dentry was UNHASHED, so a new dentry will be
allocated, and then in configfs_attach_attr(), sd->s_dentry will be updated
to the new dentry. Then in configfs_d_iput(), BUG_ON(sd->s_dentry != dentry)
will be triggered and system panic.

sys_open:                                             sys_close:
 ...                                                   fput
                                                        dput
                                                         dentry_kill
                                                          __d_drop <--- dentry unhashed here,
                                                                   but sd->dentry still point
                                                                   to this dentry.
 lookup_real
  configfs_lookup
   configfs_attach_attr---> update sd->s_dentry
                            to new allocated dentry here.
                                                          d_kill
                                                           configfs_d_iput <--- BUG_ON(sd->s_dentry != dentry)
                                                                           triggered here.

For fix it, change configfs_d_iput to not update sd->s_dentry if sd->s_count > 2,
that means there are another dentry is using the sd beside the one that is going to
be put. Use configfs_dirent_lock in configfs_attach_attr to sync with configfs_d_iput.

With the following steps, you can reproduce the bug.
1. enable ocfs2, this will mount configfs at /sys/kernel/config and fill configure in it.
2. run the following script.
	while [ 1 ]; do cat /sys/kernel/config/cluster/$your_cluster_name/idle_timeout_ms > /dev/null; done &
	while [ 1 ]; do cat /sys/kernel/config/cluster/$your_cluster_name/idle_timeout_ms > /dev/null; done &

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: stable at vger.kernel.org
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/configfs/dir.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 277bd1b..7f1a704 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -56,10 +56,19 @@ static void configfs_d_iput(struct dentry * dentry,
 	struct configfs_dirent *sd = dentry->d_fsdata;
 
 	if (sd) {
-		BUG_ON(sd->s_dentry != dentry);
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		sd->s_dentry = NULL;
+		/* Coordinate with configfs_attach_attr where will increase
+		 * sd->s_count and update sd->s_dentry to new allocated one.
+		 * Only set sd->dentry to null when this dentry is the only
+		 * sd owner.
+		 * If not do so, configfs_d_iput may run just after
+		 * configfs_attach_attr and set sd->s_dentry to null
+		 * even it's still in use.
+		 */
+		if (atomic_read(&sd->s_count) <= 2)
+			sd->s_dentry = NULL;
+
 		spin_unlock(&configfs_dirent_lock);
 		configfs_put(sd);
 	}
@@ -426,8 +435,11 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 	struct configfs_attribute * attr = sd->s_element;
 	int error;
 
+	spin_lock(&configfs_dirent_lock);
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
+	spin_unlock(&configfs_dirent_lock);
+
 	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
 				configfs_init_file);
 	if (error) {
-- 
1.7.9.5
