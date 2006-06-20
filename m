From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 19 Jun 2006 22:42:19 -0700
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
In-Reply-To: <44973962.4030309@google.com>
References: <20060619234643.GK3082@ca-server1.us.oracle.com>
	<44973962.4030309@google.com>
Message-ID: <20060620054219.GA18817@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@google.com>
Cc: dhowells@redhat.com, akpm@osdl.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 19, 2006 at 04:55:14PM -0700, Daniel Phillips wrote:
> While this may be a great patch, you didn't actually explain what it does,
> how it does it or why it does it.
Essentially data in OCFS2 is already covered by a cluster lock. We simply
make use of the lock in ->page_mkwrite to ensure that data written via
shared writeable mmap will be coherent with respect to other nodes.

Cluster locks can have levels of NL (no lock), PR (protected read, aka
shared) or EX (exclusive). The act of taking the lock on one node triggers
actions on the other nodes which have competing lock levels. In the case of
locks covering inode data, this means that the other nodes will do a
combination of sync and invalidate against their pages. This is what
ocfs2_data_convert_worker() does.

So the patch just makes use of the callback to take a data lock on the
associated inode. We also take a meta data lock to verify inode size against
the page index, but I'm not completely sure that piece is absolutely
necessary as we should've already done it from ->nopage.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
