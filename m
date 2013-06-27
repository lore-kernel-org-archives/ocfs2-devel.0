From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 27 Jun 2013 16:08:28 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: xattr: fix inlined xattr reflink
In-Reply-To: <1371778044-14415-1-git-send-email-junxiao.bi@oracle.com>
References: <1371778044-14415-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20130627160828.598b9281d81b854a4fae4c20@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 21 Jun 2013 09:27:24 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Inlined xattr shared free space of inode block with inlined data
> or data extent record, so the size of the later two should be
> adjusted when inlined xattr is enabled. See ocfs2_xattr_ibody_init().
> But this isn't done well when reflink. For inode with inlined data,
> its max inlined data size is adjusted in ocfs2_duplicate_inline_data(),
> no problem. But for inode with data extent record, its record count isn't
> adjusted. Fix it, or data extent record and inlined xattr may overwrite
> each other, then cause data corruption or xattr failure.
> 
> One panic caused by this bug in our test environment is the following:
> 
> kernel BUG at fs/ocfs2/xattr.c:1435!
>
> ...
>
> @@ -6499,6 +6499,16 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
>  	}
>  
>  	new_oi = OCFS2_I(args->new_inode);
> +	/*
> +	 * Adjust extent record count to reserve space for extended attribute.
> +	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
> +	 */
> +	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
> +	    !(ocfs2_inode_is_fast_symlink(new_inode))) {
> +		struct ocfs2_extent_list *el = &new_di->id2.i_list;
> +		le16_add_cpu(&el->l_count, -(inline_size /
> +					sizeof(struct ocfs2_extent_rec)));
> +	}

This is badly screwed up.  There is no local variable `new_inode' -
new_inode() is a global function!

I assume you meant args->new_inode, but this patch clearly wasn't
tested (or wasn't what you _did_ test).

I'll drop it.  Please fix, retest, resend.
