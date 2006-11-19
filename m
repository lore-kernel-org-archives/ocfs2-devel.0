From: Andrew Beekhof <abeekhof@suse.de>
Date: Sun Nov 19 23:22:55 2006
Subject: [Ocfs2-devel] [patch 3/3] OCFS2 Configurable timeouts - Protocol
	changes
In-Reply-To: <20061120035723.GC30647@ca-server1.us.oracle.com>
References: <20061118073600.206222000@suse.de>
	<20061118073634.419648000@suse.de>
	<20061120035723.GC30647@ca-server1.us.oracle.com>
Message-ID: <FD8E5255-82A8-4A19-B555-D74B20F0B603@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Nov 20, 2006, at 4:57 AM, Mark Fasheh wrote:

> On Sat, Nov 18, 2006 at 08:36:03AM +0100, abeekhof@suse.de wrote:
>> The addition of two dummy fields is a temporary measure to
>>    satisfy the logic in o2net_check_handshake() and will be
>>    rectified in a future version of this patch
> Maybe I'm being silly, but I just can't seem to figure out  
> precisely which
> logic you're talking about here. Can you elaborate, please?

Sorry, I meant the logic that controlls when o2net_check_handshake()  
is called by o2net_advance_rx().

Specifically, this comment:
			/* this working relies on the handshake being
			 * smaller than the normal message header */


>> +static void o2net_initialize_handshake(void)
>> +{
>> +	static int initialized = 0;
>> +	if(initialized)
>> +		return;
>> +
>> +	initialized = 1;
>> +	o2net_hand->o2net_idle_timeout_ms = cpu_to_be32(
>> +		o2net_idle_timeout(NULL));
>> +	o2net_hand->o2net_keepalive_delay_ms = cpu_to_be32(
>> +		o2net_keepalive_delay(NULL));
>> +	o2net_hand->o2net_reconnect_delay_ms = cpu_to_be32(
>> +		o2net_reconnect_delay(NULL));
>> +}
> We should populate o2hb_heartbeat_timeout_ms here.

is a constant ok?  I left out all other references to heartbeat  
timeouts.

> Checking against it in
> o2net_check_handshake() would also be good.
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
> Senior Software Developer, Oracle
> mark.fasheh@oracle.com

--
Andrew Beekhof

"Would the last person to leave please turn out the enlightenment?" -  
TISM
