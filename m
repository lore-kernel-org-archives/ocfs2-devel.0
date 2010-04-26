From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 25 Apr 2010 23:54:26 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Make ocfs2_extend_trans really
	extending.
In-Reply-To: <1272263697-5701-1-git-send-email-tao.ma@oracle.com>
References: <20100423204545.GB10637@mail.oracle.com>
	<1272263697-5701-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100426065424.GA17377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 26, 2010 at 02:34:57PM +0800, Tao Ma wrote:
> >From c9dc26549b429eede9e47094a98b067bd5cd23b1 Mon Sep 17 00:00:00 2001
> From: Tao Ma <tao.ma@oracle.com>
> Date: Mon, 26 Apr 2010 13:49:11 +0800
> Subject: [PATCH] ocfs2: Make ocfs2_extend_trans really extending.
> 
> In ocfs2, we use ocfs2_extend_trans to extend a journal's
> blocks. But it is designed that in case jbd2_journal_extend
> fails, it will only restart with the the new block number.
> This tends to be awkward since in most cases we want our
> original reserved blocks there and make our codes hard to
> mantain since the caller sometimes can't make sure all the
> original blocks will not be accessed and dirtied again.
> There are 15 callers of ocfs2_extend_trans in fs/ocfs2,
> and 12 of them have to add h_buffer_credits before they
> call ocfs2_extend_trans. So make it really behaves like
> extending.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

"Hey mister if you're gonna walk on water,
 Could you drop a line my way?"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
