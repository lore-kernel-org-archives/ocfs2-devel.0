From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 3 Nov 2008 23:40:40 -0800
Subject: [Ocfs2-devel] [PATCH 02/15] ocfs2: Add clusters free
	in	dealloc_ctxt.
In-Reply-To: <20081104030157.GC16483@mail.oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-2-git-send-email-tao.ma@oracle.com>
	<20081104011652.GH22137@mail.oracle.com>
	<490FA6B0.5010303@oracle.com>
	<20081104030157.GC16483@mail.oracle.com>
Message-ID: <20081104074040.GA27901@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 03, 2008 at 07:01:57PM -0800, Joel Becker wrote:
> 	Your 64K can be 16 clusters at a 4K cluster size.  That's 16
> records.  What if the truncate log had only space for three records from
> a previous operation?  Your fourth call to ocfs2_truncate_log_append()
> will mlog_bug_on_msg() like so:
> 
> 5319         mlog_bug_on_msg(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
> 
> 	That is not acceptable.  We don't introduce known bugs and say
> they are OK if they are rare.

	I want to clarify what I'm talking about here.
	There are a few places in ocfs2 where we can't clean up from an
error perfectly.  A recent example was in truncate.  In
ocfs2_do_truncate(), we can possibly get an error like -EIO or -ENOMEM
inside ocfs2_trim_tree().  If that happens, the inode will have more
clusters allocated to it than specified by ip_clusters.  Since there is
no easy way to either complete the truncate or restore the allocation,
we leave the inode as-is.  The allocation code is taught to handle the
case where i_clusters is smaller than the actual allocated number.
	The key fact is that the error is an unexpected case.  -EIO
happens because the disk array went offline or there was a bad sector.
It's not part of normal operation.  Even with it not being part of
normal operation, the filesystem can continue normal operations.  There
is no corruption, no BUG() is tripped, and if the rest of the disk is
fine, things continue to work.
	In the code above, adding records to the truncate log is normal
operation.  The truncate log can be almost full as a part of normal
operation.  Thus, it should never cause an error or a crash.

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
