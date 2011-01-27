From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 27 Jan 2011 15:29:23 -0800
Subject: [Ocfs2-devel] [PATCH 01/14] Ocfs2/refcounttree: Fix a bug for
	refcounttree to writeback clusters in a right number.
In-Reply-To: <1295605231-15991-2-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
	<1295605231-15991-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20110127232923.GB23899@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 21, 2011 at 06:20:18PM +0800, Tristan Ye wrote:
> Current refcounttree codes actually didn't writeback the new pages out in
> write-back mode, due to a bug of always passing a ZERO number of clusters
> to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

Seems to look reasonable to me, though Joel or Tao might want to give their
own quick SOB too.

Joel: I think we want this particular patch to go upstream sooner than
later, yes?

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
