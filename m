From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 13:43:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Assign feature bits and
	system	inodes to quota feature and quota files
In-Reply-To: <1224523443220-git-send-email-jack@suse.cz>
References: <1224523443220-git-send-email-jack@suse.cz>
Message-ID: <20081021204318.GG2871@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:55PM +0200, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>

This patch actually looks fine except for one thing:

> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 4f61985..bb41c6a 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -91,7 +91,9 @@
>  					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
>  					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
>  					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK)
> -#define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
> +#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
> +					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
> +					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)

	The hunk turning on support should be the very last patch in the
series.  It doesn't matter right now as you are working on it, but when
we go to upstream we'll want all the support in place before we turn it
on.
	The rest of the patch - defining the bits and the system files,
etc, is just fine.

Joel


-- 

"People with narrow minds usually have broad tongues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
