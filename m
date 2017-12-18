From: Changwei Ge <ge.changwei@h3c.com>
Date: Mon, 18 Dec 2017 12:08:48 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a potential deadlock in
 dlm_reset_mleres_owner()
References: <5A3796E8.4060708@huawei.com>
	<e925268c-c699-f763-7a1e-edec86955a33@gmail.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F5C2F2@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2017/12/18 19:52, Joseph Qi wrote:
> 
> 
> On 17/12/18 18:22, alex chen wrote:
>> In dlm_reset_mleres_owner(), we will lock
>> dlm_lock_resource->spinlock after locking dlm_ctxt->master_lock,
>> which breaks the spinlock lock ordering:
>>   dlm_domain_lock
>>   struct dlm_ctxt->spinlock
>>   struct dlm_lock_resource->spinlock
>>   struct dlm_ctxt->master_lock
>>
>> Fix it by unlocking dlm_ctxt->master_lock before locking
>> dlm_lock_resource->spinlock and restarting to clean master list.
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>> ---
>>   fs/ocfs2/dlm/dlmmaster.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 3e04279..0df939a 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -3287,14 +3287,23 @@ static struct dlm_lock_resource *dlm_reset_mleres_owner(struct dlm_ctxt *dlm,
>>   {
>>   	struct dlm_lock_resource *res;
>>
>> +	assert_spin_locked(&dlm->spinlock);
>> +	assert_spin_locked(&dlm->master_lock);
>> +
>>   	/* Find the lockres associated to the mle and set its owner to UNK */
>> -	res = __dlm_lookup_lockres(dlm, mle->mname, mle->mnamelen,
>> +	res = __dlm_lookup_lockres_full(dlm, mle->mname, mle->mnamelen,
>>   				   mle->mnamehash);
>>   	if (res) {
>>   		spin_unlock(&dlm->master_lock);
>>
>> -		/* move lockres onto recovery list */
>>   		spin_lock(&res->spinlock);
>> +		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
>> +			spin_unlock(&res->spinlock);
>> +			dlm_lockres_put(res);
>> +			return NULL;
>> +		}
> 
> We can't just return NULL here. Please note that we have to:
> return a valid lock resource with master_lock unlocked, or return NULL
> with master_lock.
> You patch will introduce unlocking master_lock twice.

Agree.

> 
> Thanks,
> Joseph
> 
>> +
>> +		/* move lockres onto recovery list */
>>   		dlm_set_lockres_owner(dlm, res, DLM_LOCK_RES_OWNER_UNKNOWN);
>>   		dlm_move_lockres_to_recovery_list(dlm, res);
>>   		spin_unlock(&res->spinlock);
>>
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
