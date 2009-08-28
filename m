From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 27 Aug 2009 18:10:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
Message-ID: <20090828011018.GG18962@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 14, 2009 at 02:02:39PM +0800, Wengang Wang wrote:
> this patch adds some mlogs to apos.c helping tracing and narrowing down bugs.

Wengang,
	Have these traces been of use to you, or are you just adding
some entry/exit traces because you see functions without them?

Joel

-- 

Life's Little Instruction Book #274

	"Leave everything a little better than you found it."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
