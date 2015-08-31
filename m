From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 12:43:25 -0700
Subject: [Ocfs2-devel] [patch 13/28] ocfs2: fix BUG_ON() in
	ocfs2_ci_checkpointed()
In-Reply-To: <55de39aa.W9GYAubwGm54CvY6%akpm@linux-foundation.org>
References: <55de39aa.W9GYAubwGm54CvY6%akpm@linux-foundation.org>
Message-ID: <20150831194325.GS1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:54PM -0700, Andrew Morton wrote:
> ocfs2_setattr must not drop inode lock ex in this code path. If it does,
> takes it again before the trans, say in ocfs2_set_acl, another cluster node can
> get in between, execute another setattr, overwriting the one in progress
> on this node, resulting in a mode acl size combo that is a mix of the two.
> 
> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>


--
Mark Fasheh
