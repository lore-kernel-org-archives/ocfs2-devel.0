From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Aug 2008 15:25:04 -0700
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Determine an extent tree's
	max_leaf_clusters in an et_op.
In-Reply-To: <1219286905-28104-8-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-8-git-send-email-joel.becker@oracle.com>
Message-ID: <20080821222504.GR4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 20, 2008 at 07:48:22PM -0700, Joel Becker wrote:
> Provide an optional extent_tree_operation to specify the
> max_leaf_clusters of an ocfs2_extent_tree.  If not provided, the value
> is 0 (unlimited).
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c |   18 +++++++++++++++---
>  1 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 0b900f6..7c0721d 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -76,6 +76,8 @@ struct ocfs2_extent_tree_operations {
>  	/* These are internal to ocfs2_extent_tree and don't have
>  	 * accessor functions */
>  	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);

A comment here, noting that it's optional and what the expected behavior is
if it isn't set would be nice. Otherwise, this patch looks great.
	--Mark

--
Mark Fasheh
