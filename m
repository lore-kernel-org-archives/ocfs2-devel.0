From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Jan  2 19:05:31 2008
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 5/6] Modify fsck to
 trust global bitmap than super block.take 3
In-Reply-To: <20071218011410.GA23473@tma-pc1.cn.oracle.com>
References: <20071218011410.GA23473@tma-pc1.cn.oracle.com>
Message-ID: <477C50C5.9060607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> In resize, we update the global_bitmap first and then the super block.
> So if there is any corruption between these 2 steps, there will be a
> inconsistence. In kernel we use the information in global_bitmap,
> so fsck.ocfs2 should also trust it during the check.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>   
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This looks correct. However, I am still confused as to how I managed to
get clean runs when testing aborted offline resize cases.
