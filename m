From: tariq saeed <tariq.x.saeed@oracle.com>
Date: Fri, 24 Jan 2014 14:22:57 -0800
Subject: [Ocfs2-devel] [patch 03/11] ocfs2/o2net: incorrect to terminate
 accepting connections loop upon rejecting an invalid one
In-Reply-To: <20140124215554.GC24361@wotan.suse.de>
References: <20140124204702.9871031C2C7@corp2gmr1-1.hot.corp.google.com>
	<20140124215554.GC24361@wotan.suse.de>
Message-ID: <52E2E7C1.7070801@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for the comments.
To understand the consequences of ignoring the err, we need to look at 
what is going on.
We get a softIRQ when a connection packet (tcp SYN). It is critical to 
note that we may not
get a softIRQ_for every connection s_ince connection packets can arrive
back-to-back (as happened in this bug). So, one softIRQ could be 
delivered for > 1 pending accept.
_This is the KEY point. _

If we terminate the loop calling o2net_accept_one() upon seeing an 
error, what happens
to the rest of the connections in the queue. If no new connection 
arrives for hours, no new softIRQ
will be delivered, and the connections will just sit in the queue.

Thanks,
-Tariq


On 1/24/2014 1:55 PM, Mark Fasheh wrote:
> On Fri, Jan 24, 2014 at 12:47:02PM -0800, akpm at linux-foundation.org wrote:
>> From: Tariq Saeed <tariq.x.saeed@oracle.com>
>> Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one
>>
>> When o2net-accept-one() rejects an illegal connection, it terminates the
>> loop picking up the remaining queued connections.  This fix will continue
>> accepting connections till the queue is emtpy.
>>
>> Addresses Orabug 17489469.
> Thanks for sending this, review comments below.
>
>
>> diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one fs/ocfs2/cluster/tcp.c
>> --- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one
>> +++ a/fs/ocfs2/cluster/tcp.c
>> @@ -1826,7 +1826,7 @@ int o2net_register_hb_callbacks(void)
>>   
>>   /* ------------------------------------------------------------ */
>>   
>> -static int o2net_accept_one(struct socket *sock)
>> +static int o2net_accept_one(struct socket *sock, int *more)
>>   {
>>   	int ret, slen;
>>   	struct sockaddr_in sin;
>> @@ -1837,6 +1837,7 @@ static int o2net_accept_one(struct socke
>>   	struct o2net_node *nn;
>>   
>>   	BUG_ON(sock == NULL);
>> +	*more = 0;
>>   	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
>>   			       sock->sk->sk_protocol, &new_sock);
>>   	if (ret)
>> @@ -1848,6 +1849,7 @@ static int o2net_accept_one(struct socke
>>   	if (ret < 0)
>>   		goto out;
>>   
>> +	*more = 1;
>>   	new_sock->sk->sk_allocation = GFP_ATOMIC;
>>   
>>   	ret = o2net_set_nodelay(new_sock);
>> @@ -1949,8 +1951,15 @@ out:
>>   static void o2net_accept_many(struct work_struct *work)
>>   {
>>   	struct socket *sock = o2net_listen_sock;
>> -	while (o2net_accept_one(sock) == 0)
>> +	int	more;
>> +	int	err;
>> +
>> +	for (;;) {
>> +		err = o2net_accept_one(sock, &more);
>> +		if (!more)
>> +			break;
> We're throwing out 'err' here and trusting the variable 'more'. However, err
> could be set and more would be 0 regardless of whether there actually are
> more connections to be had. This makes more sense given when 'more' is set:
>
> 	if (err)
> 		break;
> 	/* only trust the value of 'more' when err == 0 */
> 	if (more)
> 		break;
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140124/bd731f64/attachment.html 
