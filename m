From: Jan Kara <jack@suse.cz>
Date: Wed, 23 Jan 2013 13:56:19 +0100
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fix possible use-after-free with
	AIO
In-Reply-To: <1358945780-23661-1-git-send-email-jack@suse.cz>
References: <1358945780-23661-1-git-send-email-jack@suse.cz>
Message-ID: <1358945780-23661-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: tytso@mit.edu, bpm@sgi.com, jlbec@evilplan.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, stable@vger.kernel.org

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
CC: stable at vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..340bd02 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -593,9 +593,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
 
+	inode_dio_done(inode);
 	if (is_async)
 		aio_complete(iocb, ret, 0);
-	inode_dio_done(inode);
 }
 
 /*
-- 
1.7.1
