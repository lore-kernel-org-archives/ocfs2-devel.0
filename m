From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 26 May 2016 16:28:30 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: bump up o2cb network protocol
	version
In-Reply-To: <20160526161700.85cb45d6edf4e5de49cb4a28@linux-foundation.org>
References: <1464231615-27939-1-git-send-email-junxiao.bi@oracle.com>
	<20160526231000.GU7633@wotan.suse.de>
	<20160526161700.85cb45d6edf4e5de49cb4a28@linux-foundation.org>
Message-ID: <20160526232830.GV7633@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 26, 2016 at 04:17:00PM -0700, Andrew Morton wrote:
> On Thu, 26 May 2016 16:10:00 -0700 Mark Fasheh <mfasheh@suse.de> wrote:
> > Btw, you might want to send the whole series again as a whole so Andrew
> > knows where this is coming from and that it should be bundled with the
> > protocol changes themselves.
> > 
> 
> It's these:
> 
> ocfs2-o2hb-add-negotiate-timer.patch
> ocfs2-o2hb-add-nego_timeout-message.patch
> ocfs2-o2hb-add-negotiate_approve-message.patch
> ocfs2-o2hb-add-some-user-debug-log.patch
> ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
> ocfs2-o2hb-fix-hb-hung-time.patch
> 
> from http://ozlabs.org/~akpm/mmotm/broken-out/, isn't it?

Yes, thanks Andrew :)
	--Mark

--
Mark Fasheh
