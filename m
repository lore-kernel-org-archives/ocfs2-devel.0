From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 01:34:27 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/cluster: Heartbeat mismatch
 message improved
In-Reply-To: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
References: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110222093427.GG30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 21, 2011 at 02:25:24PM -0800, Sunil Mushran wrote:
> If o2hb finds unexpected values in the heartbeat slot, it prints a message
> "ERROR: Device "dm-6": another node is heartbeating in our slot!"
> 
> This patch adds more information allowing us to see the actual mismatch.
> The new message reads "ERROR: Heartbeat mismatch on "dm-6": expected(92:0x234543,
> 0x76567) ondisk(92:0x234543, 0x76565)"

	Can you still say 'another node is heartbeating in our slot',
just with the detail?  The new message doesn't give a clue as to what is
happening.

Joel

-- 

"The first thing we do, let's kill all the lawyers."
                                        -Henry VI, IV:ii

			http://www.jlbec.org/
			jlbec at evilplan.org
