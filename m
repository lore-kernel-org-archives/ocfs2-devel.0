From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 17 Mar 2020 08:58:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: the parent directory reference
 count should be increased only after the ocfs2_add_entry function is
 successfully called
In-Reply-To: <29f65849-c84a-ba02-5a2d-705762807765@huawei.com>
References: <27b32a04-d3f5-4a14-ec0e-11816c42c9a2@huawei.com>
	<c12a7ca0-ced4-74f2-54d0-4b841d6b773a@linux.alibaba.com>
	<29f65849-c84a-ba02-5a2d-705762807765@huawei.com>
Message-ID: <0bad4fdb-2bbf-35ea-7a30-bff82524d339@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/3/16 15:27, wangjian wrote:
> good suggestion. Can we just move the three statements ocfs2_add_links_count (dirfe, 1),
> ocfs2_journal_dirty (handle, parent_fe_bh), inc_nlink (dir) to the following?
> This seems to be no problem. Or reset the reference count back in case of failure?
> 
IMO, rollback the link modification in error handling may be a better choice.

Thanks,
Joseph
