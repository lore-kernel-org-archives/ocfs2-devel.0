From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date: Wed, 14 Oct 2015 22:25:02 -0500
Subject: [Ocfs2-devel] Ocfs2-devel Digest, Vol 138, Issue 31 review
In-Reply-To: <2015101509311504278915@h3c.com>
References: <mailman.1701.1440805574.13254.ocfs2-devel@oss.oracle.com>
	<2015101415485251084042@h3c.com> <561E0E8D.6070102@huawei.com>
	<2015101416441090805161@h3c.com> <561E1902.507@huawei.com>
	<561E4229.7090804@suse.com> <2015101509311504278915@h3c.com>
Message-ID: <561F1C8E.80504@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 10/14/2015 09:54 PM, Zhangguanghui wrote:
> Thanks for reply, just like what Goldwyn said, there is a critical
> result for such a simple process.
> It has encountered EROFS all the time while calling ocfs2_start_trans,
> even if the storage is back to normal.
> I 'm trying  to make some
> other changes and don't know if the error is still being shown.
> Any feedback or suggestionabout this process (positive or negative)
> would be greatly appreciated.
> thanks again
>

Have you tried fsck.ocfs2? If yes, what does the log say?

-- 
Goldwyn
