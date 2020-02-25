From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 24 Feb 2020 17:49:49 -0800
Subject: [Ocfs2-devel] [PATCH v7 21/24] iomap: Restructure
	iomap_readpages_actor
In-Reply-To: <20200224221749.GA22231@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-22-willy@infradead.org>
	<20200220154741.GB19577@infradead.org>
	<20200220162404.GY24185@bombadil.infradead.org>
	<20200224221749.GA22231@infradead.org>
Message-ID: <20200225014949.GS24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:17:49PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 08:24:04AM -0800, Matthew Wilcox wrote:
> > On Thu, Feb 20, 2020 at 07:47:41AM -0800, Christoph Hellwig wrote:
> > > On Wed, Feb 19, 2020 at 01:01:00PM -0800, Matthew Wilcox wrote:
> > > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > > 
> > > > By putting the 'have we reached the end of the page' condition at the end
> > > > of the loop instead of the beginning, we can remove the 'submit the last
> > > > page' code from iomap_readpages().  Also check that iomap_readpage_actor()
> > > > didn't return 0, which would lead to an endless loop.
> > > 
> > > I'm obviously biassed a I wrote the original code, but I find the new
> > > very much harder to understand (not that the previous one was easy, this
> > > is tricky code..).
> > 
> > Agreed, I found the original code hard to understand.  I think this is
> > easier because now cur_page doesn't leak outside this loop, so it has
> > an obvious lifecycle.
> 
> I really don't like this patch, and would prefer if the series goes
> ahead without it, as the current sctructure works just fine even
> with the readahead changes.

Dave Chinner specifically asked me to do it this way, so please fight
amongst yourselves.
