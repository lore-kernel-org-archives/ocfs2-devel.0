From: Li Zefan <lizefan@huawei.com>
Date: Fri, 22 Nov 2013 09:33:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free allocated clusters if error
 occurs after ocfs2_claim_clusters
In-Reply-To: <528E03CC.1010900@huawei.com>
References: <528E03CC.1010900@huawei.com>
Message-ID: <528EB466.1030804@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/11/21 20:59, Joseph Qi wrote:
> From: Zongxun Wang <wangzongxun@huawei.com>
> 
> Even if using the same jbd2 handle, we cannot rollback a transaction.
> So once some error occurs after successfully allocating clusters, the
> allocated clusters will never be used and it means they are lost.
> For example, call ocfs2_claim_clusters successfully when expanding a
> file, but failed in ocfs2_insert_extent.
> So we need free the allocated clusters if they are not used indeed.
> 
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Signed-off-by: Zongxun Wang <wangzongxun@huawei.com>

You must also sign the patch.
