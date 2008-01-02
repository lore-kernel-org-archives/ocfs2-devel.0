From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jan  2 15:12:57 2008
Subject: [Ocfs2-devel] Re: [PATCH 09/30] ocfs2: Define enum umh_wait
In-Reply-To: <1199139862-31452-8-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
	<1199139862-31452-8-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080102231218.GD8779@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 31, 2007 at 02:24:01PM -0800, Sunil Mushran wrote:
> Commit 86313c488a6848b7ec2ba04e74f25f79dd32a0b7 in mainline introduced
> enum umh_wait. This patch allows one to build ocfs2 with kernels having/
> not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  Makefile                   |    3 ++-
>  configure.in               |    5 +++++
>  kapi-compat/include/kmod.h |   10 ++++++++++

	I'd call it kapi-compat/include/umh_wait.h, but that's a tiny
niggle.

Joel
 
-- 

Life's Little Instruction Book #94

	"Make it a habit to do nice things for people who 
	 will never find out."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
