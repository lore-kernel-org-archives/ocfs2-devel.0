From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 10 Feb 2014 15:57:01 -0800
Subject: [Ocfs2-devel] [patch 09/11] ocfs2: llseek requires ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <52F89314.6060103@huawei.com>
References: <20140124204709.85C895A4203@corp2gmr1-2.hot.corp.google.com>
	<20140206234253.GR24361@wotan.suse.de>
	<20140206155029.b7275670913c34ef6bc9a530@linux-foundation.org>
	<20140207224409.GS24361@wotan.suse.de>
	<52F587AB.3010604@huawei.com>
	<20140208020703.GT24361@wotan.suse.de>
	<52F89314.6060103@huawei.com>
Message-ID: <20140210155701.7b1bacb165ca4f89ef46b5ef@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 10 Feb 2014 16:51:32 +0800 Jensen <shencanquan@huawei.com> wrote:

> >>    ocfs2 is a cluster file system.  as like read/write/open/rmdir/unlink interface which think of cluster-aware. I think the seek interface need
> >>    cluster-aware. May be it has the performance impact. but it's correctness is more important than performance.
> > That doesn't mean we can't or shouldn't quantify the performance impact of your patch.
> >
> > Please help us measure what the end-user impact of this change will be.
> > 	--Mark
>   test result: 1000000 times lseek call;
>   index        lseek with inode lock (unit:us)                lseek without inode lock (unit:us)
>     1                   1168162                                    555383
>     2                   1168011                                    549504
>     3                   1170538                                    549396
>     4                   1170375                                    551685
>     5                   1170444                                    556719
>     6                   1174364                                    555307
>     7                   1163294                                    551552
>     8                   1170080                                    549350
>     9                   1162464                                    553700
>   10                   1165441                                    552594
> 
>  avg                  1168317                                    552519
> 
> avg with lock - avg without lock = 615798
> (avg with lock - avg without lock)/1000000=0.615798 us

hm, what does that actually mean.  I guess that to get a feel for the
impact on real workloads, this latency needs to be compared with the
time for a small IO on fast hardware.

One could test that by creating a large file then doing lots of
"lseek(random)+read" operations.  Which requires forgetting about
the existence of pread() ;)
