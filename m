From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 8 Jul 2010 11:51:34 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: make xattr extension work with new
 local alloc reservation.
In-Reply-To: <1276830171-5908-1-git-send-email-tao.ma@oracle.com>
References: <4C1AE141.60707@oracle.com>
	<1276830171-5908-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100708185134.GD17445@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 18, 2010 at 11:02:50AM +0800, Tao Ma wrote:
> @@ -735,8 +736,9 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
>  					     ctxt->data_ac,
>  					     ctxt->meta_ac,
>  					     &why);

	Btw, this code was already buggy.
ocfs2_xattr_extend_allocation() calls ocfs2_add_clusters_in_btree(),
which can return with RESTART_TRANS just because the filesystem is
fragmented.  We would just fail with EAGAIN in that case, which makes no
sense to a user.
	So this fix actually matters to older kernels and non-reflink
operations too.  Would you agree it should go to the stable tree?  If
so, add the Cc: to your commit message.

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
