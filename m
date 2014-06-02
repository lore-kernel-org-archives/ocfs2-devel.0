From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 02 Jun 2014 11:44:45 -0700
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: dir.c: Cleaning up
	uninitialized variables
In-Reply-To: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <538CC61D.2020001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

Acked-by: Srinivas Eeda <srinivas.eeda@oracle.com>

On 06/01/2014 06:53 AM, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   fs/ocfs2/dir.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 0717662..27aa4a1 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3738,7 +3738,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>   	int credits, ret, i, num_used, did_quota = 0;
>   	u32 cpos, split_hash, insert_hash = hinfo->major_hash;
>   	u64 orig_leaves_start;
> -	int num_dx_leaves;
> +	int num_dx_leaves = 0;
>   	struct buffer_head **orig_dx_leaves = NULL;
>   	struct buffer_head **new_dx_leaves = NULL;
>   	struct ocfs2_alloc_context *data_ac = NULL, *meta_ac = NULL;
