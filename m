From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Dec 2015 15:00:54 -0800
Subject: [Ocfs2-devel] [PATCH] NFS hangs in __ocfs2_cluster_lock due to
 race with ocfs2_unblock_lock
In-Reply-To: <5679AF1E.3020304@oracle.com>
References: <1440536130-29622-1-git-send-email-tariq.x.saeed@oracle.com>
	<5679AF1E.3020304@oracle.com>
Message-ID: <20151222150054.12cd02587301279fd89d3859@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 22 Dec 2015 12:14:22 -0800 Tariq Saeed <tariq.x.saeed@oracle.com> wrote:

> Hi,
> Looks like this fell into through the cracks. This is a very real bug
> encountered by Luminex Software and they tested the fix.
> Regards
> -Tariq
> 
> 
> -------- Forwarded Message --------
> Subject: 	[Ocfs2-devel] [PATCH] NFS hangs in __ocfs2_cluster_lock due to 
> race with ocfs2_unblock_lock

I added a cc:stable to this so it gets backported.
