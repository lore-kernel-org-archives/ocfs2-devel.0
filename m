From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Oct 2008 13:10:53 -0700
Subject: [Ocfs2-devel] [PATCH 04/39] ocfs2: track local alloc state via
	debugfs
In-Reply-To: <20081001231153.2d19bb68.akpm@linux-foundation.org>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-5-git-send-email-mfasheh@suse.com>
	<20081001231153.2d19bb68.akpm@linux-foundation.org>
Message-ID: <20081007201053.GB26373@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:11:53PM -0700, Andrew Morton wrote:
> > +static ssize_t ocfs2_la_debug_read(struct file *file, char __user *userbuf,
> > +				   size_t count, loff_t *ppos)
> > +{
> > +	struct ocfs2_super *osb = file->private_data;
> > +	int written, ret;
> > +	char *buf = osb->local_alloc_debug_buf;
> > +
> > +	mutex_lock(&la_debug_mutex);
> > +	memset(buf, 0, LA_DEBUG_BUF_SZ);
> > +
> > +	written = snprintf(buf, LA_DEBUG_BUF_SZ,
> > +			   "0x%x\t0x%llx\t%u\t%u\t0x%x\n",
> > +			   LA_DEBUG_VER,
> > +			   (unsigned long long)osb->la_last_gd,
> > +			   osb->local_alloc_default_bits,
> > +			   osb->local_alloc_bits, osb->local_alloc_state);
> > +
> > +	ret = simple_read_from_buffer(userbuf, count, ppos, buf, written);
> > +
> > +	mutex_unlock(&la_debug_mutex);
> > +	return ret;
> > +}
> 
> In fact it can be made static and local to this function.

Thanks, fixed in 'merge_window' branch of ocfs2.git.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: make la_debug_mutex static

It can also be moved into ocfs2_la_debug_read().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 02227c3..b1c634d 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -76,8 +76,6 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 
 #ifdef CONFIG_OCFS2_FS_STATS
 
-DEFINE_MUTEX(la_debug_mutex);
-
 static int ocfs2_la_debug_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -89,6 +87,7 @@ static int ocfs2_la_debug_open(struct inode *inode, struct file *file)
 static ssize_t ocfs2_la_debug_read(struct file *file, char __user *userbuf,
 				   size_t count, loff_t *ppos)
 {
+	static DEFINE_MUTEX(la_debug_mutex);
 	struct ocfs2_super *osb = file->private_data;
 	int written, ret;
 	char *buf = osb->local_alloc_debug_buf;
-- 
1.5.4.1
