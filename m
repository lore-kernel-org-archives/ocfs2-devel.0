From: Coly Li <coly.li@suse.de>
Date: Fri, 12 Dec 2008 05:10:53 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error in
 concurrent file locking
In-Reply-To: <494168BA.5080904@oracle.com>
References: <1228789700-8226-1-git-send-email-sunil.mushran@oracle.com>
	<1228789700-8226-3-git-send-email-sunil.mushran@oracle.com>
	<49416451.90904@suse.de> <494168BA.5080904@oracle.com>
Message-ID: <494181DD.5060105@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> Coly Li wrote:
>> Because I am not familiar with the code yet, I though this is an oops
>> triggered by my first
>> modification. Therefore, I choose to use a loop which did not trigger
>> the oops.
>>
>> From your reply, it seems kernel BUG in
>> __dlm_lockres_drop_inflight_ref at dlmmaster.c:680 is
>> another bug ? I saw a patch named "ocfs2/dlm: Fix race in
>> adding/removing lockres' to/from the
>> tracking list", is it the fix for this bug ? If yes, I should learn
>> how you resolve it ;)
> 
> The oops in __dlm_lockres_drop_inflight_ref() is different that the
> tracking list oops. No relationship.
> 
> The inflight_ref oops is because the "fix" was not taking the ref. Hence
> it was zero during the drop. And that was because the "patch fix" was
> at the wrong location. See the diff between my first patch and the final
> one and see where the inflight ref is taken.
> 
Aha, Understand.
The previous patch did not grab an inflight_ref after waiting on __dlm_wait_on_lockres_flags(). A
lockres with inflight_ref (=0) is possible returned.
Yes, this was what I did not understand before. Perfect point :)

> The tracking list bug has always been there. It was exposed during
> forked flock() testing as explained in the patch.
> 
>> Here is how I thought, please comments on my mistake,
>> The dlm associated with lockres is projected by dlm->spinlock, if we
>> only protect lockres by
>> lockres->spinlock, there *might* be possibility to modify
>> dlm->node_num somewhere. Since we have
>> quite a few places to compare lockres->owner with dlm->node_num, I
>> suspect that manipulating on
>> lockres->owner without protecting dlm->owner might be problematic.
> 
> dlm->node_num can never be modified. It is the node number which
> is fixed for the life of the dlm domain (and more).
Got it, and remember it :-)

Thanks for your patient and accurate explaining again :-)
-- 
Coly Li
SuSE PRC Labs
