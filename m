From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 31 Oct 2014 13:29:01 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2net: fix connect expired
In-Reply-To: <5452CA16.6040300@oracle.com>
References: <cfbc64ba-7e02-4051-8de2-a79268fabca0@default>
	<5452CA16.6040300@oracle.com>
Message-ID: <54531E1D.1060300@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Srini,

On 10/31/2014 07:30 AM, Srinivas Eeda wrote:
> Hi Junxiao,
> 
> I am hesitant to make changes to o2net_set_nn_state calls as it is a
> sensitive code. Also, currently, nn_timeout is only used to determine if
> a reconnect needs to be allowed or not. So, lets rename that to
> nn_reconnect and use it for that purpose.
> 
> With your change, o2net_connect_expired now doesn't pass -ENOTCONN when
> a network hb timeout happens. So o2net_set_nn_state now fails to wake_up
> any threads stuck on nn_sc_wq(check o2net_send_message_vec function) ?
As we talked, dlm depends on network, for connection expires, dlm don't
need be waken up, just wait network to recover is ok. Also dlm didn't do
good work on error wakeup case. Could you add you review-by?

Thanks,
Junxiao.

> 
> Thanks,
> --Srini
> 
> 
> 
> On 10/30/2014 04:58 AM, Junxiao Bi wrote:
>> ----- srinivas.eeda at oracle.com wrote:
>>
>>> Hi Junxiao,
>>>
>>> thanks for explaining. For this case allowing a reconnect (setting
>>> "atomic_set(&nn->nn_timeout, 1);" ) in o2net_connect_expired should
>>> work ?
>> Hi Srini,
>>
>> Yes, that should also work for this case. But it breaks the usage of
>> nn_timeout, it is only used for idle timeout.
>>
>> Thanks,
>> Junxiao.
>>> Thanks,
>>> --Srini
>>>
>>>
>>> On 10/29/2014 10:32 PM, Junxiao Bi wrote:
>>>> Hi Srini,
>>>>
>>>> On 10/30/2014 01:16 PM, Srinivas Eeda wrote:
>>>>> Junxiao,
>>>>>
>>>>> can you please describe under what circumstances you saw this
>>> problem?
>>>>> My understanding is o2net_connect_expired is only queued when
>>> connection
>>>>> actually broke and ENOTCONN is the right error in that case.
>>>> This happened when o2net was issuing the first connect request to
>>> some
>>>> node, but the request packet is lost due to some error like network
>>>> broken, then the connect would be expired, in
>>> o2net_connect_expired()
>>>> that set nn->nn_persistent_error to -ENOTCONN but timeout was zero,
>>> so
>>>> o2net_start_connect() would return without sending another connect
>>>> request, connection to the node will never be built.
>>>>
>>>> Thanks,
>>>> Junxiao.
>>>>
>>>>> Thanks,
>>>>> --Srini
>>>>>
>>>>> On 10/29/2014 06:41 PM, Junxiao Bi wrote:
>>>>>> Set nn_persistent_error to -ENOTCONN will stop reconnect since
>>> the
>>>>>> "stop" condition in o2net_start_connect() will be true.
>>>>>>
>>>>>> stop = (nn->nn_sc ||
>>>>>>           (nn->nn_persistent_error &&
>>>>>>           (nn->nn_persistent_error != -ENOTCONN || timeout ==
>>> 0)));
>>>>>> This will make connection never be established if the first
>>> connection
>>>>>> request
>>>>>> is lost.
>>>>>>
>>>>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>>>>> ---
>>>>>>     fs/ocfs2/cluster/tcp.c |    2 +-
>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
>>>>>> index 97de0fb..4d6b645 100644
>>>>>> --- a/fs/ocfs2/cluster/tcp.c
>>>>>> +++ b/fs/ocfs2/cluster/tcp.c
>>>>>> @@ -1736,7 +1736,7 @@ static void o2net_connect_expired(struct
>>>>>> work_struct *work)
>>>>>>                  o2net_idle_timeout() / 1000,
>>>>>>                  o2net_idle_timeout() % 1000);
>>>>>>     -        o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
>>>>>> +        o2net_set_nn_state(nn, NULL, 0, 0);
>>>>>>         }
>>>>>>         spin_unlock(&nn->nn_lock);
>>>>>>     }
> 
