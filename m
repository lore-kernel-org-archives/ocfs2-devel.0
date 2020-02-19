From: Dave Chinner <david@fromorbit.com>
Date: Wed, 19 Feb 2020 14:16:26 +1100
Subject: [Ocfs2-devel] [PATCH v6 14/19] ext4: Convert from readpages to
	readahead
In-Reply-To: <20200217184613.19668-25-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-25-willy@infradead.org>
Message-ID: <20200219031626.GC10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:46:05AM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in ext4
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

There's nothing I can see in this that would cause that list
corruption I saw with ext4.

I'll re-introduce the patch and see if it falls over again.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
