From: tao.ma <tao.ma@oracle.com>
Date: Thu Jan 10 16:34:35 2008
Subject: [Ocfs2-devel] [PATCH 1/1] Clear joining_node no matter whether
	it	is in the domain map or not.
In-Reply-To: <47865DE8.9000500@oracle.com>
References: <20080110072055.GA7911@tma-pc1.cn.oracle.com>
	<47865DE8.9000500@oracle.com>
Message-ID: <4786B98D.5080707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> This looks good. Did you manage to actually test this scenario?
Yes, I have simulate this scenario by 2 steps.
1. Let o2net timeout in the joining node.(this node number is bigger 
than the mounted one.)
    The joining node will fence. And after its fence, no other node can 
join the domain include himself.
    The mounted one hang when the "umount" is called.
After the modification, it goes well.
2. Let o2net timeout in the joining node.(this node number is less than 
the mounted one.) The mounted one will reboot and the joining node mount 
the volume. After the mounted one reboot, it can join the domain. So the 
old code handle this issue successfully.
>
> We'll need to apply this both git and 1.2.
>
> Tao Ma wrote:
>> Currently the process of dlm join contains 2 steps: query join and 
>> assert join.
>> After query join, the joined node will set its joining_node. So if 
>> the joining
>> node happens to panic before the 2nd step, the joined node will fail 
>> to clear
>> its joining_node flag because that node isn't in the domain map. It 
>> at least
>> cause 2 problems.
>> 1. All the new join request will fail. So no new node can mount the 
>> volume.
>> 2. The joined node can't umount the volume since during the umount 
>> process it
>>    has to wait for the joining_node to be unknown. So the umount will 
>> be hanged.
>>
>> The solution is to clear the joining_node before we check the domain 
>> map.
>>
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>> ---
>>  fs/ocfs2/dlm/dlmrecovery.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index 2fde7bf..3502bec 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -2270,6 +2270,12 @@ static void __dlm_hb_node_down(struct dlm_ctxt 
>> *dlm, int idx)
>>          }
>>      }
>>  
>> +    /* Clean up join state on node death. */
>> +    if (dlm->joining_node == idx) {
>> +        mlog(0, "Clearing join state for node %u\n", idx);
>> +        __dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
>> +    }
>> +
>>      /* check to see if the node is already considered dead */
>>      if (!test_bit(idx, dlm->live_nodes_map)) {
>>          mlog(0, "for domain %s, node %d is already dead. "
>> @@ -2288,12 +2294,6 @@ static void __dlm_hb_node_down(struct dlm_ctxt 
>> *dlm, int idx)
>>  
>>      clear_bit(idx, dlm->live_nodes_map);
>>  
>> -    /* Clean up join state on node death. */
>> -    if (dlm->joining_node == idx) {
>> -        mlog(0, "Clearing join state for node %u\n", idx);
>> -        __dlm_set_joining_node(dlm, DLM_LOCK_RES_OWNER_UNKNOWN);
>> -    }
>> -
>>      /* make sure local cleanup occurs before the heartbeat events */
>>      if (!test_bit(idx, dlm->recovery_map))
>>          dlm_do_local_recovery_cleanup(dlm, idx);
>>   
>
