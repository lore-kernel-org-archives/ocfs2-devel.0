From: tristan <tristan.ye@oracle.com>
Date: Fri, 30 Jul 2010 10:12:22 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] O2net: Disallow o2net accept
 connection request from itself.
In-Reply-To: <008747B0-1A7A-45E1-A8E6-DF5C61B2DA7D@oracle.com>
References: <1280401483-4756-1-git-send-email-tristan.ye@oracle.com>
	<008747B0-1A7A-45E1-A8E6-DF5C61B2DA7D@oracle.com>
Message-ID: <4C523506.8040101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> unexpected connect attempt seen at node x (num, ip:port) from node y (num, ip:port). 
>
> The above reads better, don't you think. Lower or same are software bugs. Not a user error. 

That makes sense.

>
> Btw, one test you could do is race nc with mount. Run nc in a loop while mounting the first device. nc should ping a node that has it mounted. Test with higher to lower and reverse. 

Yeah, to stress and race nc with mount is a good way to test o2net's 
listening function.

>
> On Jul 29, 2010, at 4:04 AM, Tristan Ye <tristan.ye@oracle.com> wrote:
>
>> Currently, o2net_accept_one() is allowed to accept a connection from
>> listening node itself, such a fake connection will not be successfully
>> established due to no handshake detected afterwards, and later end up
>> with triggering connecting worker in a loop.
>>
>> We're going to fix this by treating such connection request as 'invalid',
>> since we've got no chance of requesting connection from a node to itself
>> in a OCFS2 cluster.
>>
>> The fix doesn't hurt user's scan for o2net-listener, it always gets a
>> successful connection from userpace.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>> fs/ocfs2/cluster/tcp.c |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
>> index aa75ca3..7e4e451 100644
>> --- a/fs/ocfs2/cluster/tcp.c
>> +++ b/fs/ocfs2/cluster/tcp.c
>> @@ -1796,9 +1796,9 @@ static int o2net_accept_one(struct socket *sock)
>>        goto out;
>>    }
>>
>> -    if (o2nm_this_node() > node->nd_num) {
>> +    if (o2nm_this_node() >= node->nd_num) {
>>        mlog(ML_NOTICE, "unexpected connect attempted from a lower "
>> -             "numbered node '%s' at " "%pI4:%d with num %u\n",
>> +             "or same numbered node '%s' at " "%pI4:%d with num %u\n",
>>             node->nd_name, &sin.sin_addr.s_addr,
>>             ntohs(sin.sin_port), node->nd_num);
>>        ret = -EINVAL;
>> -- 
>> 1.5.5
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
