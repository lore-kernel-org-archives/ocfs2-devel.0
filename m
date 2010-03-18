From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Mar 2010 16:05:09 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Journaling i_flags and
 i_orphaned_slot when adding inode to orphan dir.
In-Reply-To: <1267428192-10106-1-git-send-email-tristan.ye@oracle.com>
References: <1267428192-10106-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100318230509.GD8122@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 01, 2010 at 03:23:11PM +0800, Tristan Ye wrote:
> +	status = ocfs2_journal_dirty(handle, fe_bh);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}

	Don't check the status of ocfs2_journal_dirty().  It can't fail.
Just call it as if it were void.

Joel

-- 

Life's Little Instruction Book #306

	"Take a nap on Sunday afternoons."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
