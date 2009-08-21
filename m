From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 21 Aug 2009 14:12:59 -0700
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <1250576382-27080-19-git-send-email-tao.ma@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-19-git-send-email-tao.ma@oracle.com>
Message-ID: <20090821211259.GD4330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 18, 2009 at 02:19:20PM +0800, Tao Ma wrote:
> +	if (ret == -ETXTBSY) {
> +		BUG_ON(refcounted_cpos == UINT_MAX);
> +		cow_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
> +
> +		ret = ocfs2_refcount_cow(inode, di_bh,
> +					 refcounted_cpos, cow_len);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}

	I've just realized two more problems.  Well, one is a bug;
the other is merely inefficient.
	First, the inefficiency.  We've cooked up an
ocfs2_refcount_cow() that can handle any cpos+write_len.  But we call it
from ocfs2_write_begin_nolock(), which only goes a page at a time.  So
even for a 1GB write, we're going to CoW 1MB at a time.  For the first
page of the I/O, we'll call ocfs2_refcount_cow().  This will try to CoW
just the page.  We'll pad that out to 1MB in cal_cow_clusters().  For
the next few pages up to 1MB of I/O it will see the now-CoWed clusters.
But then it gets to the first page of the second MB.  It will CoW the
second MB, and so on.  We've just split the 1GB range into 1MB hunks on
disk.
	Now, we have to check REFCOUNTED in write_begin() (well,
populate_write_desc()) because that's how we trap mmap().  So we leave
it here.  But for a regular write, we know the entire length up in
ocfs2_file_aio_write().  So in ocfs2_prepare_inode_for_write(), right
before the direct_io checks, why don't we just CoW the entire write
there?  Create a check_for_refcount just like check_for_holes, except
instead of filling holes you CoW.  The function can easily skip out if
there's no refcount tree on the inode.  This gives us large CoW regions.
We're going to have to do the CoW anyway.  When a regular write gets
into populate_write_desc(), it won't find any refcounted records, so
there's no more work at that level.
	Even better, this fixes the bug.  What's the bug?  The current
code doesn't CoW O_DIRECT writes!  We only check in prepare_write_desc,
which we don't use for O_DIRECT!  And ocfs2_direct_IO_get_blocks()
doesn't trigger buffered fallback either!  Well, we don't want buffered
fallback.  We want CoW followed by real O_DIRECT.  ANd if we do the CoW
up in prepare_inode_for_write(), we get it.  Plus, we can put a
BUG_ON(ext_flags & REFCOUNTED) in direct_IO_get_blocks().

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
