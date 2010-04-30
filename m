From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Apr 2010 13:52:43 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered v3
In-Reply-To: <20100430204705.GC1938@mail.oracle.com>
References: <201004171749.10674.lidongyang@novell.com>
	<20100430204705.GC1938@mail.oracle.com>
Message-ID: <20100430205243.GD1938@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 30, 2010 at 01:47:05PM -0700, Joel Becker wrote:
> 	Have you tested this version?  I got a compile error:

	I want to be clear - has this patch (v3) been run against the
fsstress that caused the bug report in the first place?  Does the
fsstress now pass?  Let me know so I can send it upstream.

Joel

-- 

Life's Little Instruction Book #314

	"Never underestimate the power of forgiveness."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
