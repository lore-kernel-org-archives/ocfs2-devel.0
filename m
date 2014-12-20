From: jiangyiwen <jiangyiwen@huawei.com>
Date: Sat, 20 Dec 2014 17:39:07 +0800
Subject: [Ocfs2-devel] [patch 04/15] ocfs2: avoid access invalid address
 when read o2dlm debug messages
In-Reply-To: <20141219202503.GX7238@wotan.suse.de>
References: <548f65d4.jhly8vWOTpWuHPjg%akpm@linux-foundation.org>
	<20141216222629.GO7238@wotan.suse.de> <5493E31F.2000509@huawei.com>
	<20141219202503.GX7238@wotan.suse.de>
Message-ID: <549543BB.2060707@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

? 2014/12/20 4:25, Mark Fasheh ??:
> On Fri, Dec 19, 2014 at 04:34:39PM +0800, jiangyiwen wrote:
>> ? 2014/12/17 6:26, Mark Fasheh ??:
>>> On Mon, Dec 15, 2014 at 02:51:00PM -0800, Andrew Morton wrote:
>>>> In such a race case, invalid address access may occurs.  So we should
>>>> delete list res->tracking before resA->refs decrease to 0.
>>>>
>>>
>>>
>>>> diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmmaster.c
>>>> --- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
>>>> +++ a/fs/ocfs2/dlm/dlmmaster.c
>>>> @@ -498,16 +498,6 @@ static void dlm_lockres_release(struct k
>>>>  	mlog(0, "destroying lockres %.*s\n", res->lockname.len,
>>>>  	     res->lockname.name);
>>>>  
>>>> -	spin_lock(&dlm->track_lock);
>>>> -	if (!list_empty(&res->tracking))
>>>> -		list_del_init(&res->tracking);
>>>> -	else {
>>>> -		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
>>>> -		     res->lockname.len, res->lockname.name);
>>>> -		dlm_print_one_lock_resource(res);
>>>> -	}
>>>> -	spin_unlock(&dlm->track_lock);
>>>> -
>>>>  	atomic_dec(&dlm->res_cur_count);
>>>>  
>>>>  	if (!hlist_unhashed(&res->hash_node) ||
>>>> diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmthread.c
>>>> --- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
>>>> +++ a/fs/ocfs2/dlm/dlmthread.c
>>>> @@ -211,6 +211,16 @@ static void dlm_purge_lockres(struct dlm
>>>>  
>>>>  	__dlm_unhash_lockres(dlm, res);
>>>>  
>>>> +	spin_lock(&dlm->track_lock);
>>>> +	if (!list_empty(&res->tracking))
>>>> +		list_del_init(&res->tracking);
>>>> +	else {
>>>> +		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
>>>> +				res->lockname.len, res->lockname.name);
>>>> +		__dlm_print_one_lock_resource(res);
>>>> +	}
>>>> +	spin_unlock(&dlm->track_lock);
>>>> +
>>>>  	/* lockres is not in the hash now.  drop the flag and wake up
>>>>  	 * any processes waiting in dlm_get_lock_resource. */
>>>>  	if (!master) {
>>>> _
>>>
>>> How do we know that dlm_purge_lockres() is the last caller of
>>> dlm_lockres_put()? Don't we now have a problem where if the last ref is
>>> dropped by any other function than dlm_purge_lockres() the lockres is freed
>>> while on the tracking list?
>>> 	--Mark
>>>
>>> --
>>> Mark Fasheh
>>>
>>> .
>>>
>> dlm_purge_lockres is not necessarily the last caller of
>> dlm_lockres_put(), but it means lockres will be purged if
>> dlm_purge_lockres is called. Besides, lockres is also unhashed in
>> dlm_purge_lockres, so lockres can be removed from tracking list.
>> contents of dlm->tracking_list will be consistent with
>> dlm->lockres_hash.
> 
> I'm still confused. This is what I'm worried about:
> 
> 1) a procss calls dlm_lockres_put(), NOT from dlm_purge_lockres().
> 
> 2) if the count goes to zero, then that process will call dlm_lockres_release()
> 
But at this time, it has already called dlm_purge_lockres(). The reasons are as follows:
1) lockres is created in dlm_init_lockres(), it call kref_init(), count is 1;
2) Only when lockres is unused, it will call dlm_lockres_put() twice by dlm_run_purge_list().
So dlm_purge_lockres() has been called if the count goes to zero.

> 3) dlm_lockres_release() will free the lockres without removing it from the
> tracking list. Thus we will have a corrupted list.
>
Without this scene. dlm_purge_lockres() is called before dlm_lockres_release().
> Does that make sense? Am I wrong here?
> 	--Mark
> 
> --
> Mark Fasheh
> 
> .
> 
