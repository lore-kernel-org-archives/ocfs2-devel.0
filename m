From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 20 Feb 2020 07:10:48 -0800
Subject: [Ocfs2-devel] [PATCH v7 10/24] mm: Add readahead address space
	operation
In-Reply-To: <5D7CE6BD-FABD-4901-AEF0-E0F10FC00EB1@nvidia.com>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-11-willy@infradead.org>
	<5D7CE6BD-FABD-4901-AEF0-E0F10FC00EB1@nvidia.com>
Message-ID: <20200220151048.GW24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 10:00:30AM -0500, Zi Yan wrote:
> > +/* The index of the first page in this readahead block */
> > +static inline unsigned int readahead_index(struct readahead_control *rac)
> > +{
> > +	return rac->_index;
> > +}
> 
> rac->_index is pgoff_t, so readahead_index() should return the same type, right?
> BTW, pgoff_t is unsigned long.

Oh my goodness!  Thank you for spotting that.  Fortunately, it's only
currently used by tracepoints, so it wasn't causing any trouble, but
that's a nasty landmine to leave lying around.  Fixed:

static inline pgoff_t readahead_index(struct readahead_control *rac)
