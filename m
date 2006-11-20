From: Zach Brown <zach.brown@oracle.com>
Date: Mon Nov 20 10:39:32 2006
Subject: [Ocfs2-devel] [patch 3/3] OCFS2 Configurable timeouts - Protocol
	changes
In-Reply-To: <20061120173800.GF30647@ca-server1.us.oracle.com>
References: <20061118073600.206222000@suse.de>
	<20061118073634.419648000@suse.de>
	<20061120035723.GC30647@ca-server1.us.oracle.com>
	<FD8E5255-82A8-4A19-B555-D74B20F0B603@suse.de>
	<20061120173800.GF30647@ca-server1.us.oracle.com>
Message-ID: <456185DC.4010006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


>> Sorry, I meant the logic that controlls when o2net_check_handshake()  
>> is called by o2net_advance_rx().
>>
>> Specifically, this comment:
>> 			/* this working relies on the handshake being
>> 			 * smaller than the normal message header */
> Ahh, ok. Do you have a specific fix in mind? I've CC'd Zach - he
> might have an idea. Otherwise, I'm not really too worried about growing the
> o2net_msg structure by a little bit - we ought to rename the fields to
> something like 'reserved0' and 'reserved1' though.

The current o2net_advance_rx() is being lazy and is putting the check
for handshake negotiation inside the block which receives the message
header.  The current code will mistake a partially received handshake
header for a msg header once it exceeds the size of the message header.

The fix is easy, just hoist the handshake checking up into it's own
block before the header is received.  It'd look like the header
receiving loop, but would call _check_handshake().  It needs to be
careful not to keep trying to parse headers if it doesn't get the whole
handshake.  So something like:

if (unlikely(!handshake_ok)) {
    setup data and datalen, recv into them;
    if +ve, inc page_off
    if (page_off == sizeof(handshake))
      ret = _check_handshake()
    if (!handshake_ok)
       goto out;
}

You'd want to think harder about the return codes than I have here.

- z
