From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Jun  4 12:22:31 2004
Subject: [Ocfs2-devel] RE: [Ocfs-devel] [Patch] for bug 81
In-Reply-To: <3ACA40606221794F80A5670F0AF15F84048AA57D@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F84048AA57D@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040604172201.GE5953@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 04, 2004 at 01:53:20PM +0800, Ling, Xiaofeng wrote:
> seems the fix is rollback in revision 1001 

	Good catch.  We (that is, I) broke the tree and then reverted
all my changes, and I accidentally rolled the fix back too.  It returns
in revision 1002.

Joel

-- 

Life's Little Instruction Book #313

	"Never underestimate the power of love."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
