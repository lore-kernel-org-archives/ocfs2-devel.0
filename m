From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 22 Jan 2015 13:06:15 +0800
Subject: [Ocfs2-devel] [PATCH 0/9 v6] ocfs2: support append O_DIRECT
	write
In-Reply-To: <54C0745E.3040605@huawei.com>
References: <54BE0B46.8030301@huawei.com> <54BE1139.4090304@oracle.com>
	<54BE1919.1000507@huawei.com> <54C05C2F.5080009@oracle.com>
	<54C0745E.3040605@huawei.com>
Message-ID: <54C08547.7020001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/22/2015 11:54 AM, Joseph Qi wrote:
> On 2015/1/22 10:10, Junxiao Bi wrote:
>> On 01/20/2015 05:00 PM, Joseph Qi wrote:
>>> Hi Junxiao,
>>>
>>> On 2015/1/20 16:26, Junxiao Bi wrote:
>>>> Hi Joseph,
>>>>
>>>> Did this version make any performance improvement with v5? I tested v5,
>>>> and it didn't improve performance with original buffer write + sync.
>>> No performance difference between these two versions.
>>> But we have tested with fio before, it shows about 5% performance
>>> improvement with normal buffer write (without sync).
>>> As I described, this feature is not truly for performance improvement.
>>> We aim to reduce the host page cache consumption. For example, dom0
>>> in virtualization case which won't be configured too much memory.
>> I cared the direct-io performance because recently i got a bug that
>> ocfs2 appending write direct-io performance was two times less than
>> ext4. Since you followed some idea from ext4, do you know why ext4 is
>> faster and any advise to improve ocfs2 performance?
> I have sent an related email "[RFD] ocfs2: poor performance on
> append write/punch hole" before to discuss this topic but unfortunately
> no reply.
> https://oss.oracle.com/pipermail/ocfs2-devel/2014-January/009585.html
> 
> Current ocfs2 append O_DIRECT write will fall back to buffer io and then
> do journal force commit. And my test shows jbd2_journal_force_commit
> consumes about 90% out of the total time.
> 
> After this patch set, io will go directly to disk and no longer need
> page cache and force commit. But block allocation, meta data update,
> as well as other necessary steps are still there.
Yes, i think these journal operations may be the key to the performance,
I traced the direct io for ext4 when I do dd test, I found there was no
journal operation during every write, but after dd done, about 5s, there
were some journal flush to disk, looks like ext4 cached the journal. If
ocfs2 can do this, maybe performance will be good.

Thanks,
Junxiao.
> 
> Yes, I have followed ext4 when implementing this feature. And in my
> opinion, the flow is almost the same with ext4. So I am not sure if
> the difference is caused by disk layout.
> 
> --
> Joseph
>>
>> Thanks,
>> Junxiao.
>>>
>>> --
>>> Joseph
>>>>
>>>> Thanks,
>>>> Junxiao.
>>>>
>>>> On 01/20/2015 04:01 PM, Joseph Qi wrote:
>>>>> Currently in case of append O_DIRECT write (block not allocated yet),
>>>>> ocfs2 will fall back to buffered I/O. This has some disadvantages.
>>>>> Firstly, it is not the behavior as expected.
>>>>> Secondly, it will consume huge page cache, e.g. in mass backup scenario.
>>>>> Thirdly, modern filesystems such as ext4 support this feature.
>>>>>
>>>>> In this patch set, the direct I/O write doesn't fallback to buffer I/O
>>>>> write any more because the allocate blocks are enabled in direct I/O
>>>>> now.
>>>>>
>>>>> changelog:
>>>>> v6 <- v5:
>>>>> -- Take Mark's advice to use prefix "dio-" to distinguish dio orphan
>>>>>    entry from unlink/rename.
>>>>> -- Take Mark's advice to treat this feature as a ro compat feature.
>>>>> -- Fix a bug in case of not cluster aligned io, cluster_align should
>>>>>    be !zero_len, not !!zero_len.
>>>>> -- Fix a bug in case of fallocate with FALLOC_FL_KEEP_SIZE.
>>>>> -- Fix the wrong *ppos and written when completing the rest request
>>>>>    using buffer io.
>>>>>
>>>>> Corresponding ocfs2 tools (mkfs.ocfs2, tunefs.ocfs2, fsck.ocfs2, etc.)
>>>>> will be updated later.
>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>> .
>>
> 
> 
