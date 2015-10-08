From: Ryan Ding <ryan.ding@oracle.com>
Date: Thu, 08 Oct 2015 11:12:53 +0800
Subject: [Ocfs2-devel] [PATCH 0/8] ocfs2: fix ocfs2 direct io code patch
 to support sparse file and data ordering semantics
In-Reply-To: <5609148B.6040506@huawei.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
	<5609148B.6040506@huawei.com>
Message-ID: <5615DF35.3030802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 09/28/2015 06:20 PM, Joseph Qi wrote:
> Hi Ryan,
> I have gone through this patch set and done a simple performance test
> using direct dd, it indeed brings much performance promotion.
>           Before      After
> bs=4K    1.4 MB/s    5.0 MB/s
> bs=256k  40.5 MB/s   56.3 MB/s
>
> My questions are:
> 1) You solution is still using orphan dir to keep inode and allocation
> consistency, am I right? From our test, it is the most complicated part
> and has many race cases to be taken consideration. So I wonder if this
> can be restructured.
I have not got a better idea to do this. I think the only reason why 
direct io using orphan is to prevent space lost when system crash during 
append direct write. But maybe a 'fsck -f' will do that job. Is it 
necessary to use orphan?
> 2) Rather than using normal block direct io, you introduce a way to use
> write begin/end in buffer io. IMO, if it wants to perform like direct
> io, it should be committed to disk by forcing committing journal. But
> journal committing will consume much time. Why does it bring performance
> promotion instead?
I use buffer io to write only the zero pages. Actual data payload is 
written as direct io. I think there is no need to do a force commit. 
Because direct means "Try to minimize cache effects of the I/O to and 
from this file.", it does not means "write all data & meta data to disk 
before write return".
> 3) Do you have a test in case of lack of memory?
I tested it in a system with 2GB memory. Is that enough?

Thanks,
Ryan
>
> On 2015/9/11 16:19, Ryan Ding wrote:
>> The idea is to use buffer io(more precisely use the interface
>> ocfs2_write_begin_nolock & ocfs2_write_end_nolock) to do the zero work beyond
>> block size. And clear UNWRITTEN flag until direct io data has been written to
>> disk, which can prevent data corruption when system crashed during direct write.
>>
>> And we will also archive a better performance:
>> eg. dd direct write new file with block size 4KB:
>> before this patch:
>> 2.5 MB/s
>> after this patch:
>> 66.4 MB/s
>>
>> ----------------------------------------------------------------
>> Ryan Ding (8):
>>        ocfs2: add ocfs2_write_type_t type to identify the caller of write
>>        ocfs2: use c_new to indicate newly allocated extents
>>        ocfs2: test target page before change it
>>        ocfs2: do not change i_size in write_end for direct io
>>        ocfs2: return the physical address in ocfs2_write_cluster
>>        ocfs2: record UNWRITTEN extents when populate write desc
>>        ocfs2: fix sparse file & data ordering issue in direct io.
>>        ocfs2: code clean up for direct io
>>
>>   fs/ocfs2/aops.c        | 1118 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
>>   fs/ocfs2/aops.h        |   11 +-
>>   fs/ocfs2/file.c        |  138 +---------------------
>>   fs/ocfs2/inode.c       |    3 +
>>   fs/ocfs2/inode.h       |    3 +
>>   fs/ocfs2/mmap.c        |    4 +-
>>   fs/ocfs2/ocfs2_trace.h |   16 +--
>>   fs/ocfs2/super.c       |    1 +
>>   8 files changed, 568 insertions(+), 726 deletions(-)
>>
>> .
>>
>
