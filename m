From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 14:47:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Add extra credits and access
 the modified bh in update_edge_lengths.
In-Reply-To: <1248162126-21507-1-git-send-email-tao.ma@oracle.com>
References: <4A656FC9.4010404@oracle.com>
	<1248162126-21507-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090721214718.GD19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 21, 2009 at 03:42:05PM +0800, Tao Ma wrote:
> In normal tree rotation left process, we will never touch the tree
> branch above subtree_index and ocfs2_extend_rotate_transaction doesn't
> reserve the credits for them either.
> 
> But when we want to delete the rightmost extent block, we have to update
> the rightmost records for all the rightmost branch(See
> ocfs2_update_edge_lengths), so we have to allocate extra credits for them.
> What's more, we have to access them also.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Hey mister if you're gonna walk on water,
 Could you drop a line my way?"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
