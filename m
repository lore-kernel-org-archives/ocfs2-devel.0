From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 7 May 2010 14:09:33 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Reset xattr value size in
 cleanup_truncate.
In-Reply-To: <1273213054-1672-1-git-send-email-tao.ma@oracle.com>
References: <1273213054-1672-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100507210933.GA27987@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 07, 2010 at 02:17:34PM +0800, Tao Ma wrote:
> So this patch try to resolve it by adding the original_value_size to
> ocfs2_xa_cleanup_value_truncate and let it handle it. So xe_value_size
> will only be reset in case we want to reserve the xe entry. There is
> also a side effect that we can remove the fat comment before we set
> the xe_value_size in ocfs2_xa_prepare_entry.

	Still NAK.  There's no need for cleanup_value_truncate() to know
about this.

Joel

-- 

"When arrows don't penetrate, see...
 Cupid grabs the pistol."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
