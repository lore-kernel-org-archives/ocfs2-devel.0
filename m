From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 6 Oct 2018 03:34:23 -0700
Subject: [Ocfs2-devel] [PATCH 03/15] xfs: zero posteof blocks when
	cloning above eof
In-Reply-To: <153870029414.29072.6572683664719818617.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870029414.29072.6572683664719818617.stgit@magnolia>
Message-ID: <20181006103423.GB25747@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:44:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set.

But I think we should still drop speculative delalloc preallocations 
instead of zeroing them in addition to zeroing of any real blocks in
the data fork.
