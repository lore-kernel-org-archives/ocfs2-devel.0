From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 17 Jul 2009 00:45:04 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: timer to queue scan of all
 orphan slots
In-Reply-To: <4A6023B1.9030803@oracle.com>
References: <1244073776-18748-1-git-send-email-srinivas.eeda@oracle.com>
	<1244073776-18748-2-git-send-email-srinivas.eeda@oracle.com>
	<4A2F46B1.5090301@oracle.com>
	<20090610075814.GA30471@ca-server1.us.oracle.com>
	<4A6023B1.9030803@oracle.com>
Message-ID: <4A602C00.1060602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Tao Ma wrote:
> Hi Joel,
>     This reply may be really too late. :)
>
> Joel Becker wrote:
>> On Wed, Jun 10, 2009 at 01:37:53PM +0800, Tao Ma wrote:
>>>     I also have some thoughts for it. Wish it isn't too late.
>>
>>     Well, if we come up with changes it will affect what I push, but
>> that's OK.
>>
>>>     Currently, orphan scan just iterate all the slots and call 
>>> ocfs2_queue_recovery_completion, but I don't think it is proper for 
>>> a node to query another mounted one since that node will query it by 
>>> itself.
>>
>>     Node 1 has an inode it was using.  The dentry went away due to
>> memory pressure.  Node 1 closes the inode, but it's on the free list.
>> The node has the open lock.
>>     Node 2 unlinks the inode.  It grabs the dentry lock to notify
>> others, but node 1 has no dentry and doesn't get the message.  It
>> trylocks the open lock, sees that another node has a PR, and does
>> nothing.
> I just went through the codes of orphan delete, and I think in this 
> case, we should have already released the open lock in node 1? When 
> dentry in node 1 went away, it iput. And when node 1 close the inode, 
> it iputs and open_lock is unlocked already. So node 2 should be OK to 
> delete the file.
>
> I guess the only case orphan scan help is that dentry in node 1 went 
> away while the file is opened and at that time node 2 unlink the file. 
> Am I wrong?
correct, but the file may not be opened. inode is node 1's cache.
>>     Later node 2 runs its orphan dir.  It igets the inode, trylocks
>> the open lock, sees the PR still, and does nothing.
>>     Basically, we have to trigger an orphan iput on node 1.  The
>> only way for this to happen is if node 1 runs node 2's orphan dir.  This
>> patch exists because that wasn't happening.
> If the above case I described is right, orphan scan would work after 
> node 1 close the inode. node 2 will scan its slot, and then try 
> iget->iput->try_open_lock->delete_inode, the file will be deleted 
> finally. So we won't trigger an iput in node1.
yes, the only problem is inode could be in node 1's cache for a very 
long time. But yes, once after node 1 flushes the inode and node 2 scans 
the slot it will be able to delete the file. In a multiple nodes cases, 
inode could be in multiple nodes cache.
>>
>>>     What's more, it will affect reflink greatly.
>>> In my current implementation of reflink, It will work like this:
>>> 1. create a inode in orphan dir
>>> 2. reflink all the extents.
>>> 3. move the inode from orphan dir to the destination.
>>>
>>> For efficiency, I just lock orphan dir in step 1 and 3, and release 
>>> the lock in step 2 in case reflink will take a long time and we 
>>> don't block other "unlink" process. And in step 1, the created inode 
>>> looks really like a deleted one so that any crash in step 2 won't 
>>> prevent it from being deleted by fsck or recovery.
>>>
>>> But with your patch, we may have a race in step 2 that your recovery 
>>> will delete the inode created in step 1. So my suggestion is that 
>>> your orphan scan just skip the mounted node so it won't affect other 
>>> nodes' ongoing reflink. As for the node itself, it is very easy to 
>>> postpone the orphan scan by setting a flag in ocfs2_super when 
>>> reflink is ongoing(I will do it).
>>
>>     You should have an in-core inode, right?  That holds the open
>> lock, preventing the others from deleting it.  If you crash, then your
>> open lock goes away, and it can be recovered.
>>     More importantly, your orphan dir can be run on regular recovery
>> async as well.  It has to work in all cases.
> yes, I have already added open_lock. So orphan scan won't affect 
> reflink actually. I just want to clarify the scenario orphan scan 
> really works. ;)
>
> Regards,
> Tao
