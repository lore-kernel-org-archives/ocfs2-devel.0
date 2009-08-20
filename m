From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 20 Aug 2009 09:36:09 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add missing lock name
In-Reply-To: <1250785612-17385-1-git-send-email-jack@suse.cz>
References: <1250785612-17385-1-git-send-email-jack@suse.cz>
Message-ID: <4A8D7B79.4090001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Jan Kara wrote:
> There is missing name for NFSSync cluster lock. This makes lockdep unhappy
> because we end up passing NULL to lockdep when initializing lock key. Fix it.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/ocfs2_lockid.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
> index fcdba09..c212cf5 100644
> --- a/fs/ocfs2/ocfs2_lockid.h
> +++ b/fs/ocfs2/ocfs2_lockid.h
> @@ -108,6 +108,7 @@ static char *ocfs2_lock_type_strings[] = {
>  	[OCFS2_LOCK_TYPE_OPEN] = "Open",
>  	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
>  	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
> +	[OCFS2_LOCK_TYPE_NFS_SYNC] = "NFSSync",
>  	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
>  };
>  
>   
