From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 15 Dec 2009 15:53:42 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: add trace event log to alloc.c
In-Reply-To: <200911261218.nAPMpBYX026104@rgminet15.oracle.com>
References: <200911261218.nAPMpBYX026104@rgminet15.oracle.com>
Message-ID: <20091215235342.GA21998@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 26, 2009 at 08:15:32PM +0800, Wengang Wang wrote:
> this patche adds trace event log to alloc.c.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Hey Wengang,
	Sorry I didn't respond sooner and left you hanging.  This is
good work.  Thank you for taking this on.
	Unfortunately, it brought up another problem.  The tracing
infrastructure is not on el5.  If we apply your patches to mainline,
we'll have an awful time backporting anything to 1.6, because mainline
will have trace_* functions and 1.6 will have mlog functions.  Not your
fault, of course.
	The easy solution is to hold off until el6 comes out.  el6 will
have the tracing code.  Another possibility is to fake the tracing
infrastructure in 1.6.  We haven't come up with a sane way to do that
yet.  So for now, we're going to hold off.
	Please keep these patches handy.  We'll be using them when the
time comes.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
