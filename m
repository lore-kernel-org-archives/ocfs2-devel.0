From: Joe Perches <joe@perches.com>
Date: Sun, 28 Jun 2009 16:30:56 -0000
Subject: [Ocfs2-devel] [PATCH 59/62] fs/ocfs2/quota_global.c: Remove
	unnecessary semicolons
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Message-ID: <c2fa65670abb3675e51442c2f046af62c7e6195e.1246173683.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index edfa60c..05ed815 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -143,7 +143,7 @@ static int ocfs2_get_quota_block(struct inode *inode, int block,
 		err = -EIO;
 		mlog_errno(err);
 	}
-	return err;;
+	return err;
 }
 
 /* Read data from global quotafile - avoid pagecache and such because we cannot
-- 
1.6.3.1.10.g659a0.dirty
