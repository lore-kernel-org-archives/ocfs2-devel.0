From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 20 15:23:00 2007
Subject: [Ocfs2-devel] [PATCH 1/2] Initalize bitmap_cpg of ocfs2_super
	to be the maximum,take 1
In-Reply-To: <47436A4A.1030409@oracle.com>
References: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
	<20071116084110.GA3893@tma-pc1.cn.oracle.com>
	<20071120225859.GG28607@ca-server1.us.oracle.com>
	<47436A4A.1030409@oracle.com>
Message-ID: <20071120232233.GH28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 20, 2007 at 03:14:18PM -0800, Sunil Mushran wrote:
> We encountered this during offline resize.
>
> While fsck.ocfs2 was updated to fix this issue, we never
> did address the same in mkfs.
>
> As the chances that a user will encounter this is fairly low,
> we could always bail online resize if it encountered this issue.
> (A dirty read of the global bitmap from tune should suffice.)
>
> If so, ask user to run fsck.

Yeah, that's fine by me. We need to fix it in mkfs.ocfs2 though, before or
at the same time this patch series goes in.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
