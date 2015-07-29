From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Jul 2015 17:40:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix shift left overflow
In-Reply-To: <55B81EC3.9060603@huawei.com>
References: <55B5A7E4.6050600@huawei.com>
	<20150728135137.707a604dfd5221c952e300e8@linux-foundation.org>
	<55B81EC3.9060603@huawei.com>
Message-ID: <20150728174011.72a7380f.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 29 Jul 2015 08:30:59 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> On 2015/7/29 4:51, Andrew Morton wrote:
> > On Mon, 27 Jul 2015 11:39:16 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> > 
> >> cluster pos is defined as u32, when calculate corresponding sector it
> >> should be converted to u64 first, otherwise it may overflow.
> > 
> > What are the runtime effects of this change?
> > 
> The issue is when using large volume, for example, 9T volume with 2T already
> used, frequently create small files with O_DIRECT and the IO is not cluster
> aligned, it may clear sectors in the wrong place.

You mean it corrupts the filesystem?

So this wants to be merged asap and backported as far as possible?
