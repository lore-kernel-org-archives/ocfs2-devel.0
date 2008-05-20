From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 20 May 2008 16:53:01 -0700
Subject: [Ocfs2-devel] [2.6 patch] ocfs2: rename user_stack{,_ops}
In-Reply-To: <20080520225509.GD16264@cs181133002.pp.htv.fi>
References: <20080520225509.GD16264@cs181133002.pp.htv.fi>
Message-ID: <20080520235301.GM26609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:55:09AM +0300, Adrian Bunk wrote:
> This patch therefore prefixes the user_stack{,_ops} names with ocfs2_

	Thanks for reporting this.  Al already reported it and a fix is
in ocfs2.git.  We change the name entirely so that grep of user_stack
doesn't match it at all.

Joel

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
