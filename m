From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 12 Oct 2018 16:04:58 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up some data_ac usage
In-Reply-To: <20181011095950.drb2j3enjxizorn2@mwanda>
References: <20180907122500.azbll3byq4hdnrlw@kili.mountain>
	<20181002155317.f3d3ff3f3d4d1787b5e3121d@linux-foundation.org>
	<20181011095950.drb2j3enjxizorn2@mwanda>
Message-ID: <20181012160458.8c5e8850fe9ec673596366f9@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 11 Oct 2018 12:59:50 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:

> > >  out_commit:
> > > -	if (need_free && context->data_ac) {
> > > +	if (need_free) {
> > 
> > Current mainline is different here.
> > 
> 
> Huh...  I wrote it against linux-next, on top of commit 66897d21fa76
> ("ocfs2: fix clusters leak in ocfs2_defrag_extent()").  But now git says
> that patch was applied on Oct 4, two days later after your reply.
> 
> Anway, it should apply now again.  Would you like me to resend?

Yes please.  I've managed to lose the original email thanks to
ocfs2-devel's tendency to think it knows best about where emails should
be sent :(
