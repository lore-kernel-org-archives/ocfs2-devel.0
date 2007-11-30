From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Nov 30 15:43:39 2007
Subject: [Ocfs2-devel] [PATCH 1/3] Add online resize support for ocfs2,
	take 2
In-Reply-To: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
References: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
Message-ID: <20071130234244.GG28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 27, 2007 at 04:11:23PM +0800, tao.ma wrote:
> Modification from V1 to V2:
> Divide the whole processes into 2 steps like ext3.
> 1) If the last group isn't full, tunefs.ocfs2 will call
>    OCFS2_IOC_GROUP_EXTEND first to extend it. All the main work is
>    done in kernel.
> 2) For every new groups, tunefs.ocfs2 will call OCFS2_IOC_GROUP_ADD
>    to add them one by one. The new group descriptor is initialized
>    in userspace, we only check it in the kernel and update the
>    global_bitap, super blocks etc.

One more blanket comment about these patches - be sure to run the patched
source through the "sparse" tool. It will help us catch endian bugs when
reading/writing on-disk fields. LWN actually has a good tutorial:

http://lwn.net/Articles/205624/
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
