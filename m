From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 7 May 2009 18:32:58 -0700
Subject: [Ocfs2-devel] [PATCH 24/39] ocfs2: Add caching info
	for	refcount tree.
In-Reply-To: <1241045931-24607-24-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-24-git-send-email-tao.ma@oracle.com>
Message-ID: <20090508013258.GE31624@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:36AM +0800, Tao Ma wrote:
> +/* Caller must hold refcount tree lock. */
>  int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
>  			    handle_t *handle, u32 cpos, u32 len,
>  			    struct ocfs2_alloc_context *meta_ac,
> @@ -1528,11 +1544,19 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	struct buffer_head *ref_root_bh = NULL;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> +	struct ocfs2_refcount_tree *tree;

	If the caller holds the lock, don't they have the tree
structure?  Can they pass it in?
>  
>  static int ocfs2_replace_cow(struct inode *inode,
>  			     struct buffer_head *di_bh,
>  			     struct buffer_head *ref_root_bh,
> +			     struct ocfs2_caching_info *ref_ci,
>  			     u32 cow_start, u32 cow_len,
>  			     struct page **pages,
>  			     int num_pages)

	It would seem that you could pass the tree in here instead of
just ref_ci.  Then if you need to change what the functions do with the
refcount_tree fields, it's already there.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
