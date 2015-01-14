From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Jan 2015 19:27:08 +0100
Subject: [Ocfs2-devel] [PATCH 1/4] quota: Don't store flags for v2 quota
	format
In-Reply-To: <1421260031-3355-1-git-send-email-jack@suse.cz>
References: <1421260031-3355-1-git-send-email-jack@suse.cz>
Message-ID: <1421260031-3355-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>

Currently, v2 quota format blindly stored flags from in-memory dqinfo on
disk, although there are no flags supported. Since it is stupid to store
flags which have no effect, just store 0 unconditionally and don't
bother loading it from disk.

Note that userspace could have stored some flags there via Q_SETINFO
quotactl and then later read them (although flags have no effect) but
I'm pretty sure noone does that (most definitely quota-tools don't and
quota interface doesn't have too much other users).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota_v2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index 02751ec695c5..b291602e1193 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -126,7 +126,8 @@ static int v2_read_file_info(struct super_block *sb, int type)
 	}
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
-	info->dqi_flags = le32_to_cpu(dinfo.dqi_flags);
+	/* No flags currently supported */
+	info->dqi_flags = le32_to_cpu(0);
 	qinfo->dqi_sb = sb;
 	qinfo->dqi_type = type;
 	qinfo->dqi_blocks = le32_to_cpu(dinfo.dqi_blocks);
@@ -157,7 +158,8 @@ static int v2_write_file_info(struct super_block *sb, int type)
 	info->dqi_flags &= ~DQF_INFO_DIRTY;
 	dinfo.dqi_bgrace = cpu_to_le32(info->dqi_bgrace);
 	dinfo.dqi_igrace = cpu_to_le32(info->dqi_igrace);
-	dinfo.dqi_flags = cpu_to_le32(info->dqi_flags & DQF_MASK);
+	/* No flags currently supported */
+	dinfo.dqi_flags = 0;
 	spin_unlock(&dq_data_lock);
 	dinfo.dqi_blocks = cpu_to_le32(qinfo->dqi_blocks);
 	dinfo.dqi_free_blk = cpu_to_le32(qinfo->dqi_free_blk);
-- 
2.1.2
