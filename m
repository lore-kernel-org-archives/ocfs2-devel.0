From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jan 29 12:05:07 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070129200459.GD8176@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Linus,
	I made a silly error in my last upstream push. This patch makes
ocfs2 build again.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Mark Fasheh:
      ocfs2: fix thinko in ocfs2_backup_super_blkno()

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c99e905..e61e218 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -587,7 +587,7 @@ static inline u64 ocfs2_backup_super_blk
 
 	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
 		offset <<= (2 * index);
-		offset /= sb->s_blocksize;
+		offset >>= sb->s_blocksize_bits;
 		return offset;
 	}
 
