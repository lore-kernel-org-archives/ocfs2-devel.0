From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 18 May 2010 11:50:35 -0700
Subject: [Ocfs2-devel] [PATCH 2/4] Ocfs2: Fix punching hole codes to
	correctly do CoW during cluster zeroing.
In-Reply-To: <1273571685-28000-3-git-send-email-tristan.ye@oracle.com>
References: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
	<1273571685-28000-3-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100518185035.GI20644@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 11, 2010 at 05:54:43PM +0800, Tristan Ye wrote:
> Based on the former patch of truncating optimization, bugfix for refcount on
> punching holes can be fairly easy and straightforward since most of work we
> should take into account for refcounting have been completed already in func
> ocfs2_remove_btree_range(), which is also being used by our truncating codes.
> 
> The patch just did CoW for reflinks when a hole is being punched whose start
> and end offset were within one cluster, which means partial zeroing for a cluster
> will be performed soon.
> 
> The patch has been tested fixing the following bug:
> 
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1216
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
