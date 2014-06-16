From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 16 Jun 2014 09:26:53 +0800
Subject: [Ocfs2-devel] [patch 4/8] ocfs2/dlm: do not purge lockres that
 is queued for assert master
In-Reply-To: <20140613213144.GM5484@wotan.suse.de>
References: <20140609200403.6A34D31C75B@corp2gmr1-1.hot.corp.google.com>
	<20140613213144.GM5484@wotan.suse.de>
Message-ID: <539E47DD.3070002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/6/14 5:31, Mark Fasheh wrote:
> On Mon, Jun 09, 2014 at 01:04:03PM -0700, Andrew Morton wrote:
>> @@ -683,6 +684,43 @@ void dlm_lockres_drop_inflight_ref(struc
>>  	wake_up(&res->wq);
>>  }
>>  
>> +void __dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
>> +		struct dlm_lock_resource *res)
>> +{
>> +	assert_spin_locked(&res->spinlock);
>> +	res->inflight_assert_workers++;
>> +	mlog(0, "%s:%.*s: inflight assert worker++: now %u\n",
>> +			dlm->name, res->lockname.len, res->lockname.name,
>> +			res->inflight_assert_workers);
>> +}
>> +
>> +void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
>> +		struct dlm_lock_resource *res)
>> +{
>> +	spin_lock(&res->spinlock);
>> +	__dlm_lockres_grab_inflight_worker(dlm, res);
>> +	spin_unlock(&res->spinlock);
>> +}
>> +
>> +void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
>> +		struct dlm_lock_resource *res)
>> +{
>> +	assert_spin_locked(&res->spinlock);
>> +	BUG_ON(res->inflight_assert_workers == 0);
>> +	res->inflight_assert_workers--;
>> +	mlog(0, "%s:%.*s: inflight assert worker--: now %u\n",
>> +			dlm->name, res->lockname.len, res->lockname.name,
>> +			res->inflight_assert_workers);
>> +}
>> +
>> +void dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
>> +		struct dlm_lock_resource *res)
>> +{
>> +	spin_lock(&res->spinlock);
>> +	__dlm_lockres_drop_inflight_worker(dlm, res);
>> +	spin_unlock(&res->spinlock);
>> +}
>> +
>>  /*
>>   * lookup a lock resource by name.
>>   * may already exist in the hashtable.
>> @@ -1603,7 +1641,8 @@ send_response:
>>  			mlog(ML_ERROR, "failed to dispatch assert master work\n");
>>  			response = DLM_MASTER_RESP_ERROR;
>>  			dlm_lockres_put(res);
>> -		}
>> +		} else
>> +			dlm_lockres_grab_inflight_worker(dlm, res);
>>  	} else {
>>  		if (res)
>>  			dlm_lockres_put(res);
>> @@ -2118,6 +2157,8 @@ static void dlm_assert_master_worker(str
>>  	dlm_lockres_release_ast(dlm, res);
>>  
>>  put:
>> +	dlm_lockres_drop_inflight_worker(dlm, res);
>> +
>>  	dlm_lockres_put(res);
>>  
>>  	mlog(0, "finished with dlm_assert_master_worker\n");
>> diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmrecovery.c
>> --- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
>> +++ a/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -1708,7 +1708,8 @@ int dlm_master_requery_handler(struct o2
>>  				mlog_errno(-ENOMEM);
>>  				/* retry!? */
>>  				BUG();
>> -			}
>> +			} else
>> +				__dlm_lockres_grab_inflight_worker(dlm, res);
>>  		} else /* put.. incase we are not the master */
>>  			dlm_lockres_put(res);
>>  		spin_unlock(&res->spinlock);
>> diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmthread.c
>> --- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
>> +++ a/fs/ocfs2/dlm/dlmthread.c
>> @@ -259,11 +259,14 @@ static void dlm_run_purge_list(struct dl
>>  		 * refs on it. */
>>  		unused = __dlm_lockres_unused(lockres);
>>  		if (!unused ||
>> -		    (lockres->state & DLM_LOCK_RES_MIGRATING)) {
>> +		    (lockres->state & DLM_LOCK_RES_MIGRATING) ||
>> +		    (lockres->inflight_assert_workers != 0)) {
> 
> If there's any assert master message we will halt purging *all* lock
> resources. That seems extreme to me :/
> 
Not halt purging *all* lock resource, when one lockres is queued for
master assert, it will be moved to the tail of the purge list, so
dlm_thread can keep purging other lock resources.
   -- joyce.xue
> What about putting a flag on lockres->state to indicate that it's got some
> work queued? We would set it before queuing the work, then clear it in the
> worker, or if we ever cancel the work.
> 	--Mark
> 
> --
> Mark Fasheh
> .
> 
