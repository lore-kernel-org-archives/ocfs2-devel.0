From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 16 Apr 2010 03:14:31 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reset status if we want to restart
 file extension.
In-Reply-To: <1271397565-13104-1-git-send-email-tao.ma@oracle.com>
References: <1271397565-13104-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100416101431.GB25091@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 16, 2010 at 01:59:25PM +0800, Tao Ma wrote:
> In __ocfs2_extend_allocation, we will restart our file extension
> if ((!status) && restart_func). But there is a bug that the
> status is still left as -EGAIN. This is really an old bug,
> but it is masked by the return value of ocfs2_journal_dirty.
> So it show up when we make ocfs2_journal_dirty void.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	good catch.  This patch is now in the 'fixes' branch of
ocfs2.git.

Joel


-- 

"The nearest approach to immortality on Earth is a government
 bureau."
	- James F. Byrnes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
