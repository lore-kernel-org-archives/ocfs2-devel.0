From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 8 Oct 2014 09:48:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: call dlm_lockres_put without
 resource spinlock
In-Reply-To: <20141001155549.e64a41bbf797482eb388f65b@linux-foundation.org>
References: <542526C3.2090302@huawei.com>
	<20141001155549.e64a41bbf797482eb388f65b@linux-foundation.org>
Message-ID: <5434980A.2030708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/10/2 6:55, Andrew Morton wrote:
> On Fri, 26 Sep 2014 16:41:39 +0800 alex chen <alex.chen@huawei.com> wrote:
> 
>> dlm_lockres_put should be called without &res->spinlock, otherwise a
>> deadlock case may happen.
>>
>> spin_lock(&res->spinlock)
>> ...
>> dlm_lockres_put
>>   ->dlm_lockres_release
>>     ->dlm_print_one_lock_resource
>>       ->spin_lock(&res->spinlock)
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
>> ---
>>  fs/ocfs2/dlm/dlmrecovery.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index 45067fa..3365839 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -1710,9 +1710,12 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
>>  				BUG();
> 
> This code does a GFP_ATOMIC allocation attempt and if that fails, it
> goes BUG().
> 
> Guys, GFP_ATOMIC is unreliable.  This isn't production quality code :(
> 
Last time we talked about this and Wengang sugguested it return an
error to the sender and let the sender retry.
I'll take this idea and send a patch.
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
