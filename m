From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 19 Jan 2015 01:03:47 -0800
Subject: [Ocfs2-devel] [PATCH 05/17] ocfs2: Use generic helpers for
	quotaon and quotaoff
In-Reply-To: <1421412471-4747-6-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-6-git-send-email-jack@suse.cz>
Message-ID: <20150119090347.GE27474@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 16, 2015 at 01:47:39PM +0100, Jan Kara wrote:
> Ocfs2 can just use the generic helpers provided by quota code for
> turning quotas on and off when quota files are stored as system inodes.
> The only difference is the feature test in ocfs2_quota_on() and that is
> covered by dquot_quota_enable() checking whether usage tracking is
> enabled (which can happen only if the filesystem has the quota feature
> set).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/super.c | 32 +-------------------------------
>  1 file changed, 1 insertion(+), 31 deletions(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 83723179e1ec..706c71c2955d 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1000,36 +1000,6 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
>  	}
>  }
>  
> -/* Handle quota on quotactl */
> -static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
> -{
> -	unsigned int feature[OCFS2_MAXQUOTAS] = {
> -					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
> -					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
> -
> -	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
> -		return -EINVAL;

Where are we doing this feature check now?
