From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 6 Oct 2018 03:39:45 -0700
Subject: [Ocfs2-devel] [PATCH 07/15] vfs: skip zero-length dedupe
	requests
In-Reply-To: <153870032167.29072.11158511021942868400.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870032167.29072.11158511021942868400.stgit@magnolia>
Message-ID: <20181006103945.GE25747@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Thu, Oct 04, 2018 at 05:45:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't bother calling the filesystem for a zero-length dedupe request;
> we can return zero and exit.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
