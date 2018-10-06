From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 6 Oct 2018 03:41:34 -0700
Subject: [Ocfs2-devel] [PATCH 08/15] vfs: change clone and dedupe range
 function pointers to return bytes completed
In-Reply-To: <153870033496.29072.3660384210745578982.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
	<153870033496.29072.3660384210745578982.stgit@magnolia>
Message-ID: <20181006104134.GF25747@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Thu, Oct 04, 2018 at 05:45:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the clone_file_range and dedupe_file_range functions to return
> the number of bytes they operated on.  This is the precursor to allowing
> fs implementations to return short clone/dedupe results to the user,
> which will enable us to obey resource limits in a graceful manner.

For clone this doesn't make any sense, as we don't allow 'short clones'.
