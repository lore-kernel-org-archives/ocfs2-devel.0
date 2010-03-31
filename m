From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 31 Mar 2010 12:03:55 -0700
Subject: [Ocfs2-devel] o2net: log socket state changes
In-Reply-To: <4BB399C7.8000009@oracle.com>
References: <1269998863-13413-1-git-send-email-srinivas.eeda@oracle.com>
	<4BB399C7.8000009@oracle.com>
Message-ID: <4BB39C9B.4020207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Can you also provide a snippet of the messages after some mounts
and umounts.

Sunil Mushran wrote:
> KERN_INFO is a good idea. But the message is a mouthful.
>
> Currently it reads:
> "node %s (num %u) at %u.%u.%u.%u:%u socket state changed to X. Shutting 
> down the socket connection"
>
> How about this:
> "o2net: connection to node %s (num %u) at %u.%u.%u.%u:%u shutdown, state %d"
>
> printk(KERN_INFO "connection to " SC_NODEF_FMT " shutdown, state %d" ....);
>
> Sunil
>
>
> Srinivas Eeda wrote:
>   
>> This patch logs socket state changes that lead to socket shutdown.
>>
>> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
>> ---
>>  fs/ocfs2/cluster/tcp.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
>> index 334f231..6d0d228 100644
>> --- a/fs/ocfs2/cluster/tcp.c
>> +++ b/fs/ocfs2/cluster/tcp.c
>> @@ -583,6 +583,9 @@ static void o2net_state_change(struct sock *sk)
>>  			o2net_sc_queue_work(sc, &sc->sc_connect_work);
>>  			break;
>>  		default:
>> +			printk(KERN_INFO SC_NODEF_FMT " socket state"
>> +			      " changed to %d. Shutting down the socket "
>> +			      "connection\n", SC_NODEF_ARGS(sc), sk->sk_state);
>>  			o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
>>  			break;
>>  	}
>>     
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
