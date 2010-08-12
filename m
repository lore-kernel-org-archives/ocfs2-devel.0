From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Aug 2010 17:30:52 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v8.
In-Reply-To: <1274516793-29129-2-git-send-email-tristan.ye@oracle.com>
References: <1274516793-29129-1-git-send-email-tristan.ye@oracle.com>
	<1274516793-29129-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100812003052.GA8985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, May 22, 2010 at 04:26:33PM +0800, Tristan Ye wrote:
> The reason why we need this ioctl is to offer the none-privileged
> end-user a possibility to get filesys info gathering.
> 
> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
> structure to kernel containing an array of request pointers and request
> count, such as,
> 
> * From userspace:
> 
> struct ocfs2_info_blocksize oib = {
>         .ib_req = {
>                 .ir_magic = OCFS2_INFO_MAGIC,
>                 .ir_code = OCFS2_INFO_BLOCKSIZE,
>                 ...
>         }
>         ...
> }
> 
> struct ocfs2_info_clustersize oic = {
>         ...
> }
> 
> uint64_t reqs[2] = {(unsigned long)&oib,
>                     (unsigned long)&oic};
> 
> struct ocfs2_info info = {
>         .oi_requests = reqs,
>         .oi_count = 2,
> }
> 
> ret = ioctl(fd, OCFS2_IOC_INFO, &info);
> 
> * In kernel:
> 
> Get the request pointers from *info*, then handle each request one bye one.
> 
> Idea here is to make the spearated request small enough to guarantee
> a better backward&forward compatibility since a small piece of request
> would be less likely to be broken if filesys on raw disk get changed.
> 
> Currently, the following 7 requests are supported per the requirement from
> userspace tool o2info, and I believe it will grow over time:-)
> 
>         OCFS2_INFO_CLUSTERSIZE
>         OCFS2_INFO_BLOCKSIZE
>         OCFS2_INFO_MAXSLOTS
>         OCFS2_INFO_LABEL
>         OCFS2_INFO_UUID
>         OCFS2_INFO_FS_FEATURES
>         OCFS2_INFO_JOURNAL_SIZE
> 
> This ioctl is only specific to OCFS2.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
