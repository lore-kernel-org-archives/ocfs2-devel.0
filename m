From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 8 Apr 2014 12:42:41 -0700
Subject: [Ocfs2-devel] [patch 03/11] ocfs2/o2net: incorrect to terminate
	accepting	connections loop upon rejecting an invalid one
In-Reply-To: <534367FD.8060403@oracle.com>
References: <20140124204702.9871031C2C7@corp2gmr1-1.hot.corp.google.com>
	<20140124215554.GC24361@wotan.suse.de>
	<52E2E7C1.7070801@oracle.com>
	<20140319140143.b3a0fa14b49284fb79c1bd61@linux-foundation.org>
	<534367FD.8060403@oracle.com>
Message-ID: <20140408194241.GR4488@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 07, 2014 at 08:07:41PM -0700, Tariq Saeed wrote:
>>>>> diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one fs/ocfs2/cluster/tcp.c
>>>>> --- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one
>>>>> +++ a/fs/ocfs2/cluster/tcp.c
>>>>> @@ -1826,7 +1826,7 @@ int o2net_register_hb_callbacks(void)
>>>>>
>>>>>    /* ------------------------------------------------------------ */
>>>>>
>>>>> -static int o2net_accept_one(struct socket *sock)
>>>>> +static int o2net_accept_one(struct socket *sock, int *more)
>>>>>    {
>>>>>    	int ret, slen;
>>>>>    	struct sockaddr_in sin;
>>>>> @@ -1837,6 +1837,7 @@ static int o2net_accept_one(struct socke
>>>>>    	struct o2net_node *nn;
>>>>>
>>>>>    	BUG_ON(sock == NULL);
>>>>> +	*more = 0;
>>>>>    	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
>>>>>    			       sock->sk->sk_protocol, &new_sock);
>>>>>    	if (ret)
>>>>> @@ -1848,6 +1849,7 @@ static int o2net_accept_one(struct socke
>>>>>    	if (ret < 0)
>>>>>    		goto out;
>>>>>
>>>>> +	*more = 1;
>>>>>    	new_sock->sk->sk_allocation = GFP_ATOMIC;
>>>>>
>>>>>    	ret = o2net_set_nodelay(new_sock);
>>>>> @@ -1949,8 +1951,15 @@ out:
>>>>>    static void o2net_accept_many(struct work_struct *work)
>>>>>    {
>>>>>    	struct socket *sock = o2net_listen_sock;
>>>>> -	while (o2net_accept_one(sock) == 0)
>>>>> +	int	more;
>>>>> +	int	err;
>>>>> +
>>>>> +	for (;;) {
>>>>> +		err = o2net_accept_one(sock, &more);
>>>>> +		if (!more)
>>>>> +			break;
>>>> We're throwing out 'err' here and trusting the variable 'more'. However, err
>>>> could be set and more would be 0 regardless of whether there actually are
>>>> more connections to be had. This makes more sense given when 'more' is set:
>>>
>>> Thanks for the comments.
>>> To understand the consequences of ignoring the err, we need to look at
>>> what is going on.
>>> We get a softIRQ when a connection packet (tcp SYN). It is critical to
>>> note that we may not
>>> get a softIRQ_for every connection s_ince connection packets can arrive
>>> back-to-back (as happened in this bug). So, one softIRQ could be
>>> delivered for > 1 pending accept.
>>> _This is the KEY point. _
>>>
>>> If we terminate the loop calling o2net_accept_one() upon seeing an
>>> error, what happens
>>> to the rest of the connections in the queue. If no new connection
>>> arrives for hours, no new softIRQ
>>> will be delivered, and the connections will just sit in the queue.
>>
>> Please note that I had to edit your email to undo the top-posting so I
>> could reply to it.  Please don't top-post.
>>
>> Mark, are you now OK with the patch as-is?
> Mark, do you have further questios?

No but we're going to need a comment explaining this above the code in
question. It's not entirely clear just by reading it.
	--Mark

--
Mark Fasheh
