From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 21 Feb 2020 17:09:55 -0800
Subject: [Ocfs2-devel] [PATCH v7 22/24] iomap: Convert from readpages to
	readahead
In-Reply-To: <20200222010353.GI9506@magnolia>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-23-willy@infradead.org>
	<20200222010353.GI9506@magnolia>
Message-ID: <20200222010955.GG24185@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 05:03:53PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 19, 2020 at 01:01:01PM -0800, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > Use the new readahead operation in iomap.  Convert XFS and ZoneFS to
> > use it.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Ok... so from what I saw in the mm patches, this series changes
> readahead to shove the locked pages into the page cache before calling
> the filesystem's ->readahead function.  Therefore, this (and the
> previous patch) are more or less just getting rid of all the iomap
> machinery to put pages in the cache and instead pulling them out of the
> mapping prior to submitting a read bio?

Correct.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!
