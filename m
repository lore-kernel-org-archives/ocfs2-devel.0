From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Jan 2015 19:27:11 +0100
Subject: [Ocfs2-devel] [PATCH 4/4] quota: Verify flags passed to Q_SETINFO
In-Reply-To: <1421260031-3355-1-git-send-email-jack@suse.cz>
References: <1421260031-3355-1-git-send-email-jack@suse.cz>
Message-ID: <1421260031-3355-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>

Currently flags passed via Q_SETINFO were just stored. This makes it
hard to add new flags since in theory userspace could be just setting /
clearing random flags. Since currently there is only one userspace
settable flag and that is somewhat obscure flags only for ancient v1
quota format, I'm reasonably sure noone operates these flags and
hopefully we are fine just adding the check that passed flags are sane.
If we indeed find some userspace program that gets broken by the strict
check, we can always remove it again.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index f8be368b9086..d25c3243c196 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2582,6 +2582,14 @@ int dquot_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
 		goto out;
 	}
 	mi = sb_dqopt(sb)->info + type;
+	if (ii->dqi_valid & IIF_FLAGS) {
+		if (ii->dqi_flags & ~DQF_SETINFO_MASK ||
+		    (ii->dqi_flags & DQF_ROOT_SQUASH &&
+		     mi->dqi_format->qf_fmt_id != QFMT_VFS_OLD)) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
 	spin_lock(&dq_data_lock);
 	if (ii->dqi_valid & IIF_BGRACE)
 		mi->dqi_bgrace = ii->dqi_bgrace;
-- 
2.1.2
