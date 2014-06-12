From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 12 Jun 2014 14:03:43 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: o2net: fix packets lost issue
 when reconnect
In-Reply-To: <53912503.6080601@oracle.com>
References: <1400127983-9774-1-git-send-email-junxiao.bi@oracle.com>
	<53912503.6080601@oracle.com>
Message-ID: <20140612140343.7201433872030fc38d46979c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 06 Jun 2014 10:18:43 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Hi Mark & Andrew,
> 
> Could you help review this patch list?

It's old and we're getting badly behind on ocfs2 reviewing - please
resend everything to everyone.  Be sure to cc Joseph Qi as he has
already commented on the patches.

> This bug can be saw when network state go bad. It may cause ocfs2 hung
> forever if some packets lost. With this fix, ocfs2 will recover from
> hung if network becomes good.

um, I don't think I knew this from the original changelogs.  This is
important information - in fact it's the *most* important information. 
Be sure to describe the bug's impact very carefully: under what
circumstances it occurs, what its effects are, etc.
