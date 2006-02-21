From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 21 Feb 2006 11:57:30 -0500
Subject: [Ocfs2-devel] [PATCH 02/14] ocfs2: complete failure recovery for
	nodemanager init
Message-ID: <20060221165730.GA11835@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


 This patch finishes cleaning up the node manager allocations if it fails
 to initialize.

 fs/ocfs2/cluster/nodemanager.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

diff -ruNpX ../dontdiff linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/nodemanager.c linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/nodemanager.c
--- linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/nodemanager.c	2006-02-21 11:41:25.000000000 -0500
+++ linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/nodemanager.c	2006-02-21 11:44:28.000000000 -0500
@@ -861,7 +861,7 @@ static int __init init_o2nm(void)
 	if (!ocfs2_table_header) {
 		printk(KERN_ERR "nodemanager: unable to register sysctl\n");
 		ret = -ENOMEM; /* or something. */
-		goto out;
+		goto out_o2net;
 	}
 
 	ret = o2net_register_hb_callbacks();
@@ -894,6 +894,7 @@ static int __init init_o2nm(void)
 	if (ret == 0)
 		goto out;
 
+	o2net_proc_exit(o2nm_proc);
 out_mlog:
 	mlog_remove_proc(o2nm_proc);
 out_remove:
@@ -904,6 +905,8 @@ out_callbacks:
 	o2net_unregister_hb_callbacks();
 out_sysctl:
 	unregister_sysctl_table(ocfs2_table_header);
+out_o2net:
+	o2net_exit();
 out:
 	return ret;
 }
