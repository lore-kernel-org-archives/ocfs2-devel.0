From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 23:06:37 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Wrap
 ocfs2_sysfile_cluster_lock_key within define.
In-Reply-To: <1245301926-17359-1-git-send-email-tao.ma@oracle.com>
References: <1245301926-17359-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090620060637.GE1993@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 18, 2009 at 01:12:06PM +0800, Tao Ma wrote:
> Actually ocfs2_sysfile_cluster_lock_key is only used if we enable
> CONFIG_DEBUG_LOCK_ALLOC. Wrap it so that we can avoid a building
> warning.
> fs/ocfs2/sysfile.c:53: warning: ?ocfs2_sysfile_cluster_lock_key?
> defined but not used
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This is now in the lockdep branch of ocfs2.git.

Joel

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
