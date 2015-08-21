From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:41:45 -0700
Subject: [Ocfs2-devel] [patch 20/24] ocfs2: export ocfs2_kset for online
	file check
Message-ID: <55d79b19.YVS/9UnFzJng0jev%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: export ocfs2_kset for online file check

When there are errors in the ocfs2 filesystem, they are usually
accompanied by the inode number which caused the error.  This inode number
would be the input to fixing the file.  One of these options could be
considered: A file in the sys filesytem which would accept inode numbers. 
This could be used to communication back what has to be fixed or is fixed.

You could write:

	$# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
or

	$# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck



This patch (of 5):

Export ocfs2_kset object from ocfs2_stackglue kernel module, then online
file check code will create the related sysfiles under ocfs2_kset object.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    3 ++-
 fs/ocfs2/stackglue.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-export-ocfs2_kset-for-online-file-check fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-export-ocfs2_kset-for-online-file-check
+++ a/fs/ocfs2/stackglue.c
@@ -629,7 +629,8 @@ static struct attribute_group ocfs2_attr
 	.attrs = ocfs2_attrs,
 };
 
-static struct kset *ocfs2_kset;
+struct kset *ocfs2_kset;
+EXPORT_SYMBOL_GPL(ocfs2_kset);
 
 static void ocfs2_sysfs_exit(void)
 {
diff -puN fs/ocfs2/stackglue.h~ocfs2-export-ocfs2_kset-for-online-file-check fs/ocfs2/stackglue.h
--- a/fs/ocfs2/stackglue.h~ocfs2-export-ocfs2_kset-for-online-file-check
+++ a/fs/ocfs2/stackglue.h
@@ -298,4 +298,6 @@ void ocfs2_stack_glue_set_max_proto_vers
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
+extern struct kset *ocfs2_kset;
+
 #endif  /* STACKGLUE_H */
_
