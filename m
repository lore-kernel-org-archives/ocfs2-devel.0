From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 14:57:50 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Stop orphan scan as early as
 possible during umount
In-Reply-To: <1245447958-12996-3-git-send-email-sunil.mushran@oracle.com>
References: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
	<1245447958-12996-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090619215750.GE29140@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 02:45:56PM -0700, Sunil Mushran wrote:
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -162,6 +162,9 @@ struct ocfs2_orphan_scan {
>  	struct timespec		os_scantime;  /* time this node ran the scan */
>  	u32			os_count;      /* tracks node specific scans */
>  	u32  			os_seqno;       /* tracks cluster wide scans */
> +#define ORPHAN_SCAN_ACTIVE	0
> +#define ORPHAN_SCAN_INACTIVE	1

Please make this enum ocfs2_orphan_scan_state.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
