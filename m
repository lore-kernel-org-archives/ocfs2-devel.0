From: Jan Kara <jack@suse.cz>
Date: Tue, 29 Jan 2013 23:28:20 -0000
Subject: [Ocfs2-devel] [PATCH 4/4] fs: Fix possible use-after-free with AIO
In-Reply-To: <1359502081-20240-1-git-send-email-jack@suse.cz>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
Message-ID: <1359502081-20240-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>
CC: stable at vger.kernel.org
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index cf5b44b..f853263 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -261,9 +261,9 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->private, ret, is_async);
 	} else {
+		inode_dio_done(dio->inode);
 		if (is_async)
 			aio_complete(dio->iocb, ret, 0);
-		inode_dio_done(dio->inode);
 	}
 
 	return ret;
-- 
1.7.1
