From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 16 Jun 2016 00:03:48 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup unneeded goto in
 ocfs2_create_new_inode_locks
In-Reply-To: <576213D3.6080002@huawei.com>
References: <576213D3.6080002@huawei.com>
Message-ID: <20160616070348.GY7633@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 16, 2016 at 10:49:55AM +0800, Joseph Qi wrote:
> The last goto is unneeded, so remove it.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
