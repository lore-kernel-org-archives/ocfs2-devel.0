From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Feb 2010 15:50:25 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message
	protocol
In-Reply-To: <4B7C7F94.206@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>	<1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>	<20100217055641.GI13798@mail.oracle.com>
	<4B7C345E.6000504@oracle.com> <4B7C706F.7060807@oracle.com>
	<4B7C732A.8000204@oracle.com> <4B7C720E.3060401@oracle.com>
	<4B7C7F94.206@oracle.com>
Message-ID: <4B7C80C1.4060400@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

My understanding was that we'll also requeue after sending a keepalive.
As in, not wait for the response to requeue. But we'll still be smart about
it in the sense that not send a hb even if the nodes are communicating
otherwise.

Srinivas Eeda wrote:
> In old code a node cancels and re queues keep alive message when it 
> hears from the other node. If it didn't hear in 2 seconds, queued 
> message gets fired which sends a keep alive message. And a re queue 
> happens only after it hears from the other node.
>
> With the new change, a node sends keep alive every 2 seconds.
>
> Sunil Mushran wrote:
>> How will it double? The node will send a keepalive only if it has
>> not heard from the other node for 2 secs.
>>
>> Srinivas Eeda wrote:
>>> No harm, just doubles heartbeat messages which is not required at all.
>>>
>>> Sunil Mushran wrote:
>>>> What's the harm in leaving it in?
>>>>
>>>> Srinivas Eeda wrote:
>>>>> Each node that has this patch would send a 
>>>>> O2NET_MSG_KEEP_REQ_MAGIC every 2 seconds(default). So, nodes 
>>>>> without this patch would always receive a heartbeat message every 
>>>>> 2 seconds.
>>>>>
>>>>> Nodes without this patch will send(respond) with 
>>>>> O2NET_MSG_KEEP_RESP_MAGIC for every keep alive packet they 
>>>>> received. So nodes with this patch will always receive a response 
>>>>> message.
>>>>>
>>>>> So, in a mixed setup, both nodes will always hear the heartbeat 
>>>>> from each other :).
>>>>>
>>>>> thanks,
>>>>> --Srini
>>>>>
>>>>>
>>>>>
>>>>> Joel Becker wrote:
>>>>>  
>>>>>> On Thu, Jan 28, 2010 at 08:51:11PM -0800, Srinivas Eeda wrote:
>>>>>>   
>>>>>>>          case O2NET_MSG_KEEP_REQ_MAGIC:
>>>>>>> -            o2net_sendpage(sc, o2net_keep_resp,
>>>>>>> -                       sizeof(*o2net_keep_resp));
>>>>>>> +            /* Each node now sends keepalive message every
>>>>>>> +             * keepalive time interval. Hence no need for response
>>>>>>> +             */
>>>>>>>              goto out;
>>>>>>>           
>>>>>>     You still have to send the response.  Think about a mixed
>>>>>> environment where some nodes have this fix and some do not.  The 
>>>>>> older
>>>>>> software is still waiting on the response.
>>>>>>     The newer version can just ignore any responses it gets from
>>>>>> other nodes.  But it has to send responses out just in case the 
>>>>>> other
>>>>>> node is older.
>>>>>>     The only other alternative is to bump the o2net protocol
>>>>>> version, and that means the cluster has to be shut down to 
>>>>>> upgrade.  Not
>>>>>> a good choice.
>>>>>>
>>>>>> Joel
>>>>>>
>>>>>>       
>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>>>   
>>>>
>>>
>>
>
