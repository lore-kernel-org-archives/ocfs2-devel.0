From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Apr 2009 16:57:54 -0700
Subject: [Ocfs2-devel] [PATCH 07/39] ocfs2: Abstract extent
	split	process.
In-Reply-To: <1241045931-24607-7-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-7-git-send-email-tao.ma@oracle.com>
Message-ID: <20090430235754.GM2762@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:19AM +0800, Tao Ma wrote:
>  /*
> - * Mark part or all of the extent record at split_index in the leaf
> - * pointed to by path as written. This removes the unwritten
> - * extent flag.
> - *
> + * Split part or all of the extent record at split_index in the leaf
> + * pointed to by path. Merge with the contiguous extent record if needed.
> +
>   * Care is taken to handle contiguousness so as to not grow the tree.
>   *
>   * meta_ac is not strictly necessary - we only truly need it if growth

	There's a spurious blank line added here.  I think you wanted it
to actually be ' *'.

> +static int ocfs2_change_extent_flag(handle_t *handle,
> +				    struct ocfs2_extent_tree *et,
> +				    u32 cpos, u32 len, u32 phys,
> +				    struct ocfs2_alloc_context *meta_ac,
> +				    struct ocfs2_cached_dealloc_ctxt *dealloc,
> +				    int new_flags, int clear_flags)

	This function wants a comment about what it is for.

> +	rec = &el->l_recs[index];
> +	if ((new_flags && (rec->e_flags & new_flags)) ||
> +	    (clear_flags && !(rec->e_flags & clear_flags))) {
> +		ret = -EIO;
> +		mlog_errno(ret);
> +		goto out;
> +	}

	Do we want to log some details as to where the -EIO came from?
Something like "Owner %llu tried to set flags on an extent that already
had them" and "tried to clear flags on an extent that didn't have them"?

> +	if (new_flags)
> +		split_rec.e_flags |= new_flags;
> +	else
> +		split_rec.e_flags &= ~clear_flags;

	This code here assumes that the caller sets new_flags or
clear_flags but not both.  Do we want that?  Either we allow both, and
we honor both, or we should BUG_ON(new_flags && clear_flags).

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
