From: Gang He <ghe@suse.com>
Date: Tue, 31 May 2016 20:05:06 -0600
Subject: [Ocfs2-devel] [PATCH 5/5] Fix files when an inode is written in
 file_fix
In-Reply-To: <574D863F.6000104@suse.com>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
	<1464232219-12553-6-git-send-email-rgoldwyn@suse.de>
	<574C7C2A020000F900039287@suse.com> <574D863F.6000104@suse.com>
Message-ID: <574EB352020000F900029215@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Goldwyn,


>>> 

> 
> On 05/30/2016 04:45 AM, Gang He wrote:
>> Hello Goldwyn,
>>
>> Please see my comments inline.
>>
>>
>> Thanks
>> Gang
>>
>>
>>>>>
>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>
>>> Check that the entriy exists and has been filed for check.
>>> Also perform some code cleanup
>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> ---
>>>   fs/ocfs2/filecheck.c | 41 +++++++++++++++++++++++++----------------
>>>   fs/ocfs2/filecheck.h |  1 +
>>>   fs/ocfs2/sysfs.c     |  2 +-
>>>   3 files changed, 27 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
>>> index 006d521..fc6e183 100644
>>> --- a/fs/ocfs2/filecheck.c
>>> +++ b/fs/ocfs2/filecheck.c
>>> @@ -198,22 +198,6 @@ ocfs2_filecheck_handle(struct ocfs2_super *osb,
>>>   	return ret;
>>>   }
>>>
>>> -static void
>>> -ocfs2_filecheck_handle_entry(struct ocfs2_super *osb,
>>> -			     struct ocfs2_filecheck_entry *entry)
>>> -{
>>> -	if (entry->fe_type == OCFS2_FILECHECK_TYPE_CHK)
>>> -		entry->fe_status = ocfs2_filecheck_handle(osb,
>>> -				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
>>> -	else if (entry->fe_type == OCFS2_FILECHECK_TYPE_FIX)
>>> -		entry->fe_status = ocfs2_filecheck_handle(osb,
>>> -				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
>>> -	else
>>> -		entry->fe_status = OCFS2_FILECHECK_ERR_UNSUPPORTED;
>>> -
>>> -	ocfs2_filecheck_done_entry(osb, entry);
>>> -}
>>> -
>>>   int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
>>>   				     unsigned long ino)
>>>   {
>>> @@ -268,3 +252,28 @@ unlock:
>>>   	ocfs2_filecheck_done_entry(osb, entry);
>>>   	return 0;
>>>   }
>>> +
>>> +int ocfs2_filefix_add_inode(struct ocfs2_super *osb,
>>> +				     unsigned long ino)
>>> +{
>>> +	struct ocfs2_filecheck_entry *entry;
>>> +	int ret = -ENOENT;
>>> +
>>> +	spin_lock(&osb->fc_lock);
>>> +	list_for_each_entry(entry, &osb->file_check_entries, fe_list)
>>> +		if (entry->fe_ino == ino) {
>>> +			entry->fe_type = OCFS2_FILECHECK_TYPE_FIX;
>> Gang: It looks that we can not do it directly, why? because the entry 
> pointer can be freed by the function ocfs2_filecheck_erase_entries().
>> We can not use the same entry pointer within two user processes.
>> The simple solution is to return -EBUSY error in case there is the same ino 
> number entry in the list, then the user can try again after the previous user 
> process is returned.
> 
> How? is it not protected under spinlock?
Gang: please aware that this spinlock fc_lock is used to protect entry list (adding entry/deleting entry), not protect entry itself.
The first user process will mark the entry's status to done after the file check operation is finished, then the function ocfs2_filecheck_erase_entries() will possibly delete this entry from the list, to free the entry memory during the second user process is referencing on this entry.
You know, the spinlock can not protect the file check operation (too long time IO operation).

> Anyways, I plan to make a separate list for this so we can do away with 
> more macros.
Gang: you can use two lists, but I think that one list is also OK, keep the thing simple.
Just return a -EBUSY error when the same inode is on the progress, then the user can try again after that file check process returns.
 
> 
> Besides, any I/O and check operation should be done in a separate 
> thread/work queue.
Gang: current design is no a separated thread is used to run file check operation, each user trigger process is used to execute its file check operation. 
Why? first, keep the thing simple, avoid to involve more logic/thread. second, if we involved a thread/work queue to run the file check operations, 
that means the user trigger process will return directly and need not to wait for the actual file check operation, there will be a risk that the user can
not see the result from the result history record (via cat check/fix), since the new submits result will make the oldest result records to be released, 
we have a fixed length list to keep these status records. If we use the user trigger process to do the file check operation, the user can surely see the result after this user process returns (since this file check operation is done in the kernel space).    


> 
>>
>>> +			ret = 0;
>>> +			break;
>>> +		}
>>> +	spin_unlock(&osb->fc_lock);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	entry->fe_status = ocfs2_filecheck_handle(osb,
>>> +			entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
>>> +
>>> +	ocfs2_filecheck_done_entry(osb, entry);
>>> +	return 0;
>>> +}
>>> +
>>> diff --git a/fs/ocfs2/filecheck.h b/fs/ocfs2/filecheck.h
>>> index b1a0d8c..d5f81a7 100644
>>> --- a/fs/ocfs2/filecheck.h
>>> +++ b/fs/ocfs2/filecheck.h
>>> @@ -53,6 +53,7 @@ int ocfs2_filecheck_create_sysfs(struct super_block *sb);
>>>   int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
>>>   int ocfs2_filefix_inode(struct ocfs2_super *osb, unsigned long ino);
>>>   int ocfs2_filecheck_add_inode(struct ocfs2_super *osb, unsigned long ino);
>>> +int ocfs2_filefix_add_inode(struct ocfs2_super *osb, unsigned long ino);
>>>   int ocfs2_filecheck_set_max_entries(struct ocfs2_super *osb, int num);
>>>   int ocfs2_filecheck_show(struct ocfs2_super *osb, unsigned int type, char
>>> *buf);
>>>
>>> diff --git a/fs/ocfs2/sysfs.c b/fs/ocfs2/sysfs.c
>>> index acc4834..ac149fb 100644
>>> --- a/fs/ocfs2/sysfs.c
>>> +++ b/fs/ocfs2/sysfs.c
>>> @@ -91,7 +91,7 @@ static ssize_t file_fix_store(struct ocfs2_super *osb,
>>>   	ret = kstrtoul(skip_spaces(buf), 0, &t);
>>>   	if (ret)
>>>   		return ret;
>>> -	ret = ocfs2_filecheck_add_inode(osb, t);
>>> +	ret = ocfs2_filefix_add_inode(osb, t);
>>>   	if (ret)
>>>   		return ret;
>>>   	return count;
>>> --
>>> 2.6.6
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com 
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
> 
> -- 
> Goldwyn
