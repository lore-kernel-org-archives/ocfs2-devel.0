From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 1 Dec 2010 19:09:33 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach 'coherency=full'
 O_DIRECT writes to correctly up_read i_alloc_sem.
In-Reply-To: <4CE9E198.4070709@oracle.com>
References: <1290155919-4280-1-git-send-email-tristan.ye@oracle.com>
	<4CE68B0B.8010308@oracle.com> <4CE9D3DF.4070707@oracle.com>
	<4CE9DC7B.9010703@oracle.com> <4CE9E198.4070709@oracle.com>
Message-ID: <20101202030932.GE16604@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 22, 2010 at 11:20:56AM +0800, Tristan Ye wrote:
> >yes, it looks more natural and easy. So when you lock i_alloc_sem,
> >just call ocfs2_iocb_set_sem_locked, and when  you lock rw_lock,
> >just set the ocfs2_iocb_set_rw_locked. That's it. You don't neet
> >to think about some stuff like coherency or not.
> 
> Reasonable.
> 
> Joel,
> 
>    How do you think about it?

	I agree with Tao.  ocfs2_dio_end_io() doesn't care why the
locks are locked; it just needs to know which ones to release.

Joel
 

-- 

Life's Little Instruction Book #20

	"Be forgiving of yourself and others."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
