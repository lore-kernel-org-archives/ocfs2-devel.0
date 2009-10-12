From: Laszlo Attila Toth <toth.laszlo.attila@balabit.hu>
Date: Mon, 12 Oct 2009 11:16:44 +0200
Subject: [Ocfs2-devel] [PATCH] Set return value to -EINVAL if superblock
	probe failed
Message-ID: <1255339004-20310-1-git-send-email-toth.laszlo.attila@balabit.hu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case of non-modular kernels the root filesystem is mounted by trying
several filesystems. If ocfs2 is tried before the actual filesystem type,
such as squashfs, the mount is failed because ocfs2_fill_super's return
value was -EAGAIN and normally it should return with -EINVAL, which means
the filesystem is non-ocfs2.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 fs/ocfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 476d488..1f506de 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -621,6 +621,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size);
 	if (status < 0) {
+		status = -EINVAL;
 		mlog(ML_ERROR, "superblock probe failed!\n");
 		goto read_super_error;
 	}
-- 
1.6.4.rc2
