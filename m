From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 28 Jun 2010 11:16:35 -0700
Subject: [Ocfs2-devel] [RFC] Add writepages in ocfs2_aops.
In-Reply-To: <1277703861-3534-1-git-send-email-tao.ma@oracle.com>
References: <1277703861-3534-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100628181635.GD10573@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 28, 2010 at 01:44:21PM +0800, Tao Ma wrote:
> On Jun 9, Dave Chinner added d87815cb2090e07b0b0b2d73dc9740706e92c80c to 
> mainline kernel which limits writeback to write the pages until we reach 
> inode->i_size during sync. But for ocfs2, it cause several problems 
> because we have dirty pages after i_size within the same cluster. So 
> this commit at least has these effect on ocfs2:
> 1. all the place we use filemap_fdatawrite in ocfs2 doesn't flush pages 
> after i_size now.
> 2. sync, fsync, fdatasync and umount don't flush pages after i_size(they 
> are called from writeback_single_inode).
> 3. reflink have a BUG_ON triggered because we have some dirty pages 
> while during CoW. http://oss.oracle.com/bugzilla/show_bug.cgi?id=1265

Tao,
	Good catch!

> I think the possible solution includes:
> 1) maybe add a new function in address_space_operations named 
> get_write_size to get it. I think it is needed for all file systems that 
> has "block size" > "page size".(But by now, it seems that only ocfs2 has 
> this? So it may not be persuasive enough?)
> 2) revert the patch(I guess it is not easy since it fix some problem 
> that generic file system has).
> 3) Use our own writepages and change wbc->range_end to the end of the 
> cluster if LLONG_MAX is used. It should be simple enough but a little 
> bit tricky.
> 4) maybe we can clear the page after extend_file? That means we only 
> clear the pages containing i_size and delay the writeback of pages 
> within the same cluster to i_size increase. I haven't dived into it 
> since it needs more change than method 3.

	Your solution papers over the problem.  As you put it, it is a
"corresponding hack to that commit."  I don't think that's how we want
to approach it.  I can imagine a future where the LLONG_MAX range
triggers special handling in the generic code that we want to take
advantage of.
	I've sent a revert request to Linus for dchinner's original
patch.  The problem has existed since 2.5; we can wait a bit longer to
fix it.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
