From: Jan Kara <jack@suse.cz>
Date: Wed, 15 Jul 2009 17:55:02 +0200
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2: Zero out padding of on disk dquot
	structure
In-Reply-To: <1247673304-31080-1-git-send-email-jack@suse.cz>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
Message-ID: <1247673304-31080-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Padding fields of on-disk dquot structure were not zeroed. Zero them
so that it's easier to use them later.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 5a4ae61..8437c6b 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -69,6 +69,7 @@ static void ocfs2_global_mem2diskdqb(void *dp, struct dquot *dquot)
 	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
 	d->dqb_btime = cpu_to_le64(m->dqb_btime);
 	d->dqb_itime = cpu_to_le64(m->dqb_itime);
+	d->dqb_pad1 = d->dqb_pad2 = 0;
 }
 
 static int ocfs2_global_is_id(void *dp, struct dquot *dquot)
-- 
1.6.0.2
