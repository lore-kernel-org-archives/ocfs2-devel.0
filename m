From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 20 Jul 2009 15:52:20 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add extra credits and access the
 modified bh in update_edge_lengths.
In-Reply-To: <1247463698-24375-1-git-send-email-tao.ma@oracle.com>
References: <1247463698-24375-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090720225220.GD7768@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 13, 2009 at 01:41:38PM +0800, Tao Ma wrote:
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

Can I get a version against mainline?  This version appears to be
against cacheme.

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
