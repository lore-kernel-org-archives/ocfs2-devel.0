From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sat Jun 23 10:24:06 2007
Subject: [Ocfs2-devel] Re: [-mm PATCH] ocfs2: ->fallocate() support
In-Reply-To: <20070623095415.6fba0f73.akpm@linux-foundation.org>
References: <20070621190143.GC17713@ca-server1.us.oracle.com>
	<20070623095415.6fba0f73.akpm@linux-foundation.org>
Message-ID: <20070623172402.GF17713@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aarora@in.ibm.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sat, Jun 23, 2007 at 09:54:15AM -0700, Andrew Morton wrote:
> > On Thu, 21 Jun 2007 12:01:43 -0700 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> > Plug ocfs2 into the ->fallocate() callback. We only support FA_ALLOCATE for
> > now - FA_DEALLOCATE will come later.
> 
> I get a healthy reject when applying this against your own tree.  Perhaps
> because my copy of it is a few days old, dunno.

Eek, yeah I based it on a pretty recent version of my stuff.


> I think I'll duck it, allow you to merge this in the normal fashion once
> fallocate hits mainline, OK?

Sounds good to me. Could I trouble you to add me to the CC for one of the
patches that add ->fallocate() so I know when it gets sent upstream?

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
