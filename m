From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 20 Jan 2015 17:00:09 +0800
Subject: [Ocfs2-devel] [PATCH 0/9 v6] ocfs2: support append O_DIRECT
	write
In-Reply-To: <54BE1139.4090304@oracle.com>
References: <54BE0B46.8030301@huawei.com> <54BE1139.4090304@oracle.com>
Message-ID: <54BE1919.1000507@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2015/1/20 16:26, Junxiao Bi wrote:
> Hi Joseph,
> 
> Did this version make any performance improvement with v5? I tested v5,
> and it didn't improve performance with original buffer write + sync.
No performance difference between these two versions.
But we have tested with fio before, it shows about 5% performance
improvement with normal buffer write (without sync).
As I described, this feature is not truly for performance improvement.
We aim to reduce the host page cache consumption. For example, dom0
in virtualization case which won't be configured too much memory.

--
Joseph
> 
> Thanks,
> Junxiao.
> 
> On 01/20/2015 04:01 PM, Joseph Qi wrote:
>> Currently in case of append O_DIRECT write (block not allocated yet),
>> ocfs2 will fall back to buffered I/O. This has some disadvantages.
>> Firstly, it is not the behavior as expected.
>> Secondly, it will consume huge page cache, e.g. in mass backup scenario.
>> Thirdly, modern filesystems such as ext4 support this feature.
>>
>> In this patch set, the direct I/O write doesn't fallback to buffer I/O
>> write any more because the allocate blocks are enabled in direct I/O
>> now.
>>
>> changelog:
>> v6 <- v5:
>> -- Take Mark's advice to use prefix "dio-" to distinguish dio orphan
>>    entry from unlink/rename.
>> -- Take Mark's advice to treat this feature as a ro compat feature.
>> -- Fix a bug in case of not cluster aligned io, cluster_align should
>>    be !zero_len, not !!zero_len.
>> -- Fix a bug in case of fallocate with FALLOC_FL_KEEP_SIZE.
>> -- Fix the wrong *ppos and written when completing the rest request
>>    using buffer io.
>>
>> Corresponding ocfs2 tools (mkfs.ocfs2, tunefs.ocfs2, fsck.ocfs2, etc.)
>> will be updated later.
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
> 
> 
