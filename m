From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 13:06:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered
In-Reply-To: <201004222213.51266.lidongyang@novell.com>
References: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
	<201004141358.20777.lidongyang@novell.com>
	<20100414192011.GA29831@mail.oracle.com>
	<201004222213.51266.lidongyang@novell.com>
Message-ID: <20100423200617.GA10637@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 22, 2010 at 10:13:51PM +0800, Li Dongyang wrote:
> another question: why do we only take PR on the rw_lock and do not allow a 
> direct write extending the i_size?

	The rw_lock is the cluster equivalent of the alloc_sem.  We take
a PR when we intend to use the existing allocation but will not modify
the allocation.  When we want to change the allocation (filling holes,
changing unwritten extents, growing i_size) we must take an EX.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
