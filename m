From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 May 2015 10:56:35 +0800
Subject: [Ocfs2-devel] NULL pointer dereference in function
	ocfs2_abort_trigger
In-Reply-To: <55598334.8020902@huawei.com>
References: <55598334.8020902@huawei.com>
Message-ID: <555BF7E3.2060803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/18/2015 02:14 PM, Xue jiufei wrote:
> Hi all,
> Function ocfs2_abort_trigger() use bh->b_assoc_map to get super block.
> But I cannot find any function to set bh->b_assoc_map in ocfs2.
> So it will trigger NULL pointer dereference while calling this
> function.
> 
> I am wonder that whether function t_abort->ocfs2_abort_trigger() can be
> deleted from ocfs2.
Better not, jdb2 aborted due to some error, let ocfs2 continue may cause
corruption.

Thanks,
Junxiao.

> 
> Thanks very much.
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
