From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sun, 19 Jun 2016 17:27:15 -0700
Subject: [Ocfs2-devel] [PATCH v2 16/24] fs: ocfs2: Replace CURRENT_TIME with
	ktime_get_real_seconds()
In-Reply-To: <1466382443-11063-1-git-send-email-deepa.kernel@gmail.com>
References: <1466382443-11063-1-git-send-email-deepa.kernel@gmail.com>
Message-ID: <1466382443-11063-17-git-send-email-deepa.kernel@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, y2038@lists.linaro.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

CURRENT_TIME is not y2038 safe.

Use y2038 safe ktime_get_real_seconds() here for timestamps.

struct heartbeat_block's hb_seq and deletetion time are already
64 bits wide and accommodate times beyond y2038.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/heartbeat.c | 2 +-
 fs/ocfs2/inode.c             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 636abcb..9158c98 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -741,7 +741,7 @@ static inline void o2hb_prepare_block(struct o2hb_region *reg,
 	hb_block = (struct o2hb_disk_heartbeat_block *)slot->ds_raw_block;
 	memset(hb_block, 0, reg->hr_block_bytes);
 	/* TODO: time stuff */
-	cputime = CURRENT_TIME.tv_sec;
+	cputime = ktime_get_real_seconds();
 	if (!cputime)
 		cputime = 1;
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c56a767..382401d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -703,7 +703,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 		goto bail_commit;
 	}
 
-	di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
+	di->i_dtime = cpu_to_le64(ktime_get_real_seconds());
 	di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));
 	ocfs2_journal_dirty(handle, di_bh);
 
-- 
1.9.1
