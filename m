From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 26 Feb 2020 09:05:07 -0800
Subject: [Ocfs2-devel] [PATCH v8 17/25] btrfs: Convert from readpages to
	readahead
In-Reply-To: <20200225214838.30017-18-willy@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
	<20200225214838.30017-18-willy@infradead.org>
Message-ID: <20200226170507.GC22837@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 01:48:30PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Implement the new readahead method in btrfs.  Add a readahead_page_batch()
> to optimise fetching a batch of pages at once.

readahead_page_batch() isn't added in this patch anymore.

Otherwise this looks good to me, although I don't feel confident
enough to give a Reviewed-by for btrfs code.
