From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 25 Nov 2016 00:10:58 -0800
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: don't eat io errors during
	_dio_end_io_write
In-Reply-To: <147987579593.2678.14305853637089494031.stgit@birch.djwong.org>
References: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
	<147987579593.2678.14305853637089494031.stgit@birch.djwong.org>
Message-ID: <20161125081058.GA22465@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, darwin.xupt@gmail.com, zren@suse.com, ocfs2-devel@oss.oracle.com

On Tue, Nov 22, 2016 at 08:36:35PM -0800, Darrick J. Wong wrote:
> ocfs2_dio_end_io_write eats whatever errors may happen,
> which means that write errors do not propagate to userspace.
> Fix that.

Btw, can you also fix up the ocfs2 calling conventions for ->end_io
so that it also does the unlock for the error case in ocfs2_dio_end_io?

I looked at all the inode locking in ocfs2, but couldn't convince me
that either the current code nor the version with the locking changed
is correct..
