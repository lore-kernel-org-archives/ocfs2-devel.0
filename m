From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 20 Feb 2020 07:47:41 -0800
Subject: [Ocfs2-devel] [PATCH v7 21/24] iomap: Restructure
	iomap_readpages_actor
In-Reply-To: <20200219210103.32400-22-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-22-willy@infradead.org>
Message-ID: <20200220154741.GB19577@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 01:01:00PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> By putting the 'have we reached the end of the page' condition at the end
> of the loop instead of the beginning, we can remove the 'submit the last
> page' code from iomap_readpages().  Also check that iomap_readpage_actor()
> didn't return 0, which would lead to an endless loop.

I'm obviously biassed a I wrote the original code, but I find the new
very much harder to understand (not that the previous one was easy, this
is tricky code..).
