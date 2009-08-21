From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 22 Aug 2009 07:17:55 +0800
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <20090821211259.GD4330@mail.oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-19-git-send-email-tao.ma@oracle.com>
	<20090821211259.GD4330@mail.oracle.com>
Message-ID: <4A8F2B23.9060903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Tue, Aug 18, 2009 at 02:19:20PM +0800, Tao Ma wrote:
>> +	if (ret == -ETXTBSY) {
>> +		BUG_ON(refcounted_cpos == UINT_MAX);
>> +		cow_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
>> +
>> +		ret = ocfs2_refcount_cow(inode, di_bh,
>> +					 refcounted_cpos, cow_len);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
> 
> 	I've just realized two more problems.  Well, one is a bug;
> the other is merely inefficient.
> 	First, the inefficiency.  We've cooked up an
> ocfs2_refcount_cow() that can handle any cpos+write_len.  But we call it
> from ocfs2_write_begin_nolock(), which only goes a page at a time.  So
> even for a 1GB write, we're going to CoW 1MB at a time.  For the first
> page of the I/O, we'll call ocfs2_refcount_cow().  This will try to CoW
> just the page.  We'll pad that out to 1MB in cal_cow_clusters().  For
> the next few pages up to 1MB of I/O it will see the now-CoWed clusters.
> But then it gets to the first page of the second MB.  It will CoW the
> second MB, and so on.  We've just split the 1GB range into 1MB hunks on
> disk.
yes, that is anticipated. We CoW 1MB at most at a time.
> 	Now, we have to check REFCOUNTED in write_begin() (well,
> populate_write_desc()) because that's how we trap mmap().  So we leave
> it here.  But for a regular write, we know the entire length up in
> ocfs2_file_aio_write().  So in ocfs2_prepare_inode_for_write(), right
> before the direct_io checks, why don't we just CoW the entire write
> there?  Create a check_for_refcount just like check_for_holes, except
> instead of filling holes you CoW.  The function can easily skip out if
> there's no refcount tree on the inode.  This gives us large CoW regions.
> We're going to have to do the CoW anyway.  When a regular write gets
> into populate_write_desc(), it won't find any refcounted records, so
> there's no more work at that level.
yes, we can put a check there, but we can't resolve the 1MB issue you 
mentioned above either. Maybe we can make ocfs2_refcount_cow more 
intelligent? But I would say let us leave it as-is and this can be a 
future improvement.
> 	Even better, this fixes the bug.  What's the bug?  The current
> code doesn't CoW O_DIRECT writes!  We only check in prepare_write_desc,
> which we don't use for O_DIRECT!  And ocfs2_direct_IO_get_blocks()
> doesn't trigger buffered fallback either!  Well, we don't want buffered
> fallback.  We want CoW followed by real O_DIRECT.  ANd if we do the CoW
> up in prepare_inode_for_write(), we get it.  Plus, we can put a
> BUG_ON(ext_flags & REFCOUNTED) in direct_IO_get_blocks().
oh, yes, this is really a bug. I don't think of O_DIRECT when I created 
this patch set. So I may really need to add a check in 
ocfs2_prepare_inode_for_write(I guess just need to call 
ocfs2_refcount_cow and make write_len<=1MB).

This also make me think that we can cal ocfs2_refcount_cow right before 
we populate_write_desc, so that we don't need to call it twice and we 
can directly BUG_ON(ext_flags & REFCOUNTED) in it.

Regards,
Tao
