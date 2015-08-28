From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:27:12 -0700
Subject: [Ocfs2-devel] [patch 08/28] ocfs2: add ip_alloc_sem in direct
 IO to protect allocation changes
In-Reply-To: <55de399c.PCB+X4ihy+Ps4440%akpm@linux-foundation.org>
References: <55de399c.PCB+X4ihy+Ps4440%akpm@linux-foundation.org>
Message-ID: <20150828232712.GM1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:40PM -0700, Andrew Morton wrote:
> From: WeiWei Wang <wangww631@huawei.com>
> Subject: ocfs2: add ip_alloc_sem in direct IO to protect allocation changes
> 
> In ocfs2, ip_alloc_sem is used to protect allocation changes on the node. 
> In direct IO, we add ip_alloc_sem to protect date consistent between
> direct-io and ocfs2_truncate_file race (buffer io use ip_alloc_sem
> already).  Although inode->i_mutex lock is used to avoid concurrency of
> above situation, i think ip_alloc_sem is still needed because protect
> allocation changes is significant.
> 
> Other filesystem like ext4 also uses rw_semaphore to protect data
> consistent between get_block-vs-truncate race by other means, So
> ip_alloc_sem in ocfs2 direct io is needed.
> 
> Signed-off-by: Weiwei Wang <wangww631@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
