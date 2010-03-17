From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 17 Mar 2010 12:29:36 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: set i_mode on disk during acl
 operations
In-Reply-To: <20100315223900.GZ11402@wotan.suse.de>
References: <20100315223900.GZ11402@wotan.suse.de>
Message-ID: <20100317192935.GD2930@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 15, 2010 at 03:39:00PM -0700, Mark Fasheh wrote:
> ocfs2_set_acl() and ocfs2_init_acl() were setting i_mode on the in-memory
> inode, but never setting it on the disk copy. Thus, acls were some times not
> getting propagated between nodes. This patch fixes the issue by adding a
> helper function ocfs2_acl_set_mode() which does this the right way.
> ocfs2_set_acl() and ocfs2_init_acl() are then updated to call
> ocfs2_acl_set_mode().
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
