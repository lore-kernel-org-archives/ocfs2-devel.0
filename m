From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 May 2010 11:41:15 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reset xattr value size after
 xa_cleanup_value_truncate.
In-Reply-To: <1273486187-1898-1-git-send-email-tao.ma@oracle.com>
References: <1273486187-1898-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100510184114.GB25670@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 10, 2010 at 06:09:47PM +0800, Tao Ma wrote:
> In ocfs2_prepare_xattr_entry, if we fail to xa_cleanup_value_truncate,
> we need to reset its value size in case we don't remove the xattr
> entry. This resolves oss bug 1247.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"It is not the function of our government to keep the citizen from
 falling into error; it is the function of the citizen to keep the
 government from falling into error."
	- Robert H. Jackson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
