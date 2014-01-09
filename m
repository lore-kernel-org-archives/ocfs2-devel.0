From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 09 Jan 2014 11:27:15 -0600
Subject: [Ocfs2-devel] What's the need of OCFS2_INODE_MAYBE_ORPHANED?
In-Reply-To: <52CED680.10501@oracle.com>
References: <CAJtY7HVQue79bLEUPXnN=fSbvcKS_mA8FUQbmaNE0dipSp1XoA@mail.gmail.com>
	<52CDFB7F.5010200@oracle.com> <52CE13AF.5080107@suse.de>
	<52CE3409.8080108@oracle.com> <52CEC3C4.20505@suse.de>
	<52CEC915.8040908@oracle.com> <52CECF96.4050900@suse.de>
	<52CED680.10501@oracle.com>
Message-ID: <52CEDBF3.3010009@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/09/2014 11:04 AM, Srinivas Eeda wrote:
> On 01/09/2014 08:34 AM, Goldwyn Rodrigues wrote:
>> On 01/09/2014 10:06 AM, Srinivas Eeda wrote:
>>> On 01/09/2014 07:44 AM, Goldwyn Rodrigues wrote:
>>>> Hi Srini,
>>>>
>>>> Thanks for the reply.
>>>>
>>>> On 01/08/2014 11:30 PM, Srinivas Eeda wrote:
>>>>>>>> >From the comments in fs/ocfs2/inode.h:90 it seems, this was
>>>>>>>> used in
>>>>>>>> legacy ocfs2 systems when a node received unlink votes. Since
>>>>>>>> unlink
>>>>>>>> votes has been done away with and replaced with open locks, is this
>>>>>>>> flag still required? If yes, why?
>>>>>>> My understanding is that unlink voting protocol was heavy. So the
>>>>>>> following was done to address it.
>>>>>>>
>>>>>>> To do an unlink, dentry has to be removed. In order to do that the
>>>>>>> node
>>>>>>> has to get EX lock on the dentry which means all other nodes have to
>>>>>>> downconvert. In general EX lock on dentry is acquired only in
>>>>>>> unlink and
>>>>>>> I assume rename case. So all nodes which down convert the lock mark
>>>>>>> their inode OCFS2_INODE_MAYBE_ORPHANED. The only problem with
>>>>>>> this is
>>>>>>> that dentry on a node can get purged because of memory pressure
>>>>>>> which
>>>>>>> marks inode as OCFS2_INODE_MAYBE_ORPHANED even when no unlink was
>>>>>>> done
>>>>>>> on this inode.
>>>>>>>
>>>>>>
>>>>>> I think you are getting confused between dentry_lock (dentry_lockres)
>>>>>> and open lock (ip_open_lockres). AFAICS, dentry locks are used to
>>>>>> control the remote dentries.
>>>>> I was trying to answer why we need OCFS2_INODE_MAYBE_ORPHANED flag, I
>>>>> guess I wasn't clear. I'll make an other attempt :).
>>>>>
>>>>> One way for node A to tell node B that an unlink had happened on
>>>>> node A
>>>>> is by sending an explicit message(something similar to what we had in
>>>>> old release). When node B received such communication it marked inode
>>>>> with OCFS2_INODE_MAYBE_ORPHANED flag if it still had the inode in use.
>>>>>
>>>>> The other way(current implementation) is to indirectly tell it by
>>>>> asking
>>>>> node B to purge dentry lockres. Once node B has been informed that
>>>>> dentry lock has to be released, it assumes inode might have been
>>>>> unlinked somewhere and marks the inode with OCFS2_INODE_MAYBE_ORPHANED
>>>>> flag.
>>>>>
>>>>> So, we need OCFS2_INODE_MAYBE_ORPHANED flag to tell node B that it
>>>>> should finish the second phase of unlink(remove the inode from file
>>>>> system) when it closes the file.
>>>>
>>>> Okay, but  why should node B do the cleanup/wipe when node A initiated
>>>> the unlink()? Shouldn't it be done by node A? All node B should do is
>>>> to write the inode and clear it from the cache. The sequence is
>>>> synchronized by dentry_lock. Right?
>>> removing dentry is only the first part. An inode can still be open after
>>> that.
>>
>> Yes, I did not consider that.
>> How about using open locks ro_holders count to identify this? That may
>> just work. Thanks!
> One problem I see in using open lock for this is it could be late.
> Consider the scenario where node A removes the dentry and then the node
> crashes before trying the try_open_lock. Node B does the file close
> later but it doesn't know that the file was unlinked and doesn't do the
> clean up.
>
> To me it appears OCFS2_INODE_MAYBE_ORPHANED is necessary. Any delay it
> is causing must be addressed differently.

No, I don't mean to remove the OCFS2_INODE_MAYBE_ORPHANED flag, but set 
it conditionally in ocfs2_dentry_convert_worker() based on the value of 
the open locks held.

I'll write a patch and test. Thanks!

-- 
Goldwyn
