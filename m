From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 1 Dec 2015 16:44:54 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG due to uncleaned
 localalloc during mount
In-Reply-To: <565D542F.1020609@oracle.com>
References: <5654684A.1070305@huawei.com>
	<565D542F.1020609@oracle.com>
Message-ID: <20151201164454.624f2294f6142b9b2fe4bd74@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 1 Dec 2015 16:02:55 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> On 11/24/2015 09:38 PM, Joseph Qi wrote:
> > Tariq has reported a BUG before and posted a fix at:
> > https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010696.html
> > 
> > This is because during umount, localalloc shutdown relies on journal
> > shutdown. But during journal shutdown, it just stops commit thread
> > without checking its result. So it may happen that localalloc shutdown
> > uncleaned during I/O error and after that, journal then has been marked
> > clean if I/O restores.
> The above is a storage issue. In this condition, io error can even
> happen to journal commit, some transactions may have wrong data. Let fs
> go without a fsck may cause corruption.
> I am thinking whether we can fail the mount and mark the journal dirty
> again. Then we can do fsck to it withoug a fsck patch.

hm, was that an ack, a nack or a quack?
