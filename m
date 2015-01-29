From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Thu, 29 Jan 2015 19:49:14 +0900
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: remove unreachable code
Message-ID: <20150129104914.GA6074@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 319e786..940be6d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3513,7 +3513,6 @@ next:
 		de = (struct ocfs2_dir_entry *)((char *) de + le16_to_cpu(de->rec_len));
 	}
 
-	status = 0;
 bail:
 	brelse(bh);
 	if (status)
-- 
1.7.1
