From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 May 2014 14:03:37 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: move_extents.c: Fix to remove
 null pointer checks that could never happen
In-Reply-To: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <20140529140337.f999bfaaf9ffabce071962ea@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, 27 May 2014 22:23:51 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Removal of null pointer checks that could never happen

How do you know it never happens?

> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -904,9 +904,6 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  	struct buffer_head *di_bh = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (!inode)
> -		return -ENOENT;
> -

If it's due to assuming that the previous statement would have oopsed
then that is mistaken.  Is is sometimes the case that gcc will move the
evaluation of inode->i_sb to after the test, so this function can be
passed NULL and it will not oops.
