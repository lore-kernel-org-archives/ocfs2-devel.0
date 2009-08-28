From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 28 Aug 2009 14:49:43 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <4A9789E5.9090205@oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
	<20090828011018.GG18962@mail.oracle.com>
	<4A973D1D.70500@oracle.com>
	<20090828053911.GB19658@mail.oracle.com>
	<4A978098.60306@oracle.com>
	<20090828073359.GC19658@mail.oracle.com>
	<4A9789E5.9090205@oracle.com>
Message-ID: <20090828214943.GB29312@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 28, 2009 at 03:40:21PM +0800, Wengang Wang wrote:
> Ok. Then I will pick up the mlog_error()s and mlog(ERR...)s and re-post 
> later...

	Sounds good.
	If the area of logging interests you, would you take a stab at
adding tracepoints to ocfs2?  Mainline has a generic infrastructure for
"tracepoints" that can be dropped in nicely in code and don't have to be
printk()d.  Debugfs files can be used to enable them or disable them as
a group or individually, so we could even just say "only trace
ocfs2_new_inode".  The tracing can be filtered by pid or by function,
too.
	See Documentation/trace/tracepoints.txt for a little overview,
but really look at include/trace/events/ext4.h and the associated calls
in fs/ext4.  I'd love to see a small include/trace/events/ocfs2.h to
start.  Maybe just give aio_write and aio_read callers or something.
Just so there is a nice example for others to follow.
include/trace/events/o2dlm.h would be cool too, we could trace locking
calls.
	Feel free to ask me any questions.

Joel


-- 

Life's Little Instruction Book #314

	"Never underestimate the power of forgiveness."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
