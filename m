From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 19 Aug 2009 16:25:10 -0700
Subject: [Ocfs2-devel] [PATCH 07/41] ocfs2: Add refcount tree lock
	mechanism.
In-Reply-To: <1250576382-27080-7-git-send-email-tao.ma@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-7-git-send-email-tao.ma@oracle.com>
Message-ID: <20090819232510.GB29503@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 18, 2009 at 02:19:08PM +0800, Tao Ma wrote:
> Create a tree lock named ocfs2_refcount_tree. It protects
> all the read/write operation to the refcount tree. Also
> it has its only caching_info so that we can protect our
> own buffer_head among multiple nodes.

How about:
Implement locking around struct ocfs2_refcount_tree.  This protects all
read/write operations on refcount trees.  ocfs2_refcount_tree has its
own lock and its own caching_info, protecting buffers among multiple
nodes.

> This tree is only indicated by the root refcount block number.
> So create a rb-tree for it and store the root in ocfs2_super.

How about:
ocfs2_refcount_trees are referenced by the block number of the refcount
tree root block, So we create an rb-tree on the ocfs2_super to look them
up.

> +void ocfs2_purge_refcount_tree(struct ocfs2_super *osb)

	Let's call it ocfs2_purge_refcount_trees() in the plural.

Joel

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our overnment."
	- Sissy Farenthold

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
