From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 20 Mar 2020 11:11:32 -0700
Subject: [Ocfs2-devel] [PATCH v9 12/25] mm: Move end_index check out of
	readahead loop
In-Reply-To: <20200320180017.GE851@sol.localdomain>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-13-willy@infradead.org>
	<20200320165828.GB851@sol.localdomain>
	<20200320173040.GB4971@bombadil.infradead.org>
	<20200320180017.GE851@sol.localdomain>
Message-ID: <20200320181132.GD4971@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 20, 2020 at 11:00:17AM -0700, Eric Biggers wrote:
> On Fri, Mar 20, 2020 at 10:30:40AM -0700, Matthew Wilcox wrote:
> > On Fri, Mar 20, 2020 at 09:58:28AM -0700, Eric Biggers wrote:
> > > On Fri, Mar 20, 2020 at 07:22:18AM -0700, Matthew Wilcox wrote:
> > > > +	/* Avoid wrapping to the beginning of the file */
> > > > +	if (index + nr_to_read < index)
> > > > +		nr_to_read = ULONG_MAX - index + 1;
> > > > +	/* Don't read past the page containing the last byte of the file */
> > > > +	if (index + nr_to_read >= end_index)
> > > > +		nr_to_read = end_index - index + 1;
> > > 
> > > There seem to be a couple off-by-one errors here.  Shouldn't it be:
> > > 
> > > 	/* Avoid wrapping to the beginning of the file */
> > > 	if (index + nr_to_read < index)
> > > 		nr_to_read = ULONG_MAX - index;
> > 
> > I think it's right.  Imagine that index is ULONG_MAX.  We should read one
> > page (the one at ULONG_MAX).  That would be ULONG_MAX - ULONG_MAX + 1.
> > 
> > > 	/* Don't read past the page containing the last byte of the file */
> > > 	if (index + nr_to_read > end_index)
> > > 		nr_to_read = end_index - index + 1;
> > > 
> > > I.e., 'ULONG_MAX - index' rather than 'ULONG_MAX - index + 1', so that
> > > 'index + nr_to_read' is then ULONG_MAX rather than overflowed to 0.
> > > 
> > > Then 'index + nr_to_read > end_index' rather 'index + nr_to_read >= end_index',
> > > since otherwise nr_to_read can be increased by 1 rather than decreased or stay
> > > the same as expected.
> > 
> > Ooh, I missed the overflow case here.  It should be:
> > 
> > +	if (index + nr_to_read - 1 > end_index)
> > +		nr_to_read = end_index - index + 1;
> > 
> 
> But then if someone passes index=0 and nr_to_read=0, this underflows and the
> entire file gets read.

nr_to_read == 0 doesn't make sense ... I thought we filtered that out
earlier, but I can't find anywhere that does that right now.  I'd
rather return early from __do_page_cache_readahead() to fix that.

> The page cache isn't actually supposed to contain a page at index ULONG_MAX,
> since MAX_LFS_FILESIZE is at most ((loff_t)ULONG_MAX << PAGE_SHIFT), right?  So
> I don't think we need to worry about reading the page with index ULONG_MAX.
> I.e. I think it's fine to limit nr_to_read to 'ULONG_MAX - index', if that makes
> it easier to avoid an overflow or underflow in the next check.

I think we can get a page at ULONG_MAX on 32-bit systems?  I mean, we can buy
hard drives which are larger than 16TiB these days:
https://urldefense.com/v3/__https://www.pcmag.com/news/seagate-will-ship-18tb-and-20tb-hard-drives-in-2020__;!!GqivPVa7Brio!MBUH0NJlLDsinBk9D2SBg-cwgN3kjY1Viaawf3u5RNHo4Dp4hD0iIc4niIyDxhhLyIXVkw$ 
(even ignoring RAID devices)
