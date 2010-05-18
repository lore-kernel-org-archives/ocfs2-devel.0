From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 18 May 2010 11:50:55 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] Ocfs2: Make
	ocfs2_find_cpos_for_left_leaf() public.
In-Reply-To: <1273571685-28000-4-git-send-email-tristan.ye@oracle.com>
References: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
	<1273571685-28000-4-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100518185055.GJ20644@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 11, 2010 at 05:54:44PM +0800, Tristan Ye wrote:
> The original idea to pull ocfs2_find_cpos_for_left_leaf() out of
> alloc.c is to benefit punching-holes optimization patch, it however,
> can also be referred by other funcs in the future who want to do the
> same job.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
