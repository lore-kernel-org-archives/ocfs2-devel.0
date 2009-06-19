From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 14:59:07 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Do not initialize lvb in
 ocfs2_orphan_scan_lock_res_init()
In-Reply-To: <1245447958-12996-4-git-send-email-sunil.mushran@oracle.com>
References: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
	<1245447958-12996-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090619215907.GF29140@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 02:45:57PM -0700, Sunil Mushran wrote:
> No need to call ocfs2_dlm_lvb() in ocfs2_orphan_scan_lock_res_init().

	Needs a description of how we init the LVB when it's not yet
valid.

> +	/*
> +	 * TODO: Add handling for different lvb versions. It is blocked
> +	 * on being able to detect valid lvb via stackglue.
> +	 */

	This isn't true, so let's drop it.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
