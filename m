From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 14 Apr 2015 14:18:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Add errors=continue
In-Reply-To: <20150303180829.GA13122@shrek.lan>
References: <20150303180829.GA13122@shrek.lan>
Message-ID: <552CB11F.60801@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,
On 2015/3/4 2:08, Goldwyn Rodrigues wrote:
> OCFS2 is often used in high-availaibility systems. However, ocfs2
> converts the filesystem to read-only at the drop of the hat. This
> may not be necessary, since turning the filesystem read-only would
> affect other running processes as well, decreasing availability.
> 
> This attempt is to add errors=continue, which would return the EIO
> to the calling process and terminate furhter processing so that
> the filesystem is not corrupted further. However, the filesystem
> is not converted to read-only.
> 
> As a future plan, I intend to create a small utility or extend
> fsck.ocfs2 to fix small errors such as in the inode. The input
> to the utility such as the inode can come from the kernel logs
> so we don't have to schedule a downtime for fixing small-enough
> errors.
I am interested in your thought. As a cluster filesystem, I don't think
it is a good idea that we set the whole filesystem to readonly because
of a small error (for example, inode OCFS2_VALID_FL not set). It impacts
too much. So we can isolate some errors and fix them in the backgroud,
without offline fsck.
I think you can send a RFC to discuss this topic.

--
Joseph
