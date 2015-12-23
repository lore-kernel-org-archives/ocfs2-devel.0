From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 23 Dec 2015 10:18:52 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix recursive locking deadlock
In-Reply-To: <20151222221247.GQ11072@wotan.suse.de>
References: <1450058259-30682-1-git-send-email-junxiao.bi@oracle.com>
	<566EC6A8020000F90002219D@relay2.provo.novell.com>
	<566E5BA5.5030308@oracle.com> <20151214191827.GF11072@wotan.suse.de>
	<566F7054.8030501@oracle.com> <20151218232319.GM11072@wotan.suse.de>
	<56778A42.3060905@oracle.com> <20151222221247.GQ11072@wotan.suse.de>
Message-ID: <567A048C.9020401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

On 12/23/2015 06:12 AM, Mark Fasheh wrote:
> On Mon, Dec 21, 2015 at 01:12:34PM +0800, Junxiao Bi wrote:
>> Hi Mark,
>>
>> On 12/19/2015 07:23 AM, Mark Fasheh wrote:
>>> On Tue, Dec 15, 2015 at 09:43:48AM +0800, Junxiao Bi wrote:
>>>> Hi Mark,
>>>>
>>>> On 12/15/2015 03:18 AM, Mark Fasheh wrote:
>>>>> On Mon, Dec 14, 2015 at 02:03:17PM +0800, Junxiao Bi wrote:
>>>>>>> Second, this issue can be reproduced in old Linux kernels (e.g. 3.16.7-24)? there should not be any regression issue? 
>>>>>> Maybe just hard to reproduce, ocfs2 supports recursive locking.
>>>>>
>>>>> In what sense? The DLM might but the FS should never be making use of such a
>>>>> mechanism (it would be for userspace users).
>>>> See commit 743b5f1434f5 ("ocfs2: take inode lock in
>>>> ocfs2_iop_set/get_acl()"), it used recursive locking and caused a
>>>> deadlock, the call trace is in this patch's log.
>>>
>>> Ahh ok so it's part of the buggy patch.
>>>
>>>
>>>>> We really can't add recursive locks without this getting rejected upstream.
>>>>> There's a whole slew of reasons why we don't like those in the kernel.
>>>> Is there any harm to support this lock in kernel?
>>>
>>> Yeah so you can google search on why recursive locks are considered harmful
>>> by many programmers and in the Linux Kernel they are a big 'No No'. We used
>>> to have one recursive lock (the 'big kernel lock') which took a large effort
>>> to clean up.
>>>
>>> Most objections are going to come down to the readability of the code and
>>> the nasty bugs that can come about as a result. Here's a random blog post I
>>> found explaining some of this:
>>>
>>> http://blog.stephencleary.com/2013/04/recursive-re-entrant-locks.html
>> Good doc. Thank you for sharing it. Learned more about recursive locking.
> 
> Np, glad it helped.
> 
> 
>> But I am afraid, cluster lock suffers all drawbacks mentioned in that
>> doc since it is stick to node. P1 and P2 can hold one EX lock at the
>> same time, is it a kind of recursive locking for cluster lock?
>> Maybe it is just a bad naming of recursive locking. If two processes in
>> one node are allowed to hold one EX lock at the same time, why one
>> process not allowed to lock one EX lock two times?
> 
> Yeah I think maybe it's 'bad naming' as you say? What dlmglue is doing we
> call 'lock caching'.
> 
> It's possible to use the dlm without caching the locks but that means every
> process wanting a cluster lock will have to make a dlm request. So instead,
> we hold onto the lock until another node wants it. However, this effectively
> makes each lock node-wide (as opposed to per-process which we would get
> without the lock caching).
Yes.
> 
> For local process locking, we use the VFS locks (inode mutex, etc).
Yes.
> 
> So the cluster lock is never being acquired more than once, it gets
> acquired and dlmglue caches access to it in a fair way. Hence it is not
> being acquired 'recusively'.
> 
> Callers of dlmglue honor the usual locking rules - the same ones that we
> honor with local locks. For example, they must be properly ordered with
> respect to other locks.
> 
> 
> As you point out, we could turn the dlmglue locking into a true recursive
> locking scheme. But if we do that, then we are changing the design of
> dlmglue and introducing recursive locking into a kernel which does not hav
> it. 
Well, so this is just to keep cluster locking behavior align with local
locks and don't want to involve recursive locking into kernel. But
without recursive locking, it's a little hard to fix this issue, may
need refactor ocfs2_mknod(). Do you have a suggestion about the fix?

> The 2nd point is self explanatory. The reason I would also not want to
> change the design of dlmglue is that I don't feel this bug requires such a
> drastic measure.
Tariq just post another patch to fix this issue(add
OCFS2_LOCK_IGNORE_BLOCKED arg_flags to ocfs2_cluster_lock() to prevent
hang), do you agree with fixing like that?

The way i am using is more common, it can avoid all possible recursive
locking deadlock issue.

Another side benefit is that with this, we can know the lockres some
process is holding and blocked by, this info can be exported to debugfs,
then it will be very useful to live debug a cluster hung issue.

Thanks,
Junxiao.

> 
> Thanks,
> 	--Mark
> 
> --
> Mark Fasheh
> 
