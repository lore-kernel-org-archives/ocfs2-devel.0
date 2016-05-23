From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 23 May 2016 14:50:10 -0700
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
In-Reply-To: <1456905372-22313-1-git-send-email-junxiao.bi@oracle.com>
References: <1456905372-22313-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160523145010.2e7f606d0db552d529d9253e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed,  2 Mar 2016 15:56:06 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> 
> Hi Mark,
> 
> This serial of patches is to fix the issue that when storage down,
> all nodes will fence self due to write timeout.
> With this patch set, all nodes will keep going until storage back
> online, except if the following issue happens, then all nodes will
> do as before to fence self.
> 1. io error got
> 2. network between nodes down
> 3. nodes panic

Guys, can we please do a quick triple-check on this series?  I'd like
to unload them this week.  Thanks.

I'll send out the current version in a few secs.
