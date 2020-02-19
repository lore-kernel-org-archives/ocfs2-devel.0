From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 18 Feb 2020 21:35:44 -0800
Subject: [Ocfs2-devel] [PATCH v6 17/19] iomap: Restructure
	iomap_readpages_actor
In-Reply-To: <d4803ef9-7a2f-965f-8f0f-c5e15396d892@nvidia.com>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-31-willy@infradead.org>
	<d4803ef9-7a2f-965f-8f0f-c5e15396d892@nvidia.com>
Message-ID: <20200219053544.GN24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 07:17:18PM -0800, John Hubbard wrote:
> > -	for (done = 0; done < length; done += ret) {
> 
> nit: this "for" loop was perfect just the way it was. :) I'd vote here for reverting
> the change to a "while" loop. Because with this change, now the code has to 
> separately initialize "done", separately increment "done", and the beauty of a
> for loop is that the loop init and control is all clearly in one place. For things
> that follow that model (as in this case!), that's a Good Thing.
> 
> And I don't see any technical reason (even in the following patch) that requires 
> this change.

It's doing the increment in the wrong place.  We want the increment done in
the middle of the loop, before we check whether we've got to the end of
the page.  Not at the end of the loop.

> > +	BUG_ON(ctx.cur_page);
> 
> Is a full BUG_ON() definitely called for here? Seems like a WARN might suffice...

Dave made a similar comment; I'll pick this up there.
