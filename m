From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 26 Mar 2011 14:44:04 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: clean up mount option about
 atime in ocfs2.txt
In-Reply-To: <1299065529-6626-1-git-send-email-tiger.yang@oracle.com>
References: <4D6E2994.1050302@oracle.com>
	<1299065529-6626-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20110326214403.GB8837@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 02, 2011 at 07:32:09PM +0800, Tiger Yang wrote:
> -	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
> +	if (!(mnt->mnt_flags & MNT_NOATIME) && !(mnt->mnt_flags & MNT_RELATIME))
>  		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);

	I can see why you don't print in the case of noatime or
relatime, but you should keep the check for DEFAULT_ATIME_QUANTUM.
There's no point in printing it if it is the default.

Joel

-- 

Life's Little Instruction Book #510

	"Count your blessings."

			http://www.jlbec.org/
			jlbec at evilplan.org
