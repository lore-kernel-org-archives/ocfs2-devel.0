From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 12 May 2008 17:42:42 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Add OCFS2_FS_STATS config
	option
In-Reply-To: <1210269421-10192-1-git-send-email-sunil.mushran@oracle.com>
References: <1210269421-10192-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080513004242.GE25156@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 08, 2008 at 10:57:00AM -0700, Sunil Mushran wrote:
> This patch adds the OCFS2_FS_STATS config option which will be
> used to demarcate the statistics capturing code.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/Kconfig |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index cf12c40..c264610 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -470,6 +470,14 @@ config OCFS2_FS_USERSPACE_CLUSTER
>  	  It is safe to say Y, as the clustering method is run-time
>  	  selectable.
>  
> +config OCFS2_FS_STATS
> +	bool "OCFS2 statistics"
> +	depends on OCFS2_FS
> +	default y
> +	help
> +	  This option allows some fs statistics to be captured. Enabling
> +	  this option may increase the memory consumption.

Hmm, can we get a slightly more descriptive text? Maybe an example of what
kinds of stats are exported, and expected usage - "statistics will be exported
via debugfs", etc.
	--Mark

--
Mark Fasheh
