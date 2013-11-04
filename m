From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 3 Nov 2013 16:56:17 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] Pass ocfs2_cluster_connection
	to	ocfs2_this_node
In-Reply-To: <20131018144548.GA4589@shrek.lan>
References: <20131018144548.GA4589@shrek.lan>
Message-ID: <20131104005617.GL29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 18, 2013 at 09:45:53AM -0500, Goldwyn Rodrigues wrote:
> This is done to differentiate between using and not using controld
> and use the connection information accordingly.
> We need to be backward compatible. So, we use a new enum
> ocfs2_connection_type to identify when controld is used and when
> it is not.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/dlmglue.c    |  2 +-
>  fs/ocfs2/stack_o2cb.c |  3 ++-
>  fs/ocfs2/stack_user.c | 17 +++++++++++++++--
>  fs/ocfs2/stackglue.c  |  5 +++--
>  fs/ocfs2/stackglue.h  |  6 ++++--
>  5 files changed, 25 insertions(+), 8 deletions(-)
> 

This patch seems reasonable to me:

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
