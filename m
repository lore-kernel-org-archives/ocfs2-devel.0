From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 2 Jun 2009 11:43:00 -0700
Subject: [Ocfs2-devel] [PATCH 0/7] [RESEND] Fix some deadlocks in quota
	code and	implement lockdep for cluster locks
In-Reply-To: <1243945445-25847-1-git-send-email-jack@suse.cz>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
Message-ID: <20090602184300.GB31976@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 02, 2009 at 02:23:58PM +0200, Jan Kara wrote:
>   BTW: Currently lockdep complains about some configfs issue and turns itself
> off so that's why I didn't get to finding more deadlocks ;)

	That's in linux-next of the configfs tree :-)

Joel

-- 

"Hell is oneself, hell is alone, the other figures in it, merely projections."
        - T. S. Eliot

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
