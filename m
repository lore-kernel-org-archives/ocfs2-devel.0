From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 12:44:27 -0700
Subject: [Ocfs2-devel] [patch 14/28] ocfs2: take inode lock in
	ocfs2_iop_set/get_acl()
In-Reply-To: <55de39ad.N03/N28MqAInBiTy%akpm@linux-foundation.org>
References: <55de39ad.N03/N28MqAInBiTy%akpm@linux-foundation.org>
Message-ID: <20150831194427.GT1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:57PM -0700, Andrew Morton wrote:
> From: Tariq Saeed <tariq.x.saeed@oracle.com>
> Subject: ocfs2: take inode lock in ocfs2_iop_set/get_acl()
> 
> Orabug: 20189959
> 
> This bug in mainline code is pointed out by Mark Fasheh.  When
> ocfs2_iop_set_acl() and ocfs2_iop_get_acl() are entered from VFS layer,
> inode lock is not held.  This seems to be regression from older kernels. 
> The patch is to fix that.
> 
> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thank you for fixing this Tariq,

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
