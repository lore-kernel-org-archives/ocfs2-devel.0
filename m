From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Mar 2017 20:31:58 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: revert hb threshold to keep
	compatible
In-Reply-To: <903c2745-edff-09d3-1db7-55996ba87d53@oracle.com>
References: <1490665245-15374-1-git-send-email-junxiao.bi@oracle.com>
	<20170328153146.da60162a5a5d02c34cdd848e@linux-foundation.org>
	<903c2745-edff-09d3-1db7-55996ba87d53@oracle.com>
Message-ID: <20170328203158.6ae7ff0e6bbff6f5bceb9a19@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 29 Mar 2017 09:07:08 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> On 03/29/2017 06:31 AM, Andrew Morton wrote:
> > On Tue, 28 Mar 2017 09:40:45 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
> > 
> >> Configfs is the interface for ocfs2-tools to set configure to
> >> kernel. Change heartbeat dead threshold name in configfs will
> >> cause compatible issue, so revert it.
> >>
> >> Fixes: 45b997737a80 ("ocfs2/cluster: use per-attribute show and store methods")
> > 
> > I don't get it.  45b997737a80 was merged nearly two years ago, so isn't
> > it a bit late to fix compatibility issues?
> > 
> This compatibility will not cause ocfs2 down, just some configure (hb
> dead threshold) lose effect. If someone want to use the new kernel, they
> should apply this fix.

Well could someone please send a better changelog?  One which carefully
describes the present behaviour, what is wrong with it and how the
patch fixes it?

One reason for doing this is to permit effecitive patch review.

Another reason is to permit others to decide whether the patch should
be backported into -stable kernels.

Yet another reason is so that maintainers of other kernels can
determine whether this patch will fix behaviour which their users are
reporting.

Thanks.
