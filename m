From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:19 -0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix some small problems
Message-ID: <5a208513.8njuaY4REXAzQP67%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: fix some small problems

First, move setting fe_done = 1 in spin lock, avoid bring any potential
race condition.

Second, tune mlog message level from ERROR to NOTICE, since the message
should not belong to error message.

Third, tune errno to -EAGAIN when file check queue is full, this errno is
more appropriate in the case.

Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495611866-2D27360-2D3-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=zh1tc_1nJZLf1L5H5Nqm2mYjnVConRs4lOZiBh_zqUk&s=W9B1HJQabABx9E4Om_5oOMmahfkHE4LoFH0kiBmy0X0&e=
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-fix-some-small-problems fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-fix-some-small-problems
+++ a/fs/ocfs2/filecheck.c
@@ -282,7 +282,7 @@ ocfs2_filecheck_adjust_max(struct ocfs2_
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if (len < (ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done)) {
-		mlog(ML_ERROR,
+		mlog(ML_NOTICE,
 		"Cannot set online file check maximum entry number "
 		"to %u due to too many pending entries(%u)\n",
 		len, ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done);
@@ -456,8 +456,8 @@ static void
 ocfs2_filecheck_done_entry(struct ocfs2_filecheck_sysfs_entry *ent,
 			   struct ocfs2_filecheck_entry *entry)
 {
-	entry->fe_done = 1;
 	spin_lock(&ent->fs_fcheck->fc_lock);
+	entry->fe_done = 1;
 	ent->fs_fcheck->fc_done++;
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 }
@@ -539,11 +539,11 @@ static ssize_t ocfs2_filecheck_store(str
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
 	    (ent->fs_fcheck->fc_done == 0)) {
-		mlog(ML_ERROR,
+		mlog(ML_NOTICE,
 		"Cannot do more file check "
 		"since file check queue(%u) is full now\n",
 		ent->fs_fcheck->fc_max);
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		kfree(entry);
 	} else {
 		if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
_
