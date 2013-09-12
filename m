From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 11 Sep 2013 21:00:20 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: ocfs2 dlm umount skip
 migrating lockres
In-Reply-To: <523121CD.2040000@huawei.com>
References: <1378924830-16356-1-git-send-email-tariq.x.saeed@oracle.com>
	<523121CD.2040000@huawei.com>
Message-ID: <52313C54.3090600@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joseph,
thanks for pointing it out.

Andrew,
can you please pull the following patch acked by Sunil and Joel

https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008670.html


Thanks,
--Srini


On 09/11/2013 07:07 PM, Joseph Qi wrote:
> On 2013/9/12 2:40, Tariq Saeed wrote:
>> umount thread could race with migrate handler thread receiving resource
>> migration request from other node. When this happens, migrating thread
>> could set this node as the master along with DLM_LOCK_RES_MIGRATING flag.
>> umount thread should skip migrating this newly owned lockres until
>> DLM_LOCK_RES_MIGRATING flag is unset by migrate handler thread. umount
>> thread will ultimately migrate this lockres during another pass of the
>> lockres hash list.
>>
>> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
>> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
>> ---
>>   fs/ocfs2/dlm/dlmmaster.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 33ecbe0..1643b58 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -2360,6 +2360,10 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>>   	if (res->owner != dlm->node_num)
>>   		return 0;
>>   
>> +	if (res->state & DLM_LOCK_RES_MIGRATING) {
>> +		return 0;
>> +	}
>> +
>>           for (idx = DLM_GRANTED_LIST; idx <= DLM_BLOCKED_LIST; idx++) {
>>   		queue = dlm_list_idx_to_ptr(res, idx);
>>   		list_for_each_entry(lock, queue, list) {
>>
> This patch was sent before by Jiufei Xue on Aug 2012, which was titled
> as "ocfs2: delay migration when the lockres is in migration state".
> Please refer the below link for details:
> https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008670.html
>
> As I remembered, the patch was alerady acked by Sunil and Joel, and then
> it was in ocfs2.git.
> I am not sure why it wasn't merged to mainline.
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
