From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Oct 2008 13:18:20 -0700
Subject: [Ocfs2-devel] [PATCH 10/39] ocfs2: Add helper function in
	uptodate.c for removing xattr clusters
In-Reply-To: <20081001231156.c52c98b5.akpm@linux-foundation.org>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-11-git-send-email-mfasheh@suse.com>
	<20081001231156.c52c98b5.akpm@linux-foundation.org>
Message-ID: <20081007201820.GC26373@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tao.ma@oracle.com

On Wed, Oct 01, 2008 at 11:11:56PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:51 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +/* Called when we remove xattr clusters from an inode. */
> > +void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
> > +					    sector_t block,
> > +					    u32 c_len)
> > +{
> > +	u64 i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
> > +
> > +	for (i = 0; i < b_len; i++, block++)
> > +		ocfs2_remove_block_from_cache(inode, block);
> > +}
> 
> I really really hope that `i' and `b_len' didn't really need to be
> 64-bit here.

Yeah, there's no way currently that any of those variables should get even
close to that large. I made them unsigned ints with the patch below.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: use smaller counters in ocfs2_remove_xattr_clusters_from_cache

i and b_len don't really need to be u64's. Xattr extent lengths should be
limited by the VFS, and then the size of our on-disk length field.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/uptodate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 5235140..187b99f 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -562,7 +562,7 @@ void ocfs2_remove_xattr_clusters_from_cache(struct inode *inode,
 					    sector_t block,
 					    u32 c_len)
 {
-	u64 i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
+	unsigned int i, b_len = ocfs2_clusters_to_blocks(inode->i_sb, 1) * c_len;
 
 	for (i = 0; i < b_len; i++, block++)
 		ocfs2_remove_block_from_cache(inode, block);
-- 
1.5.4.1
