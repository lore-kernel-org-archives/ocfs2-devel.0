From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 18 May 2015 14:14:12 +0800
Subject: [Ocfs2-devel] NULL pointer dereference in function
	ocfs2_abort_trigger
Message-ID: <55598334.8020902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
Function ocfs2_abort_trigger() use bh->b_assoc_map to get super block.
But I cannot find any function to set bh->b_assoc_map in ocfs2.
So it will trigger NULL pointer dereference while calling this
function.

I am wonder that whether function t_abort->ocfs2_abort_trigger() can be
deleted from ocfs2.

Thanks very much.
