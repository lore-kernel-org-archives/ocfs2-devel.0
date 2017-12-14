From: alex chen <alex.chen@huawei.com>
Date: Thu, 14 Dec 2017 11:01:07 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: check the metadate alloc before
 marking extent written
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F1F5AE86@H3CMLB14-EX.srv.huawei-3com.com>
References: <5A261299.6080403@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F1F5A147@H3CMLB14-EX.srv.huawei-3com.com>
	<5A30D5B0.9050009@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F1F5AE86@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5A31E973.8060708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2017/12/14 8:56, Changwei Ge wrote:
> On 2017/12/13 15:25, alex chen wrote:
>> Hi Changwei,
>>
>> On 2017/12/12 9:05, Changwei Ge wrote:
>>> Hi Alex,
>>>
>>> On 2017/12/5 11:31, alex chen wrote:
>>>> We need to check the free number of the records in each loop to mark
>>>> extent written, because the last extent block may be changed through
>>>> many times marking extent written and the 'num_free_extents' also be
>>>> changed. In the worst case, the 'num_free_extents' may become less
>>>> than the beginning of the loop. So we should not estimate the free
>>>> number of the records at the beginning of the loop to mark extent
>>>> written.
>>>>
>>>> Reported-by: John Lightsey <john@nixnuts.net>
>>>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>>>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>>>> ---
>>>>    fs/ocfs2/aops.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++----------
>>>>    1 file changed, 64 insertions(+), 13 deletions(-)
>>>>
> 
>>>
>>> If there isn't enough extent records here, you break this loop and also
>>> commit transaction.
>>> After re-executing from _restart_all_, a new transaction is started.
>>> So you separate 'before _restart_all_' and 'after _restart_all_' into
>>> different transactions.
>>>
>>>
>>>>
>>>> -	if (end > i_size_read(inode)) {
>>>> +	if (!restart && end > i_size_read(inode)) {
>>>
>>> Here you don't change inode size, however, obviously you already mark
>>> extents as *written*.
>>
>> Here we should not change inode size, otherwise, the user may read some of the data
>> he wrote and the other part of data is zero, which breaks the consistency of WRITE.
>> Here it just mark extents to written and do not allocated data spaces.
> 
> Very true.
> 
>>
>>>
>>>>    		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>>>>    		if (ret < 0)
>>>>    			mlog_errno(ret);
>>>>    	}
>>>> +
>>>>    commit:
>>>>    	ocfs2_commit_trans(osb, handle);
>>>
>>> You commit transaction here and host just crashes at this point.
>>> Then you will have a file with a smaller size than its real size.
>>> Moreover, those space could not be declaimed.
>>
>> The problem you described above is exist. But it is a new problem and is not introduced by this patch.
>> It is introduced in commit c15471f79506(ocfs2: fix sparse file & data ordering issue in direct io).
>> Those space was allocated in ocfs2_dio_wr_get_block()->ocfs2_write_begin_nolock()->
>> ocfs2_write_cluster_by_desc() and it could not be declaimed when any errors happen in
>> ocfs2_dio_end_io_write().
> 
> Hi Alex,
> Actually, 1)the space can be declaimed via ocfs2 journal recovery by other nodes or itself during its
> next mount, since it also resided in orphan directory. 2)If deleting corresponding inode is done, I suppose,
> unwritten cluster might be declaimed by _fsck_ with a *consistent* inode size.(not very sure on this point).
> 
I have a different understanding about this.
I think the space can be declaimed until the inode is deleted from orphan directory, Do you agree?
In ocfs2_dio_end_io_write(), we deleted the inode from orphan directory before calling ocfs2_lock_allocators()
and ocfs2_mark_extent_written. In other words, the space can't be declaimed when any errors happened in the
process of marking extent to written unless the file is deleted or we run fsck.ocfs2.

> The original version of ocfs2_dio_end_io_write() before your patch being applied, it ties _mark_extent_written_
> to _set_inode_size_ in an unique jbd2 transaction. So it can guarantee the consistency between changing them.
> 
Yes.

> As for your patch, you split them into different transactions which breaks the consistency, since your patch
> starts and commit a transaction once _restart_all_ is needed(2 times at least), but only the last jbd2 committed
> transaction includes changing inode size.
I have understood it. This is indeed a point that can be optimized. Do you have any good suggestions?

Thanks,
Alex
> 
> I think your way to fix this issue is acceptable.
> 
> If you have no idea how to improve patch, I will try to compose a patch to do some help based on your patch.
> 
I am honored to be with you to solve this problem.

> Perhaps Andrew can fold them into a single one, it's up to Andrew.
> 
> Thanks,
> Changwei
> 
>> This patch corrects the calculation method of the free number of the records.
>>
>> At present, I have no idea to solve the new problem you described above, I think you can send the patch
>> to solve this problem if you have a good idea.
>>
>> Thanks,
>> Alex
>>
>>>
>>> Should we do more work on JBD2?
>>>
>>> Thanks,
>>> Changwei
>>>
>>>
>>>> +free_ac:
>>>> +	if (meta_ac) {
>>>> +		ocfs2_free_alloc_context(meta_ac);
>>>> +		meta_ac = NULL;
>>>> +	}
>>>> +	if (restart) {
>>>> +		restart = 0;
>>>> +		goto restart_all;
>>>> +	}
>>>>    unlock:
>>>>    	up_write(&oi->ip_alloc_sem);
> 
>>
>>
> 
> 
> .
> 
