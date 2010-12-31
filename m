From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 31 Dec 2010 04:52:17 -0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
	mlog(0).
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <20101231125217.GC21179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 23, 2010 at 03:19:03PM +0800, Tao Ma wrote:
> This patch set is my attempt to replace our old debug(mlog) with new
> trace events.
> 
> Wengang Wang has did some work in this field about one year ago.
> http://oss.oracle.com/pipermail/ocfs2-devel/2009-September/005230.html
> But at that time we don't have ocfs2 1.6 introduced, so we delay
> this work until now after ocfs2 1.6 and UEK(Unbreakable Enterprise
> Kernel) are released.
> 
> All patches except one(see below) are only mlog related, so they
> shouldn't affect the normal operations in ocfs2 and they should be
> easy for review(patch 1-5 were already sent to the mail list around
> one month ago).
> 
> The only one that changes the codes somehow are patch 15, "ocfs2:
> Little refactoring against ocfs2_iget", but it looks
> straightforward.

Tao,
	Overall this seems pretty straightforward.  There wasn't a lot
of editing of masklog entries; we still have a million tracepoints.  I
wonder how much memory that will use.  Have you checked the space usage
of all the sysfs files for all of our tracepoints?
	Aside from my comment about marketing terms in patch comments
(hehe), I'm OK with going forward with these patches.  I would love the
ability to turn specific traces on and off.
	Well, one generic comment.  It seems a lot of our log messages
have gone from "ocfs2_foo(): Change blah 0x%p to new_blah 0x%p" to
"ocfs2_foo(): %p %p".  I wonder if that is going to be hard to read.

Joel

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
