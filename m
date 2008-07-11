From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 10 Jul 2008 17:15:44 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Adds counter in
	struct	ocfs2_dinode to track journal replays
In-Reply-To: <1215731871-17351-2-git-send-email-sunil.mushran@oracle.com>
References: <1215731871-17351-1-git-send-email-sunil.mushran@oracle.com>
	<1215731871-17351-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080711001544.GG11809@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 10, 2008 at 04:17:50PM -0700, Sunil Mushran wrote:
> This patch renames the ij_pad to ij_reco_generation in struct ocfs2_dinode.
> This new field will be used to keep the recovery counter that will
> be incremented each time the journal is replayed during fs recovery.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 3633edd..e0f5459 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -585,7 +585,7 @@ struct ocfs2_dinode {
>  		struct {		/* Info for journal system
>  					   inodes */
>  			__le32 ij_flags;	/* Mounted, version, etc. */
> -			__le32 ij_pad;
> +			__le32 ij_reco_generation;

+			__le32 ij_reco_generation; /* Recovery generation,
+						      incremented when the
+						      journal is recovered
+						      an unclean shutdown */

... or something.

Joel

-- 

Life's Little Instruction Book #407

	"Every once in a while, take the scenic route."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
