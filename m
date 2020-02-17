From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 17 Feb 2020 10:48:40 -0800
Subject: [Ocfs2-devel] [PATCH v6 00/19] Change readahead API
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
Message-ID: <20200217184840.GL7778@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:45:41AM -0800, Matthew Wilcox wrote:
> This series adds a readahead address_space operation to eventually

*sigh*.  Clearly I forgot to rm -rf an earlier version.  Please disregard
any patches labelled n/16.  I can send a v7 if this is too much hassle.
