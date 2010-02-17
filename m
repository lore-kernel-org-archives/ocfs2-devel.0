From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 17 Feb 2010 10:24:30 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message
	protocol
In-Reply-To: <20100217055641.GI13798@mail.oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
	<1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>
	<20100217055641.GI13798@mail.oracle.com>
Message-ID: <4B7C345E.6000504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Each node that has this patch would send a O2NET_MSG_KEEP_REQ_MAGIC 
every 2 seconds(default). So, nodes without this patch would always 
receive a heartbeat message every 2 seconds.

Nodes without this patch will send(respond) with 
O2NET_MSG_KEEP_RESP_MAGIC for every keep alive packet they received. So 
nodes with this patch will always receive a response message.

So, in a mixed setup, both nodes will always hear the heartbeat from 
each other :).

thanks,
--Srini



Joel Becker wrote:
> On Thu, Jan 28, 2010 at 08:51:11PM -0800, Srinivas Eeda wrote:
>   
>>  		case O2NET_MSG_KEEP_REQ_MAGIC:
>> -			o2net_sendpage(sc, o2net_keep_resp,
>> -				       sizeof(*o2net_keep_resp));
>> +			/* Each node now sends keepalive message every
>> +			 * keepalive time interval. Hence no need for response
>> +			 */
>>  			goto out;
>>     
>
> 	You still have to send the response.  Think about a mixed
> environment where some nodes have this fix and some do not.  The older
> software is still waiting on the response.
> 	The newer version can just ignore any responses it gets from
> other nodes.  But it has to send responses out just in case the other
> node is older.
> 	The only other alternative is to bump the o2net protocol
> version, and that means the cluster has to be shut down to upgrade.  Not
> a good choice.
>
> Joel
>
>   
