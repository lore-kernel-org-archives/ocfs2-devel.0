From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 02:09:54 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: fix for nfs getting
	stale	inode.
In-Reply-To: <490036DC.8000406@oracle.com>
References: <200810230419.m9N4JLpn012453@localhost.localdomain>
	<20081023081650.GA1580@mail.oracle.com>
	<490036DC.8000406@oracle.com>
Message-ID: <20081023090954.GC1580@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 23, 2008 at 04:33:32PM +0800, wengang wang wrote:
> Joel Becker wrote:
> > 	What's the problem other than ESTALE?  That's perfectly valid in
> > the world of NFS.
> >
> >   
> ESTALE is not a big problem, what is important is that:
> it cause kernel panic during ocfs2_meta_lock_update() at later 
> operations when it updates metadata from disk.

	This is the bug.  Why is a stale inode getting meta_lock called
against it?  That's what we should be preventing, no?

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
