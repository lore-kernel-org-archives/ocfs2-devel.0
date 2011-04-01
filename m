From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 31 Mar 2011 22:29:13 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Cleanup for OCFS2_IOC_RESVSP &
	OCFS2_IOC_UNRESVSP.
In-Reply-To: <4D953C6C.40206@oracle.com>
References: <1301556866-8460-1-git-send-email-tristan.ye@oracle.com>
	<1301556866-8460-3-git-send-email-tristan.ye@oracle.com>
	<4D94EE85.1010808@oracle.com> <4D953C6C.40206@oracle.com>
Message-ID: <4D9562A9.9040901@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 3/31/2011 7:46 PM, Tristan Ye wrote:
>
> 	Those changes were a bit coherent to previous patch of adding punching-hole
> support to VFS ioctl(), which needs punching-hole to have both
> FALLOC_FL_KEEP_SIZE and FALLOC_FL_PUNCH_HOLE set, on the other hand, however
> you're right, I may have to make those changes in a more neat way.
>
> 	Given the fact that VFS already have two paths doing
> preallocation/punching-hole(maybe they're going to fire one), ways from ocfs2's
> specific ioctl() to accomplish this really can be deprecated.

Agreed.
