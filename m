From: Gang He <ghe@suse.com>
Date: Fri, 25 Dec 2015 15:16:16 +0800
Subject: [Ocfs2-devel] [PATCH v3 1/4] ocfs2: export ocfs2_kset for online
	file check
In-Reply-To: <1451027779-6849-1-git-send-email-ghe@suse.com>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
Message-ID: <1451027779-6849-2-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, rgoldwyn@suse.de, ghe@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Export ocfs2_kset object from ocfs2_stackglue kernel module,
then online file check code will create the related sysfiles
under ocfs2_kset object.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/stackglue.c | 3 ++-
 fs/ocfs2/stackglue.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 5d965e8..13219ed 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -629,7 +629,8 @@ static struct attribute_group ocfs2_attr_group = {
 	.attrs = ocfs2_attrs,
 };
 
-static struct kset *ocfs2_kset;
+struct kset *ocfs2_kset;
+EXPORT_SYMBOL_GPL(ocfs2_kset);
 
 static void ocfs2_sysfs_exit(void)
 {
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 66334a3..f2dce10 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -298,4 +298,6 @@ void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_p
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
+extern struct kset *ocfs2_kset;
+
 #endif  /* STACKGLUE_H */
-- 
2.1.2
