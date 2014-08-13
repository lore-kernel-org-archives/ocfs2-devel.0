From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Aug 2014 12:05:15 -0700
Subject: [Ocfs2-devel] [patch 04/10] ocfs2: o2net: set tcp user timeout
	to max value
In-Reply-To: <53e290c7.CpvTdt/ZlZEYmIIE%akpm@linux-foundation.org>
References: <53e290c7.CpvTdt/ZlZEYmIIE%akpm@linux-foundation.org>
Message-ID: <20140813190515.GX2203@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 06, 2014 at 01:32:07PM -0700, Andrew Morton wrote:
> From: Junxiao Bi <junxiao.bi@oracle.com>
> Subject: ocfs2: o2net: set tcp user timeout to max value
> 
> When tcp retransmit timeout(15mins), the connection will be closed. 
> Pending messages may be lost during this time.  So we set tcp user timeout
> to override the retransmit timeout to the max value.  This is OK for ocfs2
> since we have disk heartbeat, if peer crash, the disk heartbeat will
> timeout and it will be evicted, if disk heartbeat not timeout and
> connection idle for a long time, then this means the cluster enters
> split-brain state, since fence can't happen, we'd better keep the
> connection and wait network recover.

That's a heck of a timeout :(

I don't think there's much we can do though with this cluster stack if we
get into a (true) split brain situation though so this is probably better
than losing messages and crashing the whole thing.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>


--
Mark Fasheh
