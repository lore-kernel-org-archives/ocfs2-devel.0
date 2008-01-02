From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Jan  2 19:03:33 2008
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 4/6] Modfiy cl_cpg in
 global_bitmap to	be maximum value during mkfs.take 3
In-Reply-To: <20071218011344.GA23460@tma-pc1.cn.oracle.com>
References: <20071218011344.GA23460@tma-pc1.cn.oracle.com>
Message-ID: <477C504D.2050904@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> cl_cpg is used in ocfs2 kernel to calculate the group no
> for a given cluster. Change it to maximum number so that
> there is no need to update it durin online resize.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>   
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

At long last.
