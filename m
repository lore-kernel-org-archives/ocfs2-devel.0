From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Oct 2008 23:19:13 -0700
Subject: [Ocfs2-devel] [PATCH 0/6] Refactor ocfs2_read_blocks()
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20081011061913.GA30707@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 09, 2008 at 05:20:28PM -0700, Joel Becker wrote:
> ocfs2_read_blocks() is a complex kitchen sink for almost all block
> reading in ocfs2.  Before I add logic to let callers key on whether a
> block was in cache or not, Mark and I decided it could use some cleaning
> up.

	I've now updated the patch series on top of our merge window
code.  This includes modifying xattr.c.  I've tested the regular code,
but I'm hoping Tao or Tiger or someone can help me by testing the xattrs
with this patch set.
	Since I'm not at the office, I don't have the send-email working
to well.  You can see the new series on oss at
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=read-block-cleanups

Joel

-- 

 The herd instinct among economists makes sheep look like
 independant thinkers.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
