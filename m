From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 19 Aug 2009 16:30:39 -0700
Subject: [Ocfs2-devel] [PATCH 08/41] ocfs2: Basic tree root operation.
In-Reply-To: <1250576382-27080-8-git-send-email-tao.ma@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-8-git-send-email-tao.ma@oracle.com>
Message-ID: <20090819233039.GC29503@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 18, 2009 at 02:19:09PM +0800, Tao Ma wrote:
> +	spin_lock(&osb->osb_lock);
> +	tree = ocfs2_find_refcount_tree(osb, first_blkno);
> +
> +	/*
> +	 * The tree has been deleted and recreated. So remove the old
> +	 * tree in this node.
> +	 */

How about this:
	/*
	 * We've just created a new refcount tree in this block.  If
	 * we found a refcount tree on the ocfs2_super, it must be
	 * one we just deleted.  We free the old tree before
	 * inserting the new tree.
	 */
> +	BUG_ON(tree && tree->rf_generation == new_tree->rf_generation);
> +	if (tree)
> +		ocfs2_erase_refcount_tree_from_list_no_lock(osb, tree);
> +	ocfs2_insert_refcount_tree(osb, new_tree);
> +	spin_unlock(&osb->osb_lock);

-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
