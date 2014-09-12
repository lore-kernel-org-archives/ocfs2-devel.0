From: WeiWei Wang <wangww631@huawei.com>
Date: Fri, 12 Sep 2014 09:28:42 +0800
Subject: [Ocfs2-devel] [PATCH 0/7] ocfs2: allocate blocks in direct I/O
	write
In-Reply-To: <20140910124227.fb91ca07159191d5aee73d33@linux-foundation.org>
References: <5410462C.8090707@huawei.com>
	<20140910124227.fb91ca07159191d5aee73d33@linux-foundation.org>
Message-ID: <54124C4A.7000002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/9/11 3:42, Andrew Morton wrote:
> On Wed, 10 Sep 2014 20:38:04 +0800 WeiWei Wang <wangww631@huawei.com> wrote:
> 
>> hi all,
>> In ocfs2 append I/O write and fill holes I/O write situation, blocks have not been allocated yet, so the direct I/O write will fallback to buffer I/O write.
>> Buffer I/O write the data to page cache first, then flush the page cache to disk, this will consume some performance. In this patch, the direct I/O write
>> doesn't not need to fallback to buffer I/O write any more because the allocate blocks are enabled in direct I/O now.
>>
> 
> The entire point of the patchset is to improve performance, but the
> changelog contains no performance measurements!  How do we know it's
> worth considering?  Please include quantitative benchmarking results
> in the changelog.
> 
>

 We test the performance under the virtualized scenarios before,
IO from iometer tool within a virtual machine which running on the
Xen virtualization environment, benchmarking results are measured
by iops, 5 seconds take once iops, in this situation, all IO take
O_DIRECT flag, enable allocate blocks in O_DIRECT write brings up
5% IOPS performance improvement in append sequential write.
  Changelog description of this commit patchset may be not very
accurate, we mainly want to describe that if the O_DIRECT write
block allocation is supported, page cache will not be used any more
in the O_DIRECT write, memory fragmentation will be reduced and page
cache can be managed more effective both. When O_DIRECT flag is set,
we really want to go O_DIRECT write, not buffer I/O. In append
write and fill hole write situations, O_DIRECT write will not fallback
to buffer I/O any more.
  Besides, other modern filesystems like ext4 also support direct io
with block allocation. So I think this feature is valuable.

Thanks,
					     --Wang
