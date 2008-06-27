From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 27 Jun 2008 15:49:45 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
 support. v1
In-Reply-To: <20080617233221.GD28100@wotan.suse.de>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
	<20080617233221.GD28100@wotan.suse.de>
Message-ID: <48649B99.3090205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Mark,

Mark Fasheh wrote:
> Hmm, some comments describing this function would be helpfull. In
> particular, I'd like to know how failure in the middle of an operation is
> handled. Say you're expanding the ea because the user asked to store a
> larger size, but you hit a problem shortly after growing it. What happens?

I split setting long value operation into two parts. First insert tree 
root in local, if succeed then insert long value into B tree based on 
that tree root. If hit problem in second step, we could only get that 
junk tree root. This is harmless for system. but is it acceptable?

I have an idea to fix this problem by reduce the entry count when second 
step hit problem. Do we have to do this?

All other issues fixed in the second version patches.

thanks and regards,
tiger
