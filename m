From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 12:39:13 -0700
Subject: [Ocfs2-devel] [patch 12/28] ocfs2: optimize error handling in
	dlm_request_join
In-Reply-To: <55de39a7.aiByz4JkQhq9VuSt%akpm@linux-foundation.org>
References: <55de39a7.aiByz4JkQhq9VuSt%akpm@linux-foundation.org>
Message-ID: <20150831193913.GR1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:51PM -0700, Andrew Morton wrote:
> From: "Norton.Zhu" <norton.zhu@huawei.com>
> Subject: ocfs2: optimize error handling in dlm_request_join
> 
> Currently error handling in dlm_request_join is a little obscure, so
> optimize it to promote readability.
> 
> If packet.code is invalid, reset it to JOIN_DISALLOW to keep it meaningful. 
> It only influences the log printing.
> 
> Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
> Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Great cleanup btw, turning that mess into a switch statement, thanks.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
