From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 20 Apr 2020 04:43:00 -0700
Subject: [Ocfs2-devel] [PATCH v11 24/25] fuse: Convert from readpages to
	readahead
In-Reply-To: <CAJfpegsZF=TFQ67vABkE5ghiZoTZF+=_u8tM5U_P6jZeAmv23A@mail.gmail.com>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-25-willy@infradead.org>
	<CAJfpegsZF=TFQ67vABkE5ghiZoTZF+=_u8tM5U_P6jZeAmv23A@mail.gmail.com>
Message-ID: <20200420114300.GB5820@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, William Kucharski <william.kucharski@oracle.com>

On Mon, Apr 20, 2020 at 01:14:17PM +0200, Miklos Szeredi wrote:
> > +       for (;;) {
> > +               struct fuse_io_args *ia;
> > +               struct fuse_args_pages *ap;
> > +
> > +               nr_pages = readahead_count(rac) - nr_pages;
> 
> Hmm.  I see what's going on here, but it's confusing.   Why is
> __readahead_batch() decrementing the readahead count at the start,
> rather than at the end?
> 
> At the very least it needs a comment about why nr_pages is calculated this way.

Because usually that's what we want.  See, for example, fs/mpage.c:

        while ((page = readahead_page(rac))) {
                prefetchw(&page->flags);
                args.page = page;
                args.nr_pages = readahead_count(rac);
                args.bio = do_mpage_readpage(&args);
                put_page(page);
        }

fuse is different because it's trying to allocate for the next batch,
not for the batch we're currently on.

I'm a little annoyed because I posted almost this exact loop here:

https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/CAJfpegtrhGamoSqD-3Svfj3-iTdAbfD8TP44H_o*HE*g*CAnCA at mail.gmail.com/__;Kysr!!GqivPVa7Brio!OQfLYQda7JmGMfk2Ly87W3AdgDBo_Z-MKWOsPzh4QOt89tSC9pm-g14L77q0TmdFaqj-PA$ 

and you said "I think that's fine", modified only by your concern
for it not being obvious that nr_pages couldn't be decremented by
__readahead_batch(), so I modified the loop slightly to assign to
nr_pages.  The part you're now complaining about is unchanged.

> > +               if (nr_pages > max_pages)
> > +                       nr_pages = max_pages;
> > +               if (nr_pages == 0)
> > +                       break;
> > +               ia = fuse_io_alloc(NULL, nr_pages);
> > +               if (!ia)
> > +                       return;
> > +               ap = &ia->ap;
> > +               nr_pages = __readahead_batch(rac, ap->pages, nr_pages);
> > +               for (i = 0; i < nr_pages; i++) {
> > +                       fuse_wait_on_page_writeback(inode,
> > +                                                   readahead_index(rac) + i);
> 
> What's wrong with ap->pages[i]->index?  Are we trying to wean off using ->index?

It saves reading from a cacheline?  I wouldn't be surprised if the
compiler hoisted the read from rac->_index to outside the loop and just
iterated from rac->_index to rac->_index + nr_pages.
