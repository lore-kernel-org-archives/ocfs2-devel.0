From: Eric Biggers <ebiggers@kernel.org>
Date: Tue, 18 Feb 2020 19:55:50 -0800
Subject: [Ocfs2-devel] [PATCH v6 10/19] fs: Convert mpage_readpages to
	mpage_readahead
In-Reply-To: <20200219034741.GK24185@bombadil.infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-18-willy@infradead.org>
	<20200219032826.GB1075@sol.localdomain>
	<20200219034741.GK24185@bombadil.infradead.org>
Message-ID: <20200219035550.GE1075@sol.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Tue, Feb 18, 2020 at 07:47:41PM -0800, Matthew Wilcox wrote:
> On Tue, Feb 18, 2020 at 07:28:26PM -0800, Eric Biggers wrote:
> > On Mon, Feb 17, 2020 at 10:45:58AM -0800, Matthew Wilcox wrote:
> > > diff --git a/include/linux/mpage.h b/include/linux/mpage.h
> > > index 001f1fcf9836..f4f5e90a6844 100644
> > > --- a/include/linux/mpage.h
> > > +++ b/include/linux/mpage.h
> > > @@ -13,9 +13,9 @@
> > >  #ifdef CONFIG_BLOCK
> > >  
> > >  struct writeback_control;
> > > +struct readahead_control;
> > >  
> > > -int mpage_readpages(struct address_space *mapping, struct list_head *pages,
> > > -				unsigned nr_pages, get_block_t get_block);
> > > +void mpage_readahead(struct readahead_control *, get_block_t get_block);
> > >  int mpage_readpage(struct page *page, get_block_t get_block);
> > >  int mpage_writepages(struct address_space *mapping,
> > >  		struct writeback_control *wbc, get_block_t get_block);
> > 
> > Can you name the 'struct readahead_control *' parameter?
> 
> What good would that do?  I'm sick of seeing 'struct page *page'.
> Well, no shit it's a page.  Unless there's some actual information to
> convey, leave the argument unnamed.  It should be a crime to not name
> an unsigned long, but not naming the struct address_space pointer is
> entirely reasonable.

It's the coding style the community has agreed on, so the tools check for.

I don't care that much myself; it just appeared like this was a mistake rather
than intentional so I thought I'd point it out.

- Eric
