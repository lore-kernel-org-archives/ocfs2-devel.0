From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 16 Nov 2010 16:10:47 -0800
Subject: [Ocfs2-devel] [PATCH 36/44] fs/ocfs2: Remove unnecessary
	semicolons
In-Reply-To: <e32409b17aaa1a54fec85f3654583ef08fcf851c.1289789605.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
	<e32409b17aaa1a54fec85f3654583ef08fcf851c.1289789605.git.joe@perches.com>
Message-ID: <20101117001046.GE10237@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 07:04:55PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Joel Becker <joel.becker@oracle.com>


> ---
>  fs/ocfs2/refcounttree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index b5f9160..da14a42 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -3704,7 +3704,7 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
>  	context->cow_start = cow_start;
>  	context->cow_len = cow_len;
>  	context->ref_tree = ref_tree;
> -	context->ref_root_bh = ref_root_bh;;
> +	context->ref_root_bh = ref_root_bh;
>  	context->cow_object = xv;
>  
>  	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
> -- 
> 1.7.3.1.g432b3.dirty
> 

-- 

Life's Little Instruction Book #237

	"Seek out the good in people."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
