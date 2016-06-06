From: Gang He <ghe@suse.com>
Date: Sun, 05 Jun 2016 19:17:55 -0600
Subject: [Ocfs2-devel] [PATCH 5/5] Fix files when an inode is written in
 file_fix
In-Reply-To: <5751A336.6000206@suse.de>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
	<1464232219-12553-6-git-send-email-rgoldwyn@suse.de>
	<574C7C2A020000F900039287@suse.com> <574D863F.6000104@suse.com>
	<574EB352020000F900029215@prv-mh.provo.novell.com>
	<574F9959.3060004@suse.de>
	<57501329020000F900039C1B@prv-mh.provo.novell.com>
	<574FAC77.1080503@suse.de>
	<57502602020000F900039C45@prv-mh.provo.novell.com>
	<57501CCC.5080001@suse.de> <57517BDE020000F90003A02C@suse.com>
	<5751A336.6000206@suse.de>
Message-ID: <57553FC3020000F90002ACF5@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,

I have no more comments, let's discuss when your update code is finished.


Thanks
Gang


>>> 

> 
> On 06/02/2016 11:45 PM, Gang He wrote:
>>
>>
>>>>>>>>>>>       int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
>>>>>>>>>>>       				     unsigned long ino)
>>>>>>>>>>>       {
>>>>>>>>>>> @@ -268,3 +252,28 @@ unlock:
>>>>>>>>>>>       	ocfs2_filecheck_done_entry(osb, entry);
>>>>>>>>>>>       	return 0;
>>>>>>>>>>>       }
>>>>>>>>>>> +
>>>>>>>>>>> +int ocfs2_filefix_add_inode(struct ocfs2_super *osb,
>>>>>>>>>>> +				     unsigned long ino)
>>>>>>>>>>> +{
>>>>>>>>>>> +	struct ocfs2_filecheck_entry *entry;
>>>>>>>>>>> +	int ret = -ENOENT;
>>>>>>>>>>> +
>>>>>>>>>>> +	spin_lock(&osb->fc_lock);
>>>>>>>>>>> +	list_for_each_entry(entry, &osb->file_check_entries, fe_list)
>>>>>>>>>>> +		if (entry->fe_ino == ino) {
>>>>>>>>>>> +			entry->fe_type = OCFS2_FILECHECK_TYPE_FIX;
>>>>>>>>>> Gang: It looks that we can not do it directly, why? because the entry
>>>>>>>>> pointer can be freed by the function ocfs2_filecheck_erase_entries().
>>>>>>>>>> We can not use the same entry pointer within two user processes.
>>>>>>>>>> The simple solution is to return -EBUSY error in case there is the same ino
>>>>>>>>> number entry in the list, then the user can try again after the previous
>>>>>>> user
>>>>>>>>> process is returned.
>>>>>>>>>
>>>>>>>>> How? is it not protected under spinlock?
>>>>>>>> Gang: please aware that this spinlock fc_lock is used to protect entry list
>>>>>>> (adding entry/deleting entry), not protect entry itself.
>>>>>>>> The first user process will mark the entry's status to done after the file
>>>>>>> check operation is finished, then the function
>>>>>>> ocfs2_filecheck_erase_entries() will possibly delete this entry from the
>>>>>>> list, to free the entry memory during the second user process is referencing
>>>>>>> on this entry.
>>>>>>>> You know, the spinlock can not protect the file check operation (too long
>>>>>>> time IO operation).
>>>>>>>
>>>>>>> Yes, a possible reason for separating the lists too. The entries will be
>>>>>>> deleted after a check, and the user will not be able to perform a fix on it.
>>>>>> Gang: we can not delete the file check entry after it's operation is done,
>>>>> since we need to keep
>>>>>> them to provide the result history records.
>>>>>>
>>>>>>>
>>>>>>> In any case, if we check on status, we can do away with it. We may
>>>>>>> require filecheck_entry spinlocks later on, but for now it is not required.
>>>>>> Gang: Why we need a spinlock  for each filecheck entry? the entry is only
>>>>> occupied by one user process.
>>>>>> we only need to get the lock when adding/deleting the entry from the list,
>>>>> this operation is very short.
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>> Anyways, I plan to make a separate list for this so we can do away with
>>>>>>>>> more macros.
>>>>>>>> Gang: you can use two lists, but I think that one list is also OK, keep the
>>>>>>> thing simple.
>>>>>>>> Just return a -EBUSY error when the same inode is on the progress, then the
>>>>>>> user can try again after that file check process returns.
>>>>>>>
>>>>>>> Thanks for the suggestions, I have incorporated that, with the two
>>>>>>> lists, of course.
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Besides, any I/O and check operation should be done in a separate
>>>>>>>>> thread/work queue.
>>>>>>>> Gang: current design is no a separated thread is used to run file check
>>>>>>> operation, each user trigger process is used to execute its file check
>>>>>>> operation.
>>>>>>>> Why? first, keep the thing simple, avoid to involve more logic/thread.
>>>>>>> second, if we involved a thread/work queue to run the file check operations,
>>>>>>>> that means the user trigger process will return directly and need not to
>>>>>>> wait for the actual file check operation, there will be a risk that the user
>>>>>>> can
>>>>>>>> not see the result from the result history record (via cat check/fix), since
>>>>>>> the new submits result will make the oldest result records to be released,
>>>>>>>> we have a fixed length list to keep these status records. If we use the user
>>>>>>> trigger process to do the file check operation, the user can surely see the
>>>>>>> result after this user process returns (since this file check operation is
>>>>>>> done in the kernel space).
>>>>>>>>
>>>>>>>
>>>>>>> In the future, how do you plan to extend this? How would you check for
>>>>>>> extent_blocks? Or worse, system files? Would you keep the system waiting
>>>>>>> until all I/O has completed?
>>>>>> Gang: Yes, the trigger user process can wait for this I/O operation, just
>>>>> like a system call.
>>>>>> If we want to check multiple files (inode), we can use a batch to call this
>>>>> interface one by one
>>>>>> (of course,  you can use multiple threads/processes), this is why I did not
>>>>> use a work queue/thread
>>>>>> in the kernel module to do this asynchronously, because in the user space,
>>>>> we can do the same thing.
>>>>>> let's keep the kernel module logic simple.
>>>>>
>>>>>
>>>>> If you were planning to keep the process synchronous, why keep multiple
>>>>> entries. Just one would have been enough. This way the check/fix cycle
>>>>> would have a better probability of finding stuff in the cache as well.
>>>> The list be used for file check entry history status, and for supporting to
>>> multiple user threads/processes to trigger a check/fix request parallelly.
>>>>
>>>
>>> Why do you need history in a synchronous process. The error is received
>>> as soon as the process ends.
>> How do you return a file check specific error number to the trigger user 
> process? then I use a list to save these file check entries (running/done).
>> The user maybe want to see the file check result again after the file check 
> was done, this just give an chance for user to inquire the result again, but 
> will not occupy too much memory.
> 
> There are quite a few ways, one of them being ioctl()s.
> In synchronous processing, you don't need to check error values again 
> and again. It is returned when you execute the request. Just like 
> synchronous system calls such as read() and write() receive errors
> 
> 
>>
>> Besides, in multiple threads each thread
>>> will have his context so you don't need to store in a global location.
>> Gang: I prefer to do the thing with independent design, do not depend some 
> other data structures/mechanism, since these data structures/mechanism will 
> be changed according kernel versions possibly. we should try to implement our 
> functions in our module code, then export some interfaces(extern functions) 
> to be invoked by some kernel sensitive  data structures/mechanism (e.g.
>> Kobject, ioctl, etc). Why I user a global location, at that moment, I did 
> not aware that we can embed kobject in super block structure like ext4, now 
> we can embed kobject in the super, the idea
>> is better.
> 
> But how will you code in the kernel if you don't use the kernel data 
> structures?
> 
>>
>>
>>> Why did you need to use sysfs for this? Why couldn't you use something
>>> else for synchronous processing, say an ioctl()?
>> Gang: Yes, this is a way to reach user process, as you said in a RFC one 
> year ago.
>> Of course, we also can use ioctl to commutation, but this will means that we 
> have to add some code to implement a user tool.
> 
> Yes, the main reason I suggested to maintain a history in the RFC was to 
> keep it asynchronous.
> 
>>
>> Anyway, I think it is not too important about if we use 
> synchronous/asynchronous to handle a file check operation, if you like, 
> please create a dedicated kernel thread to execute these file check entries 
> in the list. It is OK for both ways.
>>
> 
> It is not as complicated as you think. I will send it once I finish the 
> code.
> 
> -- 
> Goldwyn
