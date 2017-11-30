From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:26 -0800
Subject: [Ocfs2-devel] [patch 06/11] ocfs2: add duplicated ino number check
Message-ID: <5a20851a.VacVlPzjAqqfVK2N%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: add duplicated ino number check

Add duplicated ino number check, to avoid adding a file into the file
check list when this file is being checked.

Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495611866-2D27360-2D5-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=HmSc3pTeEieMijxmVBM1pRMAfCZMIys4MLICBUN7pd8&s=DPCQBlhR-HB4Genx8SyZ9PR7KBqEUUQWyXbqyODG_7I&e=
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-add-duplicative-ino-number-check fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-add-duplicative-ino-number-check
+++ a/fs/ocfs2/filecheck.c
@@ -354,6 +354,22 @@ exit:
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
@@ -467,7 +483,10 @@ static ssize_t ocfs2_filecheck_attr_stor
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
_
