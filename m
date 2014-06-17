From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 17 Jun 2014 22:34:40 +0800
Subject: [Ocfs2-devel] [PATCH 22/24] ocfs2: return actual error on sysfs
	functions
Message-ID: <53A05200.9070805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if kset_create_and_add() failed

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/cluster/sys.c | 4 ++--
 fs/ocfs2/stackglue.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index b7f5727..6d8c793 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -65,8 +65,8 @@ int o2cb_sys_init(void)
 	int ret;
 
 	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
-	if (!o2cb_kset)
-		return -ENOMEM;
+	if (IS_ERR(o2cb_kset))
+		return PTR_ERR(o2cb_kset);
 
 	ret = sysfs_create_group(&o2cb_kset->kobj, &o2cb_attr_group);
 	if (ret)
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 5d965e8..e6eae89 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -641,8 +641,8 @@ static int ocfs2_sysfs_init(void)
 	int ret;
 
 	ocfs2_kset = kset_create_and_add("ocfs2", NULL, fs_kobj);
-	if (!ocfs2_kset)
-		return -ENOMEM;
+	if (IS_ERR(ocfs2_kset))
+		return PTR_ERR(ocfs2_kset);
 
 	ret = sysfs_create_group(&ocfs2_kset->kobj, &ocfs2_attr_group);
 	if (ret)
-- 
1.8.3.2
