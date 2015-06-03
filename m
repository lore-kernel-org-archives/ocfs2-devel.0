From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 3 Jun 2015 11:52:19 +0800
Subject: [Ocfs2-devel] ocfs2 inconsistent when updating journal
 superblock failed
In-Reply-To: <556E6903.9090800@oracle.com>
References: <556D5FAC.20702@huawei.com> <556E6903.9090800@oracle.com>
Message-ID: <556E79F3.4060109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-ext4@vger.kernel.org

Hi Junxiao,

On 2015/6/3 10:40, Junxiao Bi wrote:
> Hi Joseph,
> 
> On 06/02/2015 03:47 PM, Joseph Qi wrote:
>> Hi all,
>> If jbd2 has failed to update superblock because of iscsi link down, it
>> may cause ocfs2 inconsistent.
>>
>> kernel version: 3.0.93
>> dmesg:
>> JBD2: I/O error detected when updating journal superblock for
>> dm-41-36.
>>
>> Case description:
>> Node 1 was doing the checkpoint of global bitmap.
>> ocfs2_commit_thread
>>   ocfs2_commit_cache
>>     jbd2_journal_flush
>>       jbd2_cleanup_journal_tail
>>         jbd2_journal_update_superblock
>>           sync_dirty_buffer
>>             submit_bh  *failed*
>> Since the error was ignored, jbd2_journal_flush would return 0.
>> Then ocfs2_commit_cache thought it normal, incremented trans id and woke
>> downconvert thread.
>> So node 2 could get the lock because the checkpoint had been done
>> successfully (in fact, bitmap on disk had been updated but journal
>> superblock not). Then node 2 did the update to global bitmap as normal.
>> After a while, node 2 found node 1 down and began the journal recovery.
>> As a result, the new update by node 2 would be overwritten and filesystem
>> became inconsistent.
> If this is the case, this seemed a generic issue. Assume a two node
> cluster, node 1 updated global bitmap, and the transaction for this
> update have been written into node 1's journal. Then node 2 updated
> global bitmap, after that, node 1 crash and node 2 replay node 1's
> journal and will overwrite global bitmap to old one. Do i miss some point?
> 
> Thanks,
> Junxiao.
> 
In normal case, node 2 can update global bitmap only after it has already
got the lock. And this make sure node 1 has already done the checkpoint.
For the case described above, one condition is the two updates should be
on the same gd. And right after journal data has been flushed, updating
journal superblock fails, that means sb_start still points to the old log
block number.
Then the journal replay during recovery will write the old update again.

>>
>> I'm not sure if ext4 has the same case (can it be deployed on LUN?).
>> But for ocfs2, I don't think the error can be omitted.
>> Any ideas about this?
>>
>> Thanks,
>> Joseph
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
> 
> .
> 
