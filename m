From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Sep 2014 12:42:27 -0700
Subject: [Ocfs2-devel] [PATCH 0/7] ocfs2: allocate blocks in direct I/O
	write
In-Reply-To: <5410462C.8090707@huawei.com>
References: <5410462C.8090707@huawei.com>
Message-ID: <20140910124227.fb91ca07159191d5aee73d33@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 10 Sep 2014 20:38:04 +0800 WeiWei Wang <wangww631@huawei.com> wrote:

> hi all,
> In ocfs2 append I/O write and fill holes I/O write situation, blocks have not been allocated yet, so the direct I/O write will fallback to buffer I/O write.
> Buffer I/O write the data to page cache first, then flush the page cache to disk, this will consume some performance. In this patch, the direct I/O write
> doesn't not need to fallback to buffer I/O write any more because the allocate blocks are enabled in direct I/O now.
> 

The entire point of the patchset is to improve performance, but the
changelog contains no performance measurements!  How do we know it's
worth considering?  Please include quantitative benchmarking results
in the changelog.
