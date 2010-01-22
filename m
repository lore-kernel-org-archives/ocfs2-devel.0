From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 21 Jan 2010 18:33:23 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add extent block stealing for
 ocfs2
In-Reply-To: <4B5909A5.30602@oracle.com>
References: <> <1264066975-16815-1-git-send-email-tiger.yang@oracle.com>
	<20100122014316.GB23568@mail.oracle.com>
	<4B5909A5.30602@oracle.com>
Message-ID: <20100122023323.GC23568@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 21, 2010 at 06:12:53PM -0800, Sunil Mushran wrote:
> 
> The get and set routines are a bit convoluted. I agree with the hiding 
> of the
> type by adding ocfs2_steal_meta() and  ocfs2_steal_inode(). But the get/set
> routines will be better off just accepting the type.
> 
> Right now the flow is:
> 
> ocfs2_steal_resource()
> +                       if (type == INODE_ALLOC_SYSTEM_INODE)
> +                               ocfs2_set_inode_steal_slot(osb, slot);
> 
> ocfs2_set_inode_steal_slot()
> +       return ocfs2_set_steal_slot(osb, slot, INODE_ALLOC_SYSTEM_INODE);
> 
> ocfs2_set_steal_slot()
> +       if (type == INODE_ALLOC_SYSTEM_INODE)
> +               osb->s_inode_steal_slot = slot;

	I see your point.  First, most of the slot stealing functions
don't belong in the header at all.  They're only used in suballoc.c, so
make them static there.
	The set routine is only called from ocfs2_steal_resource().  It
should take the type, because the type is already there.  The get
routines are called from other places.
	ocfs2_steal_resource() should call __ocfs2_set_steal_slot()
directly.  No need for ocfs2_set_{inode,meta}_steal_slot().  Those
should be removed.  ocfs2_steal_resource() should call
__ocfs2_get_steal_slot() directly to pass the type.  The other callers
of ocfs2_get_{inode,meta}_steal_slot() remain the same.

Joel

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
