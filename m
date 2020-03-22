From: Matthew Wilcox <willy@infradead.org>
Date: Sun, 22 Mar 2020 09:28:18 -0700
Subject: [Ocfs2-devel] [PATCH v9 12/25] mm: Move end_index check out of
	readahead loop
In-Reply-To: <20200320182452.GF851@sol.localdomain>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-13-willy@infradead.org>
	<20200320165828.GB851@sol.localdomain>
	<20200320173040.GB4971@bombadil.infradead.org>
	<20200320180017.GE851@sol.localdomain>
	<20200320181132.GD4971@bombadil.infradead.org>
	<20200320182452.GF851@sol.localdomain>
Message-ID: <20200322162818.GG4971@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 20, 2020 at 11:24:52AM -0700, Eric Biggers wrote:
> On Fri, Mar 20, 2020 at 11:11:32AM -0700, Matthew Wilcox wrote:
> > On Fri, Mar 20, 2020 at 11:00:17AM -0700, Eric Biggers wrote:
> > > But then if someone passes index=0 and nr_to_read=0, this underflows and the
> > > entire file gets read.
> > 
> > nr_to_read == 0 doesn't make sense ... I thought we filtered that out
> > earlier, but I can't find anywhere that does that right now.  I'd
> > rather return early from __do_page_cache_readahead() to fix that.
> > 
> > > The page cache isn't actually supposed to contain a page at index ULONG_MAX,
> > > since MAX_LFS_FILESIZE is at most ((loff_t)ULONG_MAX << PAGE_SHIFT), right?  So
> > > I don't think we need to worry about reading the page with index ULONG_MAX.
> > > I.e. I think it's fine to limit nr_to_read to 'ULONG_MAX - index', if that makes
> > > it easier to avoid an overflow or underflow in the next check.
> > 
> > I think we can get a page at ULONG_MAX on 32-bit systems?  I mean, we can buy
> > hard drives which are larger than 16TiB these days:
> > https://urldefense.com/v3/__https://www.pcmag.com/news/seagate-will-ship-18tb-and-20tb-hard-drives-in-2020__;!!GqivPVa7Brio!L7xlt0Bc3UJj9WvjwV_1kM-VNfEivMFdxE2oXx4JHuyRXABzcNgypM3QMttNumL5O0HQwA$ 
> > (even ignoring RAID devices)
> 
> The max file size is ((loff_t)ULONG_MAX << PAGE_SHIFT) which means the maximum
> page *index* is ULONG_MAX - 1, not ULONG_MAX.

I see where we set that for _files_ ... I can't find anywhere that we prevent
i_size getting that big for block devices.  Maybe I'm missing something.

> Anyway, I think we may be making this much too complicated.  How about just:
> 
> 	pgoff_t i_nrpages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> 
> 	if (index >= i_nrpages)
> 		return;
> 	/* Don't read past the end of the file */
> 	nr_to_read = min(nr_to_read, i_nrpages - index);
> 
> That's 2 branches instead of 4.  (Note that assigning to i_nrpages can't
> overflow, since the max number of pages is ULONG_MAX not ULONG_MAX + 1.)

I like where you're going with this.  Just to be on the safe side, I'd
prefer to do this:

@@ -266,11 +266,8 @@ void __do_page_cache_readahead(struct address_space *mapping,
        end_index = (isize - 1) >> PAGE_SHIFT;
        if (index > end_index)
                return;
-       /* Avoid wrapping to the beginning of the file */
-       if (index + nr_to_read < index)
-               nr_to_read = ULONG_MAX - index + 1;
        /* Don't read past the page containing the last byte of the file */
-       if (index + nr_to_read >= end_index)
+       if (nr_to_read > end_index - index)
                nr_to_read = end_index - index + 1;
 
        page_cache_readahead_unbounded(mapping, file, index, nr_to_read,

end_index - index + 1 could only overflow if end_index is ULONG_MAX
and index is 0.  But if end_index is ULONG_MAX and index is 0, then
nr_to_read is necessarily <= ULONG_MAX, so the condition is false.
And if nr_to_read is 0, then the condition is also false, so it won't
increase nr_to_read from 0 to 1.  It might assign x to nr_to_read when
nr_to_read is already x, but that's harmless.

Thanks!
