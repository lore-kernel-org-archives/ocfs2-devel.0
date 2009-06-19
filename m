From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Jun 2009 16:02:58 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Provide the ocfs2_dlm_lvb_valid()
	stack API. v2 stack API.
In-Reply-To: <20090619224047.GK29140@mail.oracle.com>
References: <20090619221921.GH29140@mail.oracle.com>
	<20090619224047.GK29140@mail.oracle.com>
Message-ID: <20090619230258.GT10980@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 03:40:47PM -0700, Joel Becker wrote:
> Changes from v1:
> - I totally failed to use the API in dlmglue.c!
> 
> The Lock Value Block (LVB) of a DLM lock can be lost when nodes die and
> the DLM cannot reconstruct its state.  Clients of the DLM need to know
> this.
> 
> ocfs2's internal DLM, o2dlm, explicitly zeroes out the LVB when it loses
> track of the state.  This is not a standard behavior, but ocfs2 has
> always relied on it.  Thus, an o2dlm LVB is always "valid".
> 
> ocfs2 now supports both o2dlm and fs/dlm via the stack glue.  When
> fs/dlm loses track of an LVBs state, it sets a flag
> (DLM_SBF_VALNOTVALID) on the Lock Status Block (LKSB).  The contents of
> the LVB may be garbage or merely stale.
> 
> ocfs2 doesn't want to try to guess at the validity of the stale LVB.
> Instead, it should be checking the VALNOTVALID flag.  As this is the
> 'standard' way of treating LVBs, we will promote this behavior.
> 
> We add a stack glue API ocfs2_dlm_lvb_valid().  It returns non-zero when
> the LVB is valid.  o2dlm will always return valid, while fs/dlm will
> check VALNOTVALID.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

Looks great!

Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
