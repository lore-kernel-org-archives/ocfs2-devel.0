From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 7 Nov 2013 05:19:48 -0800
Subject: [Ocfs2-devel] ocfs2: a dead lock case when running
 dirop_fileop_racer
In-Reply-To: <527B8392.8010807@huawei.com>
References: <527B8392.8010807@huawei.com>
Message-ID: <20131107131948.GH24799@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 07, 2013 at 08:12:02PM +0800, Joseph Qi wrote:
> We ran ocfs2 test program dirop_fileop_racer and found a dead lock case.
> 
> The case is described below.
> 2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
> /race/16/1 in the filesystem, and let the inode number of dir 16 is less
> than the inode number of dir race.
> 
> Node A                            Node B
> mv /race/16/1 /race/
>                                   right after Node A has got the
>                                   EX mode of /race/16/, and tries to
>                                   get EX mode of /race
>                                   ls /race/16/
> 
> In this case, Node A has got the EX mode of /race/16/, and wants to get
> EX mode of /race/. Node B has got the PR mode of /race/, and wants to
> get the PR mode of /race/16/. Since EX and PR are mutually exclusive,
> dead lock happens.

Interesting.  What DLM are you using, o2dlm or fs/dlm?  I would expect
that fs/dlm would do deadlock detection, but I could be wrong.

There's no way the PR on /race/ will downconvert, because there is a
reference.  We really want a signal to that PR waiting on /race/16/, but
there's no in-progress work happening on node A for that.

I suppose we could hack this to check for ancestors.  That is, rename
locks should be in ancestor order before trying inode number order.  I'm
not sure that always works, though, especially if the ancestors are not
consecutive and might also be affected by in-flight moves...

Joel

-- 

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce 

			http://www.jlbec.org/
			jlbec at evilplan.org
