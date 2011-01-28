From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 27 Jan 2011 16:05:54 -0800
Subject: [Ocfs2-devel] [PATCH 02/14] Ocfs2/refcounttree: Publicate
	couple of funcs from refcounttree.c
In-Reply-To: <1295605231-15991-3-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
	<1295605231-15991-3-git-send-email-tristan.ye@oracle.com>
Message-ID: <20110128000554.GD23899@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 21, 2011 at 06:20:19PM +0800, Tristan Ye wrote:
> The original goal of commonizing these funcs is to benefit defraging/extent_moving
> codes in the future,  based on the fact that reflink and defragmentation having
> the same Copy-On-Wrtie mechanism.
> 

This looks reasonable. You might want to note the change from struct
"ocfs2_cow_context *" in some parameters to struct "file *" though.
	--Mark

--
Mark Fasheh
