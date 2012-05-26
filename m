From: Xiaowei <xiaowei.hu@oracle.com>
Date: Sat, 26 May 2012 10:05:14 +0800
Subject: [Ocfs2-devel] [PATCH] Fix waiting status race condition in dlm
	recovery
In-Reply-To: <4FC00515.1060105@oracle.com>
References: <1337925202-13086-1-git-send-email-xiaowei.hu@oracle.com>
	<4FC00515.1060105@oracle.com>
Message-ID: <4FC03A5A.6090705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks Srini ,
This sounds good, I tried to use dlm_is_node_dead in this patch , but 
this function can't report
another node is dead if this node already in recovery process. It was 
blocked to set the bit in domain_map,
but the live_nodes_map could always reflect the really live nodes.

I will reformat the patch.

Thanks,
Xiaowei

On 05/26/2012 06:17 AM, srinivas eeda wrote:
> comments inline
>
> On 5/24/2012 10:53 PM, xiaowei.hu at oracle.com wrote:
>> From: "Xiaowei.Hu"<xiaowei.hu@oracle.com>
>>
>> when the master requested locks ,but one/some of the live nodes died,
>> after it received the request msg and before send out the locks 
>> packages,
>> the recovery will fall into endless loop,waiting for the status 
>> changed to finalize
>>
>> NodeA                                     NodeB
>> selected as recovery master
>> dlm_remaster_locks
>>    ->  dlm_requeset_all_locks
>>    this send request locks msg to B
>>                                            received the msg from A,
>>                                            queue worker 
>> dlm_request_all_locks_worker
>>                                            return 0
>> go on set state to requested
>> wait for the state become done
>>                                            NodeB lost connection due 
>> to network
>>                                            before the worker begin, 
>> or it die.
>> NodeA still waiting for the
>> change of reco state.
>> It won't end if it not get data done msg
>> And at this time nodeB do not realize this (or it just died),
>> it won't send the msg for ever, nodeA left in the recovery process 
>> forever.
>>
>> This patch let the recovery master check if the node still in live node
>> map when it stay in REQUESTED status.
>>
>> Signed-off-by: Xiaowei.Hu<xiaowei.hu@oracle.com>
>> ---
>>   fs/ocfs2/dlm/dlmrecovery.c |    9 +++++++++
>>   1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index 01ebfd0..62659e8 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -555,6 +555,7 @@ static int dlm_remaster_locks(struct dlm_ctxt 
>> *dlm, u8 dead_node)
>>       int all_nodes_done;
>>       int destroy = 0;
>>       int pass = 0;
>> +    int dying = 0;
>>
>>       do {
>>           /* we have become recovery master.  there is no escaping
>> @@ -659,6 +660,7 @@ static int dlm_remaster_locks(struct dlm_ctxt 
>> *dlm, u8 dead_node)
>>           list_for_each_entry(ndata,&dlm->reco.node_data, list) {
>>               mlog(0, "checking recovery state of node %u\n",
>>                    ndata->node_num);
>> +            dying = 0;
>>               switch (ndata->state) {
>>                   case DLM_RECO_NODE_DATA_INIT:
>>                   case DLM_RECO_NODE_DATA_REQUESTING:
>> @@ -679,6 +681,13 @@ static int dlm_remaster_locks(struct dlm_ctxt 
>> *dlm, u8 dead_node)
>>                            dlm->name, ndata->node_num,
>>                            ndata->state==DLM_RECO_NODE_DATA_RECEIVING ?
>>                            "receiving" : "requested");
>> +                    spin_lock(&dlm->spinlock);
>> +                    dying = !test_bit(ndata->node_num, 
>> dlm->live_nodes_map);
>> +                    spin_unlock(&dlm->spinlock);
>> +                    if (dying) {
>> +                        ndata->state = DLM_RECO_NODE_DATA_DEAD;
>> +                        break;
>> +                    }
>>                       all_nodes_done = 0;
>>                       break;
>>                   case DLM_RECO_NODE_DATA_DONE:
> fix seems to address the issue, but can you please add a function 
> dlm_is_node_in_livemap similar to dlm_is_node_dead so that it' 
> improves readability. You can then add the following to check if the 
> node is still alive
> +        if (!dlm_is_node_in_livemap(dlm, ndata->node_num))
> +            ndate->state = DLM_RECO_NODE_DATA_DEAD;
> +        else
> +            all_nodes_done = 0;
