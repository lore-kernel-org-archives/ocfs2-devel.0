From: piaojun <piaojun@huawei.com>
Date: Mon, 5 Mar 2018 11:35:16 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/dlm: don't handle migrate
 lockres if already in shutdown
In-Reply-To: <84073bb9-d49c-38f5-e514-a88a9924f25a@gmail.com>
References: <5A99F028.2090902@huawei.com>
	<84073bb9-d49c-38f5-e514-a88a9924f25a@gmail.com>
Message-ID: <5A9CBAF4.40702@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 2018/3/5 9:27, Joseph Qi wrote:
> 
> 
> On 18/3/3 08:45, piaojun wrote:
>> We should not handle migrate lockres if we are already in
>> 'DLM_CTXT_IN_SHUTDOWN', as that will cause lockres remains after leaving
>> dlm domain. At last other nodes will get stuck into infinite loop when
>> requsting lock from us.
>>
>> The problem is caused by concurrency umount between nodes. Before
>> receiveing N1's DLM_BEGIN_EXIT_DOMAIN_MSG, N2 has picked up N1 as the
>> migrate target. So N2 will continue sending lockres to N1 even though N1
>> has left domain.
>>
>>     N1                             N2 (owner)
>>                                    touch file
>>
>> access the file,
>> and get pr lock
>>
>>                                    begin leave domain and
>>                                    pick up N1 as new owner
>>
>> begin leave domain and
>> migrate all lockres done
>>
>>                                    begin migrate lockres to N1
>>
>> end leave domain, but
>> the lockres left
>> unexpectedly, because
>> migrate task has passed
>>
>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com> ---
>>  fs/ocfs2/dlm/dlmdomain.c   | 14 ++++++++++++++
>>  fs/ocfs2/dlm/dlmdomain.h   |  1 +
>>  fs/ocfs2/dlm/dlmrecovery.c |  9 +++++++++
>>  3 files changed, 24 insertions(+)
>>
>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>> index e1fea14..3b7ec51 100644
>> --- a/fs/ocfs2/dlm/dlmdomain.c
>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>> @@ -675,6 +675,20 @@ static void dlm_leave_domain(struct dlm_ctxt *dlm)
>>  	spin_unlock(&dlm->spinlock);
>>  }
>>
>> +int dlm_joined(struct dlm_ctxt *dlm)
> This helper can be static inline and placed into header.
Agree, and I decide move dlm_shutting_down() into dlmdomain.h together.

thansk,
Jun
> 
>> +{
>> +	int ret = 0;
>> +
>> +	spin_lock(&dlm_domain_lock);
>> +
> Delete blank line here.
> 
>> +	if (dlm->dlm_state == DLM_CTXT_JOINED)
>> +		ret = 1;
>> +
> Also here.
> 
> Except the above concern, it looks good to me.
> With they are fixed, feel free to add:
> 
> Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
> 
>> +	spin_unlock(&dlm_domain_lock);
>> +
>> +	return ret;
>> +}
>> +
>>  int dlm_shutting_down(struct dlm_ctxt *dlm)
>>  {
>>  	int ret = 0;
>> diff --git a/fs/ocfs2/dlm/dlmdomain.h b/fs/ocfs2/dlm/dlmdomain.h
>> index fd6122a..2f7f60b 100644
>> --- a/fs/ocfs2/dlm/dlmdomain.h
>> +++ b/fs/ocfs2/dlm/dlmdomain.h
>> @@ -28,6 +28,7 @@
>>  extern spinlock_t dlm_domain_lock;
>>  extern struct list_head dlm_domains;
>>
>> +int dlm_joined(struct dlm_ctxt *dlm);
>>  int dlm_shutting_down(struct dlm_ctxt *dlm);
>>  void dlm_fire_domain_eviction_callbacks(struct dlm_ctxt *dlm,
>>  					int node_num);
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index ec8f758..505ab42 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -1378,6 +1378,15 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
>>  	if (!dlm_grab(dlm))
>>  		return -EINVAL;
>>
>> +	if (!dlm_joined(dlm)) {
>> +		mlog(ML_ERROR, "Domain %s not joined! "
>> +			  "lockres %.*s, master %u\n",
>> +			  dlm->name, mres->lockname_len,
>> +			  mres->lockname, mres->master);
>> +		dlm_put(dlm);
>> +		return -EINVAL;
>> +	}
>> +
>>  	BUG_ON(!(mres->flags & (DLM_MRES_RECOVERY|DLM_MRES_MIGRATION)));
>>
>>  	real_master = mres->master;
>>
> .
> 
