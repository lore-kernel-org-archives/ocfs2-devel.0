From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 18 Feb 2020 22:04:15 -0800
Subject: [Ocfs2-devel] [PATCH v6 17/19] iomap: Restructure
	iomap_readpages_actor
In-Reply-To: <20200219032900.GE10776@dread.disaster.area>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-31-willy@infradead.org>
	<20200219032900.GE10776@dread.disaster.area>
Message-ID: <20200219060415.GO24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 02:29:00PM +1100, Dave Chinner wrote:
> On Mon, Feb 17, 2020 at 10:46:11AM -0800, Matthew Wilcox wrote:
> > @@ -418,6 +412,15 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
> >  		}
> >  		ret = iomap_readpage_actor(inode, pos + done, length - done,
> >  				ctx, iomap, srcmap);
> > +		if (WARN_ON(ret == 0))
> > +			break;
> 
> This error case now leaks ctx->cur_page....

Yes ... and I see the consequence.  I mean, this is a "shouldn't happen",
so do we want to put effort into cleanup here ...

> > @@ -451,11 +454,7 @@ iomap_readpages(struct address_space *mapping, struct list_head *pages,
> >  done:
> >  	if (ctx.bio)
> >  		submit_bio(ctx.bio);
> > -	if (ctx.cur_page) {
> > -		if (!ctx.cur_page_in_bio)
> > -			unlock_page(ctx.cur_page);
> > -		put_page(ctx.cur_page);
> > -	}
> > +	BUG_ON(ctx.cur_page);
> 
> And so will now trigger both a warn and a bug....

... or do we just want to run slap bang into this bug?

Option 1: Remove the check for 'ret == 0' altogether, as we had it before.
That puts us into endless loop territory for a failure mode, and it's not
parallel with iomap_readpage().

Option 2: Remove the WARN_ON from the check.  Then we just hit the BUG_ON,
but we don't know why we did it.

Option 3: Set cur_page to NULL.  We'll hit the WARN_ON, avoid the BUG_ON,
might end up with a page in the page cache which is never unlocked.

Option 4: Do the unlock/put page dance before setting the cur_page to NULL.
We might double-unlock the page.

There are probably other options here too.
