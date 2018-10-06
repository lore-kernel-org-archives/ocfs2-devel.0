From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 6 Oct 2018 03:30:30 -0700
Subject: [Ocfs2-devel] [PATCH 02/15] xfs: refactor clonerange
 preparation into a separate helper
In-Reply-To: <20181005052809.GB12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870028762.29072.5369530877410002226.stgit@magnolia>
	<20181005052809.GB12041@dastard>
Message-ID: <20181006103030.GA25747@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Fri, Oct 05, 2018 at 03:28:09PM +1000, Dave Chinner wrote:
> I've added:
> 
> --
> This rework also moves the invalidation of the destination range to
> the prep function so that it is done before the range is remapped.
> This ensures that nobody can access the data in range being remapped
> until the remap is complete.
> --
> 
> Sound OK?
> 
> Otherwise this looks fine.

Given that the patch will need a respin anyway I'd rather split the
move of the pagecache invalidation into a separate patch.
