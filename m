From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jan 23 17:21:04 2008
Subject: [Ocfs2-devel] Re: [PATCH 08/30] ocfs2: Readpages support
In-Reply-To: <20080123140541.473cf034.akpm@linux-foundation.org>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-9-git-send-email-mark.fasheh@oracle.com>
	<20080123140541.473cf034.akpm@linux-foundation.org>
Message-ID: <20080124012046.GO23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jan 23, 2008 at 02:05:41PM -0800, Andrew Morton wrote:
> > On Thu, 17 Jan 2008 14:35:34 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> > Add ->readpages support to Ocfs2. This is rather trivial - all it required
> > is a small update to ocfs2_get_block (for mapping full extents via b_size)
> > and an ocfs2_readpages() function which partially mirrors ocfs2_readpage().
> > 
> 
> Was there any performance improvement?

To be honest, most of my testing was aimed at validating the correctness of
this patch. I think there's a pretty good case to be made for having an
ocfs2_readpages() method though.

We get to avoid expensive cluster locking during readahead, which would
normally make us bounce data around the cluster.

Also, we save some cpu by avoiding the entire operation for in-inode data.


> > + * siutations are safe to ignore.
> 
> Cnat tpye.

Ok, point takne  ;)

I fixed this and the other typo you pointed out.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com

From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: fix minor typos

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c           |    2 +-
 fs/ocfs2/buffer_head_io.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 865684f..bc7b4cb 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -332,7 +332,7 @@ out:
 
 /*
  * This is used only for read-ahead. Failures or difficult to handle
- * siutations are safe to ignore.
+ * situations are safe to ignore.
  *
  * Right now, we don't bother with BH_Boundary - in-inode extent lists
  * are quite large (243 extents on 4k blocks), so most inodes don't
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 6eaa67f..ab3a41c 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -301,7 +301,7 @@ static inline void ocfs2_check_super_or_backup(struct super_block *sb,
 }
 
 /*
- * Write super block and bakcups doesn't need to collaborate with journal,
+ * Write super block and backups doesn't need to collaborate with journal,
  * so we don't need to lock ip_io_mutex and inode doesn't need to bea passed
  * into this function.
  */
-- 
1.5.3.6
