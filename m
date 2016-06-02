From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 1 Jun 2016 22:48:07 -0500
Subject: [Ocfs2-devel] [PATCH 5/5] Fix files when an inode is written in
 file_fix
In-Reply-To: <57501329020000F900039C1B@prv-mh.provo.novell.com>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
	<1464232219-12553-6-git-send-email-rgoldwyn@suse.de>
	<574C7C2A020000F900039287@suse.com> <574D863F.6000104@suse.com>
	<574EB352020000F900029215@prv-mh.provo.novell.com>
	<574F9959.3060004@suse.de>
	<57501329020000F900039C1B@prv-mh.provo.novell.com>
Message-ID: <574FAC77.1080503@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 06/01/2016 10:06 PM, Gang He wrote:
>
>
>
>>>>
>
>>
>> On 05/31/2016 09:05 PM, Gang He wrote:
>>> Hello Goldwyn,
>>>
>>>
>>>>>>
>>>
>>>>
>>>> On 05/30/2016 04:45 AM, Gang He wrote:
>>>>> Hello Goldwyn,
>>>>>
>>>>> Please see my comments inline.
>>>>>
>>>>>
>>>>> Thanks
>>>>> Gang
>>>>>
>>>>>
>>>>>>>>
>>>>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>>>>
>>>>>> Check that the entriy exists and has been filed for check.
>>>>>> Also perform some code cleanup
>>>>>>
>>>>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>>>> ---
>>>>>>     fs/ocfs2/filecheck.c | 41 +++++++++++++++++++++++++----------------
>>>>>>     fs/ocfs2/filecheck.h |  1 +
>>>>>>     fs/ocfs2/sysfs.c     |  2 +-
>>>>>>     3 files changed, 27 insertions(+), 17 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
>>>>>> index 006d521..fc6e183 100644
>>>>>> --- a/fs/ocfs2/filecheck.c
>>>>>> +++ b/fs/ocfs2/filecheck.c
>>>>>> @@ -198,22 +198,6 @@ ocfs2_filecheck_handle(struct ocfs2_super *osb,
>>>>>>     	return ret;
>>>>>>     }
>>>>>>
>>>>>> -static void
>>>>>> -ocfs2_filecheck_handle_entry(struct ocfs2_super *osb,
>>>>>> -			     struct ocfs2_filecheck_entry *entry)
>>>>>> -{
>>>>>> -	if (entry->fe_type == OCFS2_FILECHECK_TYPE_CHK)
>>>>>> -		entry->fe_status = ocfs2_filecheck_handle(osb,
>>>>>> -				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
>>>>>> -	else if (entry->fe_type == OCFS2_FILECHECK_TYPE_FIX)
>>>>>> -		entry->fe_status = ocfs2_filecheck_handle(osb,
>>>>>> -				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
>>>>>> -	else
>>>>>> -		entry->fe_status = OCFS2_FILECHECK_ERR_UNSUPPORTED;
>>>>>> -
>>>>>> -	ocfs2_filecheck_done_entry(osb, entry);
>>>>>> -}
>>>>>> -
>>>>>>     int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
>>>>>>     				     unsigned long ino)
>>>>>>     {
>>>>>> @@ -268,3 +252,28 @@ unlock:
>>>>>>     	ocfs2_filecheck_done_entry(osb, entry);
>>>>>>     	return 0;
>>>>>>     }
>>>>>> +
>>>>>> +int ocfs2_filefix_add_inode(struct ocfs2_super *osb,
>>>>>> +				     unsigned long ino)
>>>>>> +{
>>>>>> +	struct ocfs2_filecheck_entry *entry;
>>>>>> +	int ret = -ENOENT;
>>>>>> +
>>>>>> +	spin_lock(&osb->fc_lock);
>>>>>> +	list_for_each_entry(entry, &osb->file_check_entries, fe_list)
>>>>>> +		if (entry->fe_ino == ino) {
>>>>>> +			entry->fe_type = OCFS2_FILECHECK_TYPE_FIX;
>>>>> Gang: It looks that we can not do it directly, why? because the entry
>>>> pointer can be freed by the function ocfs2_filecheck_erase_entries().
>>>>> We can not use the same entry pointer within two user processes.
>>>>> The simple solution is to return -EBUSY error in case there is the same ino
>>>> number entry in the list, then the user can try again after the previous
>> user
>>>> process is returned.
>>>>
>>>> How? is it not protected under spinlock?
>>> Gang: please aware that this spinlock fc_lock is used to protect entry list
>> (adding entry/deleting entry), not protect entry itself.
>>> The first user process will mark the entry's status to done after the file
>> check operation is finished, then the function
>> ocfs2_filecheck_erase_entries() will possibly delete this entry from the
>> list, to free the entry memory during the second user process is referencing
>> on this entry.
>>> You know, the spinlock can not protect the file check operation (too long
>> time IO operation).
>>
>> Yes, a possible reason for separating the lists too. The entries will be
>> deleted after a check, and the user will not be able to perform a fix on it.
> Gang: we can not delete the file check entry after it's operation is done, since we need to keep
> them to provide the result history records.
>
>>
>> In any case, if we check on status, we can do away with it. We may
>> require filecheck_entry spinlocks later on, but for now it is not required.
> Gang: Why we need a spinlock  for each filecheck entry? the entry is only occupied by one user process.
> we only need to get the lock when adding/deleting the entry from the list, this operation is very short.
>
>>
>>
>>>
>>>> Anyways, I plan to make a separate list for this so we can do away with
>>>> more macros.
>>> Gang: you can use two lists, but I think that one list is also OK, keep the
>> thing simple.
>>> Just return a -EBUSY error when the same inode is on the progress, then the
>> user can try again after that file check process returns.
>>
>> Thanks for the suggestions, I have incorporated that, with the two
>> lists, of course.
>>
>>>
>>>>
>>>> Besides, any I/O and check operation should be done in a separate
>>>> thread/work queue.
>>> Gang: current design is no a separated thread is used to run file check
>> operation, each user trigger process is used to execute its file check
>> operation.
>>> Why? first, keep the thing simple, avoid to involve more logic/thread.
>> second, if we involved a thread/work queue to run the file check operations,
>>> that means the user trigger process will return directly and need not to
>> wait for the actual file check operation, there will be a risk that the user
>> can
>>> not see the result from the result history record (via cat check/fix), since
>> the new submits result will make the oldest result records to be released,
>>> we have a fixed length list to keep these status records. If we use the user
>> trigger process to do the file check operation, the user can surely see the
>> result after this user process returns (since this file check operation is
>> done in the kernel space).
>>>
>>
>> In the future, how do you plan to extend this? How would you check for
>> extent_blocks? Or worse, system files? Would you keep the system waiting
>> until all I/O has completed?
> Gang: Yes, the trigger user process can wait for this I/O operation, just like a system call.
> If we want to check multiple files (inode), we can use a batch to call this interface one by one
> (of course,  you can use multiple threads/processes), this is why I did not use a work queue/thread
> in the kernel module to do this asynchronously, because in the user space, we can do the same thing.
> let's keep the kernel module logic simple.


If you were planning to keep the process synchronous, why keep multiple 
entries. Just one would have been enough. This way the check/fix cycle 
would have a better probability of finding stuff in the cache as well.


-- 
Goldwyn
