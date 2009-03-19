From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Mar 2009 15:13:00 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reused freed extent block
	in	b-tree operation.
In-Reply-To: <1237415178-15075-1-git-send-email-tao.ma@oracle.com>
References: <49C0FDDC.2030704@oracle.com>
	<1237415178-15075-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090319221300.GC18943@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 19, 2009 at 06:26:18AM +0800, Tao Ma wrote:
> Hi all,
>         This is the patch for the RFC. I have tested it in my ppc
> box, it works OK.
> 
> In some b-tree operations we may have the chance that we haven't
> reserved any metadata at the beginning because we think we don't
> need. While the 1st operation free a extent block while the 2nd
> operation need one. Our current code can't handle this. So this
> patch try to re-use the freed extent block so that we can pass
> the scenario above. For more details about the bug, see
> 
> [RFC] metadata alloc fix in machines which has PAGE_SIZE > CLUSTER_SIZE
> http://oss.oracle.com/pipermail/ocfs2-devel/2009-March/004185.html.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This looks sane to me, but I'd like Mark's opinion as well.  He
knows the tree code better than I do.

Joel

-- 

Life's Little Instruction Book #274

	"Leave everything a little better than you found it."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
