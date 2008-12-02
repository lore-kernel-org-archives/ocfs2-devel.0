From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 02 Dec 2008 11:16:40 -0800
Subject: [Ocfs2-devel] [nov 28] question of dlm_get_lock_resource()
In-Reply-To: <4935672E.6080800@suse.de>
References: <492FEC31.5010907@suse.de> <4934A0C4.2090404@oracle.com>
	<4935672E.6080800@suse.de>
Message-ID: <49358998.9040401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Read the purge_lockres code, the only place where we set this flag.

Coly Li wrote:
> Sunil Mushran Wrote:
>   
>> No. dlm->spinlock prevents it racing the dlm_thread. Secondly, lookup
>> also does a get.
>>
>> What scenario are you envisioning?
>>     
> IMHO, locking dlm->spinlock does not mean protecting to tmpres. Even line 727 gets false, how can we
> make sure in line 749 res->state is not modified to DLM_LOCK_RES_DROPPING_REF by other process ?
>
> I can not find the magic which make everything work in order, something important must be missed by me.
>
> Thanks.
>
>   
>> Coly Li wrote:
>>     
>>> Hi list,
>>>
>>> When I read code of dlm_get_lock_resource(), there is something not
>>> clear to me.
>>>
>>>  719 lookup:
>>>  720         spin_lock(&dlm->spinlock);
>>>  721         tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen,
>>> hash);
>>>  722         if (tmpres) {
>>>  723                 int dropping_ref = 0;
>>>  724
>>>  725                 spin_lock(&tmpres->spinlock);
>>>  726                 if (tmpres->owner == dlm->node_num) {
>>>  727                         BUG_ON(tmpres->state &
>>> DLM_LOCK_RES_DROPPING_REF);
>>>  728                         dlm_lockres_grab_inflight_ref(dlm, tmpres);
>>>  729                 } else if (tmpres->state &
>>> DLM_LOCK_RES_DROPPING_REF)
>>>  730                         dropping_ref = 1;
>>>  731                 spin_unlock(&tmpres->spinlock);
>>>  732                 spin_unlock(&dlm->spinlock);
>>>  733
>>>  734                 /* wait until done messaging the master, drop our
>>> ref to allow
>>>  735                  * the lockres to be purged, start over. */
>>>  736                 if (dropping_ref) {
>>>  737                         spin_lock(&tmpres->spinlock);
>>>  738                         __dlm_wait_on_lockres_flags(tmpres,
>>> DLM_LOCK_RES_DROPPING_REF);
>>>  739                         spin_unlock(&tmpres->spinlock);
>>>  740                         dlm_lockres_put(tmpres);
>>>  741                         tmpres = NULL;
>>>  742                         goto lookup;
>>>  743                 }
>>>  744
>>>  745                 mlog(0, "found in hash!\n");
>>>  746                 if (res)
>>>  747                         dlm_lockres_put(res);
>>>  748                 res = tmpres;
>>>  749                 goto leave;
>>>  750         }
>>>
>>> If at line 721 tmpres found from hash, and its state is not
>>> DLM_LOCK_RES_DROPPING_REF (dropping_ref
>>> is 0), between line 733 and 748, is it possible to set tmpres->state
>>> to DLM_LOCK_RES_DROPPING_REF ?
>>>
>>> I don't see any protection for this race, maybe there is something I
>>> missed. Can anybody give me a
>>> hint ?
>>>       
>
>   
