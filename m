From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 22 Jun 2009 12:25:09 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>
References: <1245696007-29494-1-git-send-email-sunil.mushran@oracle.com>
	<1245696007-29494-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090622192509.GB3902@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 22, 2009 at 11:40:07AM -0700, Sunil Mushran wrote:
> Local and Hard-RO mounts do not need orphan scanning.

	I just realized that we hold the os->os_lock around everything
we do here.  The orphan scan state doesn't need to be atomic_t.

Joel


-- 

"I don't know anything about music. In my line you don't have
 to."
        - Elvis Presley

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
