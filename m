From: Manish Singh <manish.singh@oracle.com>
Date: Mon Feb  9 23:45:58 2004
Subject: [Ocfs2-devel] [PATCH][2.6 PORT] more ocfs.h cleanup
In-Reply-To: <20040209214559.GA2131@penguin.co.intel.com>
References: <200402092045.i19KjlKM000935@penguin.co.intel.com>
	<20040209214559.GA2131@penguin.co.intel.com>
Message-ID: <20040210054552.GA6140@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 09, 2004 at 01:45:59PM -0800, Rusty Lynch wrote:
> On Mon, Feb 09, 2004 at 12:45:47PM -0800, Rusty Lynch wrote:
> > The following is a patch that cleans up src/inc/ocfs.h in another step
> > towards a port to the 2.6 kernel.
> 
> Just got access to an ia64 machine and discovered that my last patch
> moved the ia64 defines for prefetch and friends down too low (so
> the warning messages talked about in the top comment come back.)
> 
> This version corrects the problem.

Looks good, I just applied it.

Thanks,
-Manish
