From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 22 Feb 2011 18:21:40 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/cluster: Heartbeat mismatch
 message improved
In-Reply-To: <20110222093427.GG30966@noexit>
References: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
	<20110222093427.GG30966@noexit>
Message-ID: <4D646F34.5040201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 02/22/2011 01:34 AM, Joel Becker wrote:
> On Mon, Feb 21, 2011 at 02:25:24PM -0800, Sunil Mushran wrote:
>> If o2hb finds unexpected values in the heartbeat slot, it prints a message
>> "ERROR: Device "dm-6": another node is heartbeating in our slot!"
>>
>> This patch adds more information allowing us to see the actual mismatch.
>> The new message reads "ERROR: Heartbeat mismatch on "dm-6": expected(92:0x234543,
>> 0x76567) ondisk(92:0x234543, 0x76565)"
> 	Can you still say 'another node is heartbeating in our slot',
> just with the detail?  The new message doesn't give a clue as to what is
> happening.

OK. I'll improve on the message.
