From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 4 Aug 2015 17:03:54 +0800
Subject: [Ocfs2-devel] [PATCH 0/9 v6] ocfs2: support append O_DIRECT
	write
In-Reply-To: <55C058D6.9030809@oracle.com>
References: <55C058D6.9030809@oracle.com>
Message-ID: <55C07FFA.4060701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Ryan,

On 2015/8/4 14:16, Ryan Ding wrote:
> Hi Joseph,
> 
> Sorry for bothering you with the old patches. But I really need to know what this patch is for.
> 
> https://oss.oracle.com/pipermail/ocfs2-devel/2015-January/010496.html
> 
> From above email archive, you mentioned those patches aim to reduce the host page cache consumption. But in my opinion, after append direct io, the page used for buffer is clean. System can realloc those cached pages. We can even call invalidate_mapping_pages to fast that process. Maybe more pages will be needed during direct io. But direct io size can not be too large, right?
> 
We introduced the append direct io because originally ocfs2 would fall
back to buffer io in case of thin provision, which was not the actual
behavior that user expect.
I didn't get you that more pages would be needed during direct io. Could
you please explain it more clearly?

Thanks,
Joseph

> Thanks,
> Ryan
> 
> 
