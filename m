From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 12 Nov 2008 18:59:59 -0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Introduce dir lookup helper
	struct
In-Reply-To: <1226543048-911-3-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
	<1226543048-911-3-git-send-email-mfasheh@suse.com>
Message-ID: <20081113025959.GC27602@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 12, 2008 at 06:24:06PM -0800, Mark Fasheh wrote:
> Many directory manipulation calls pass around a tuple of dirent, and it's
> containing buffer_head. Dir indexing has a bit more state, but instead of
> adding yet more arguments to functions, we introduce 'struct
> ocfs2_dir_lookup_result'. In this patch, it simply holds the same tuple, but
> future patches will add more state.

	I really like this, especially that we're fixing functions that
return in two places (via the actual return and a ** argument).  I'd be
tempted to pass the *lookup down into find_el and find_id just to
continue that pattern - but that's just me.
	Also, rename, wow :-)

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

"People with narrow minds usually have broad tongues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
