From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan  3 14:52:35 2008
Subject: [Ocfs2-devel] [PATCH 0/7] ocfs2: extended slot map
In-Reply-To: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
References: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20080103225210.GM23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, all of these look good.
	--Mark

On Thu, Jan 03, 2008 at 01:40:18PM -0800, Joel Becker wrote:
> ocfs2 has a system file called "slot_map".  A "slot" is a collection of
> files local to particular mounted node, including the journal and
> allocators that node is using.  The slot map converts the slot number to
> a node number, so when a node dies, ocfs2 knows which slot to recover.
> 
> The old ocfs2 slot map is a very limited.  It has a physical maximum of
> 254 entries - specifically, it must fit within one disk block.  It only
> allows node numbers up to 254, and cannot be extended past INT16_MAX
> (32767).  This is a problem in the world of userspace cluster stacks,
> where the node numbers are often sparse and can be up to UINT32_MAX.
> 
> It also has the structural problem that empty slots are signified by a
> magic number.  That number happens to be -1 (0xFFFF).  It makes for code
> that isn't as obvious as one would like.
> 
> Thus, we introduce a new slot map format, referred to hence as the
> "extended slot map".  The extended slot map is allocated as regular file
> space, and so is bound by i_size.  The new format adds a "valid" field,
> distinct from the node number.  Finally, it has room for extension
> should it be needed.
> 
> The kernel patches follow this email.  These patches rely on a
> couple of cleanups that are in the 'cluster_abstractions' branch of
> ocfs2.git.  The cleanup patches are not part of the email thread, but are
> part of my git repository.
> 
> The kernel code is available on the 'new-slot-map' branch of my git
> repository.
> 
> View:
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=new-slot-map
> Pull:
> git pull git://oss.oracle.com/git/jlbec/linux-2.6.git new-slot-map
> 
> The tools code is also available via git, in the 'new-slot-map' branch
> as well.
> 
> View:
> http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=new-slot-map
> Pull:
> git pull git://oss.oracle.com/git/ocfs2-tools.git new-slot-map
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
