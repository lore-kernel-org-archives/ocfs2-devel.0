From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 26 Feb 2020 09:03:59 -0800
Subject: [Ocfs2-devel] [PATCH v8 14/25] mm: Document why we don't set
	PageReadahead
In-Reply-To: <20200225214838.30017-15-willy@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
	<20200225214838.30017-15-willy@infradead.org>
Message-ID: <20200226170359.GB22837@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 01:48:27PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> If the page is already in cache, we don't set PageReadahead on it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
