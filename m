From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 24 Jun 2013 20:57:03 +0800
Subject: [Ocfs2-devel] [PATCH] Fix waiting status race condition in dlm
 recovery V2
In-Reply-To: <51C7D1A1.90803@oracle.com>
References: <51BFC7E1.10908@huawei.com> <51BFD04A.1030404@huawei.com>
	<51C6D816.7000401@oracle.com> <51C7D1A1.90803@oracle.com>
Message-ID: <51C8421F.30208@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, xiaowei,
On 2013/6/24 12:57, xiaowei.hu wrote:
> On 06/23/2013 07:12 PM, Jeff Liu wrote:
>> On 06/18/2013 11:13 AM, Xue jiufei wrote:
>>
>>>> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
>>>>
>>>> when the master requested locks ,but one/some of the live nodes died,
>>>> after it received the request msg and before send out the locks packages,
>>>> the recovery will fall into endless loop,waiting for the status changed to finalize
>>>>
>>>> NodeA                                     NodeB
>>>> selected as recovery master
>>>> dlm_remaster_locks
>>>>    -> dlm_requeset_all_locks
>>>>    this send request locks msg to B
>>>>                                            received the msg from A,
>>>>                                            queue worker dlm_request_all_locks_worker
>>>>                                            return 0
>>>> go on set state to requested
>>>> wait for the state become done
>>>>                                            NodeB lost connection due to network
>>>>                                            before the worker begin, or it die.
>>>>
>>>> NodeA still waiting for the change of reco state.
>>>> It won't end if it not get data done msg.
>>>> And at this time nodeB do not realize this (or it just died),
>>>> it won't send the msg for ever, nodeA left in the recovery process forever.
>>>>
>>>> This patch let the recovery master check if the node still in live node
>>>> map when it stay in REQUESTED status.
>>>>
>>> Hi, xiaowei,
>>> We have reviewed this patch and have some questions:
>>> 1) in dlm_is_node_in_livemap(), I think it should use
>>> !!(test_bit(node, dlm->live_nodes_map)) to determine whether a node is
>>> live;
>> Hmm? test_bit(node,...) is ok.
>>
>>> 2) why not use dlm_is_node_dead() instead of dlm_is_node_in_livemap()
>>> in dlm_remaster_locks?
>>> I think dlm_is_node_dead() is better because dlm->live_nodes_map
>>> may be remain when another node umount.
> For this question, I remember I explained in one of  the emails, paste you that contant:
> =============
> Hi Sunil,
> 
> I considered your suggestion about this patch, it's possible to change the status in dlm hb down event,
> but what need to change are the dlm_reco_node_data structures in dlm->reco.node_data list.
> This list is initialized in dlm_remaster_locks when it begins the lock remaster and destroied before exit this function.
> So it's not proper to check data in such a list from dlm hb down event, am I right?
> If change the status from dlm hb down event , that means we make the recovery thread rely on more information from the hb down event,
> actually the dlm->live_nodes_map is marked in this event , and for others to check , right?
> 
> This race condition only happen when cluster already in recovery and a node dead during recovery. the recovery thread blocked the update of dlm->domain_map, so I fallback to check the live_nodes_map, which won't be blocked.
> 
> Please reconsider this patch.
> ================
The update of dlm->domain_map is triggered by hb down event or
DLM_BEGIN_RECO_MSG received from recovery master when a node died.
I wonder Why it is blocked by recovery thread.

>> Please refer to:
>> http://marc.info/?l=ocfs2-devel&m=133799814717270&w=2
>>
>> Thanks,
>> -Jeff
>>
>>> Thanks.
>>>
>>>> Signed-off-by: Xiaowei.Hu <xiaowei.hu@oracle.com>
>>>> ---
>>>>   fs/ocfs2/dlm/dlmrecovery.c |   16 +++++++++++++++-
>>>>   1 files changed, 15 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>>>> index 01ebfd0..546c5b5 100644
>>>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>>>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>>> @@ -339,6 +339,17 @@ static int dlm_reco_master_ready(struct dlm_ctxt *dlm)
>>>>       return ready;
>>>>   }
>>>>   +/* returns true if node is still in the live node map
>>>> + * this map is cleared before domain map,could be checked in recovery*/
>>>> +int dlm_is_node_in_livemap(struct dlm_ctxt *dlm, u8 node)
>>>> +{
>>>> +    int live;
>>>> +    spin_lock(&dlm->spinlock);
>>>> +    live = !test_bit(node, dlm->live_nodes_map);
>>>> +    spin_unlock(&dlm->spinlock);
>>>> +    return live;
>>>> +}
>>>> +
>>>>   /* returns true if node is no longer in the domain
>>>>    * could be dead or just not joined */
>>>>   int dlm_is_node_dead(struct dlm_ctxt *dlm, u8 node)
>>>> @@ -679,7 +690,10 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
>>>>                            dlm->name, ndata->node_num,
>>>>                            ndata->state==DLM_RECO_NODE_DATA_RECEIVING ?
>>>>                            "receiving" : "requested");
>>>> -                    all_nodes_done = 0;
>>>> +                    if (!dlm_is_node_in_livemap(dlm, ndata->node_num))
>>>> +                        ndata->state = DLM_RECO_NODE_DATA_DEAD;
>>>> +                    else
>>>> +                        all_nodes_done = 0;
>>>>                       break;
>>>>                   case DLM_RECO_NODE_DATA_DONE:
>>>>                       mlog(0, "%s: node %u state is done\n",
>>>>
>>>
>>>
>>>
>>> .
>>>
>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
> .
> 
