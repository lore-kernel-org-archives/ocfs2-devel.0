From: Jan Kara <jack@suse.cz>
Date: Fri, 16 Jan 2015 13:47:43 +0100
Subject: [Ocfs2-devel] [PATCH 09/17] quota: Make Q_XQUOTASYNC support VFS
	quota syncing
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
Message-ID: <1421412471-4747-10-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

Call ->quota_sync method from Q_XQUOTASYNC for better userspace
compatibility.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2cc50b35a3b5..5ec04321aace 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -477,8 +477,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	case Q_XQUOTASYNC:
 		if (sb->s_flags & MS_RDONLY)
 			return -EROFS;
-		/* XFS quotas are fully coherent now, making this call a noop */
-		return 0;
+		if (!sb->s_qcop->quota_sync)
+			return 0;
+		return sb->s_qcop->quota_sync(sb, type);
 	default:
 		return -EINVAL;
 	}
-- 
2.1.2
