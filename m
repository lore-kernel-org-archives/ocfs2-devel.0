From: Gang He <ghe@suse.com>
Date: Wed, 21 Dec 2016 16:21:01 +0800
Subject: [Ocfs2-devel] [PATCH v2 4/4] ocfs2: add duplicative ino number check
In-Reply-To: <1482308461-12964-1-git-send-email-ghe@suse.com>
References: <1482308461-12964-1-git-send-email-ghe@suse.com>
Message-ID: <1482308461-12964-5-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Add duplicative ino number check, to avoid adding a file into the
file check list when this file is being checked.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/filecheck.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index a94c531..f65f2b2 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -354,6 +354,22 @@ static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
 }
 
 static inline int
+ocfs2_filecheck_is_dup_entry(struct ocfs2_filecheck_sysfs_entry *ent,
+				unsigned long ino)
+{
+	struct ocfs2_filecheck_entry *p;
+
+	list_for_each_entry(p, &ent->fs_fcheck->fc_head, fe_list) {
+		if (!p->fe_done) {
+			if (p->fe_ino == ino)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static inline int
 ocfs2_filecheck_erase_entry(struct ocfs2_filecheck_sysfs_entry *ent)
 {
 	struct ocfs2_filecheck_entry *p;
@@ -467,7 +483,10 @@ static ssize_t ocfs2_filecheck_attr_store(struct kobject *kobj,
 	}
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
-	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
+	if (ocfs2_filecheck_is_dup_entry(ent, args.fa_ino)) {
+		ret = -EEXIST;
+		kfree(entry);
+	} else if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
 		(ent->fs_fcheck->fc_done == 0)) {
 		mlog(ML_NOTICE,
 		"Cannot do more file check "
-- 
1.8.5.6
