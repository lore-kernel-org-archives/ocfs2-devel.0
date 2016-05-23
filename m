From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 23 May 2016 16:40:30 -0700
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
In-Reply-To: <20160523145010.2e7f606d0db552d529d9253e@linux-foundation.org>
References: <1456905372-22313-1-git-send-email-junxiao.bi@oracle.com>
	<20160523145010.2e7f606d0db552d529d9253e@linux-foundation.org>
Message-ID: <20160523234030.GP7633@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 23, 2016 at 02:50:10PM -0700, Andrew Morton wrote:
> On Wed,  2 Mar 2016 15:56:06 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
> > 
> > Hi Mark,
> > 
> > This serial of patches is to fix the issue that when storage down,
> > all nodes will fence self due to write timeout.
> > With this patch set, all nodes will keep going until storage back
> > online, except if the following issue happens, then all nodes will
> > do as before to fence self.
> > 1. io error got
> > 2. network between nodes down
> > 3. nodes panic
> 
> Guys, can we please do a quick triple-check on this series?  I'd like
> to unload them this week.  Thanks.
> 
> I'll send out the current version in a few secs.

I'll go through them and give my review.

Thanks,
	--Mark


--
Mark Fasheh
