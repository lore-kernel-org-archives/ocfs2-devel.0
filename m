From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 15:01:57 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <1245447958-12996-5-git-send-email-sunil.mushran@oracle.com>
References: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
	<1245447958-12996-5-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090619220157.GG29140@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 02:45:58PM -0700, Sunil Mushran wrote:
> -int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
> +void ocfs2_orphan_scan_init(struct ocfs2_super *osb, int start)

	There's no need to pass 'start' here.  You already have the osb.
Check hard_readonly and mount_local in this function.

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
