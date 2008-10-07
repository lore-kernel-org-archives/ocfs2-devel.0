From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Oct 2008 13:09:19 -0700
Subject: [Ocfs2-devel] [PATCH 01/39] ocfs2: POSIX file locks support
In-Reply-To: <20081001231144.87fa2a0b.akpm@linux-foundation.org>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-2-git-send-email-mfasheh@suse.com>
	<20081001231144.87fa2a0b.akpm@linux-foundation.org>
Message-ID: <20081007200919.GA26373@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:11:44PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:42 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +int ocfs2_stack_supports_plocks(void)
> > +{
> > +	return !!(active_stack && active_stack->sp_ops->plock);
> > +}
> 
> It's pointless doing !! on something which is already 0 or 1.

Sure - the following patch is now on the 'merge_window' branch of ocfs2.git.

Also, thanks for all the review you did on these.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: Remove pointless !!

ocfs2_stack_supports_plocks() doesn't need this to properly return a zero or
one value.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/stackglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 7150f5d..68b668b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -290,7 +290,7 @@ EXPORT_SYMBOL_GPL(ocfs2_dlm_dump_lksb);
 
 int ocfs2_stack_supports_plocks(void)
 {
-	return !!(active_stack && active_stack->sp_ops->plock);
+	return active_stack && active_stack->sp_ops->plock;
 }
 EXPORT_SYMBOL_GPL(ocfs2_stack_supports_plocks);
 
-- 
1.5.4.1
