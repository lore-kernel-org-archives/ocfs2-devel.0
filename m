From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 Aug 2009 18:49:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Wait on lockres instead of
 erroring cancel requests
In-Reply-To: <241c7a2b0908201143i3e9add05t87e2422465bc13b1@mail.gmail.com>
References: <241c7a2b0908201143i3e9add05t87e2422465bc13b1@mail.gmail.com>
Message-ID: <20090821014922.GJ10558@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 20, 2009 at 01:43:19PM -0500, Goldwyn Rodrigues wrote:
> In case a downconvert is queued, and a flock receives a signal,
> BUG_ON(lockres->l_action != OCFS2_AST_INVALID) is triggered
> because a lock cancel triggers a dlmunlock while an AST is
> scheduled.
> 
> To avoid this, allow a LKM_CANCEL to pass through, and let it
> wait on __dlm_wait_on_lockres().
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

This patch is now part of the fixes branch of ocfs2.git.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
