From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Aug  6 18:46:44 2004
Subject: [Ocfs2-devel] [patch] fix bug 53--- Disk usage status reported in
	"df" is incorrect
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8405167BD3@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8405167BD3@pdsmsx403>
Message-ID: <20040806234635.GW8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 07, 2004 at 06:05:50AM +0800, Ling, Xiaofeng wrote:
> This is bug for 2.6 kernel.
Cool, I've been meaning to track that one down...
 
> ------------------------------------------------------------------------
> --------------------
> Index: super.c
> ===================================================================
> --- super.c     (revision 1331)
> +++ super.c     (working copy)
> @@ -757,6 +757,8 @@
>                             reserved_bits);
>         buf->f_bfree =
>             (sector_t) (freebits * (osb->s_clustersize >>
> osb->sb->s_blocksize_bits));
gah, your mailer mangled this patch! It was tiny so I just did it by hand...
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
