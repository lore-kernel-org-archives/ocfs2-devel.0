From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Jun 2009 19:26:46 -0700
Subject: [Ocfs2-devel] [PATCH 0/7] [RESEND] Fix some deadlocks in quota
	code and	implement lockdep for cluster locks
In-Reply-To: <1243945445-25847-1-git-send-email-jack@suse.cz>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
Message-ID: <20090604022646.GF7933@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 02, 2009 at 02:23:58PM +0200, Jan Kara wrote:
>   I'm resending this patch series. It's rediffed against linux-next branch of
> Joel's git tree. The first four patches are obvious fixes of deadlocks in quota
> code and should go in as soon as possible. The other three patches implement
> lockdep support for OCFS2 cluster locks. So you can have a look whether the
> code make sence to you and possibly merge them. They should be NOP when lockdep
> is disabled and help a lot when debugging various locking problems (with these
> patches I found the problems fixed in the beginning of the series).
>   BTW: Currently lockdep complains about some configfs issue and turns itself
> off so that's why I didn't get to finding more deadlocks ;)

	The fixes are now in the merge-window branch of ocfs2.git.  They
also live on the quota-fixes topic branch.  The lockdep changes still
need some marinating.

Joel

-- 

Life's Little Instruction Book #274

	"Leave everything a little better than you found it."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
