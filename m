From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 20 Jan 2016 17:18:06 +0800
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
In-Reply-To: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <569F50CE.10009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,
Thanks for the patch set.
In case only one node storage link down, if this node doesn't fence
self, other nodes will still check and mark this node dead, which will
cause cluster membership inconsistency.
In your patch set, I cannot see any logic to handle this. Am I missing
something?

On 2016/1/20 11:13, Junxiao Bi wrote:
> Hi,
> 
> This serial of patches is to fix the issue that when storage down,
> all nodes will fence self due to write timeout.
> With this patch set, all nodes will keep going until storage back
> online, except if the following issue happens, then all nodes will
> do as before to fence self.
> 1. io error got
> 2. network between nodes down
> 3. nodes panic
> 
> Junxiao Bi (6):
>       ocfs2: o2hb: add negotiate timer
>       ocfs2: o2hb: add NEGO_TIMEOUT message
>       ocfs2: o2hb: add NEGOTIATE_APPROVE message
>       ocfs2: o2hb: add some user/debug log
>       ocfs2: o2hb: don't negotiate if last hb fail
>       ocfs2: o2hb: fix hb hung time
> 
>  fs/ocfs2/cluster/heartbeat.c |  181 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 175 insertions(+), 6 deletions(-)
> 
>  Thanks,
>  Junxiao.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
