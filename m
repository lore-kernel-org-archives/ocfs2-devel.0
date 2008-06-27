From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 27 Jun 2008 11:10:34 -0700
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
	support. v1
In-Reply-To: <48649B99.3090205@oracle.com>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
	<20080617233221.GD28100@wotan.suse.de>
	<48649B99.3090205@oracle.com>
Message-ID: <20080627181034.GB28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:49:45PM +0800, Tiger Yang wrote:
> I split setting long value operation into two parts. First insert tree 
> root in local, if succeed then insert long value into B tree based on 
> that tree root. If hit problem in second step, we could only get that 
> junk tree root. This is harmless for system. but is it acceptable?

If the junk root is ignored, and eventually overwritten as more ea's get
inserted then I don't think you need to do any more.

If the junk root stays in the block and occupies space that would otherwise
be used, then we probably need to handle this.. I imagine a clever user
could DOS the xattr space by making large ones when the system is low on
free space...
	--Mark

--
Mark Fasheh
