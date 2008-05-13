From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 12 May 2008 17:42:55 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Add cluster lock stats at the
	fs level
In-Reply-To: <1210269421-10192-2-git-send-email-sunil.mushran@oracle.com>
References: <1210269421-10192-1-git-send-email-sunil.mushran@oracle.com>
	<1210269421-10192-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080513004255.GF25156@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 08, 2008 at 10:57:01AM -0700, Sunil Mushran wrote:

> @@ -2461,7 +2531,11 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
>  }
>  
>  /* So that debugfs.ocfs2 can determine which format is being used */
> +#ifdef CONFIG_OCFS2_FS_STATS
> +#define OCFS2_DLM_DEBUG_STR_VERSION 2
> +#else
>  #define OCFS2_DLM_DEBUG_STR_VERSION 1
> +#endif

Why not just bump this and print zero's if CONFIG_OCFS2_FS_STATS isn't
enabled?

Rest of the patch seems fine to me.
	--Mark

--
Mark Fasheh
