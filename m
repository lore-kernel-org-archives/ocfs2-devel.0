From: Gang He <ghe@suse.com>
Date: Wed, 24 May 2017 15:44:24 +0800
Subject: [Ocfs2-devel] [PATCH v3 2/4] ocfs2: fix some small problems
In-Reply-To: <1495611866-27360-1-git-send-email-ghe@suse.com>
References: <1495611866-27360-1-git-send-email-ghe@suse.com>
Message-ID: <1495611866-27360-3-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

First, move setting fe_done = 1 in spin lock, avoid bring
any potential race condition. 
Second, tune mlog message level from ERROR to NOTICE, since 
the message should not belong to error message.
Third, tune errno to -EAGAIN when file check queue is full,
this errno is more appropriate in the case.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/filecheck.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index cc7b595..4347727 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -288,7 +288,7 @@ int ocfs2_filecheck_remove_sysfs(struct super_block *sb)
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if (len < (ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done)) {
-		mlog(ML_ERROR,
+		mlog(ML_NOTICE,
 		"Cannot set online file check maximum entry number "
 		"to %u due to too many pending entries(%u)\n",
 		len, ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done);
@@ -462,8 +462,8 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
 ocfs2_filecheck_done_entry(struct ocfs2_filecheck_sysfs_entry *ent,
 			   struct ocfs2_filecheck_entry *entry)
 {
-	entry->fe_done = 1;
 	spin_lock(&ent->fs_fcheck->fc_lock);
+	entry->fe_done = 1;
 	ent->fs_fcheck->fc_done++;
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 }
@@ -545,11 +545,11 @@ static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
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
-- 
1.8.5.6
