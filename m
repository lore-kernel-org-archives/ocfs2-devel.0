From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 11:21:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2 fix o2dlm dlm run purgelist(bug
 9094491) - rev3
In-Reply-To: <1277272108-3160-1-git-send-email-srinivas.eeda@oracle.com>
References: <1277272108-3160-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100712182117.GA12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2010 at 10:48:28PM -0700, Srinivas Eeda wrote:
> +	if (!__dlm_lockres_unused) {
> +		mlog(ML_ERROR, "found lockres %s:%.*s: in use after deref\n",
> +		     dlm->name, res->lockname.len, res->lockname.name);
> +		__dlm_print_one_lock_resource(res);
> +		BUG();
> +	}

/build/jlbec/linux-2.6/working/fs/ocfs2/dlm/dlmthread.c: In function ?dlm_purge_lockres?:
/build/jlbec/linux-2.6/working/fs/ocfs2/dlm/dlmthread.c:203: warning: the address of ?__dlm_lockres_unused? will always evaluate as ?true?

	Was this even tested?  I'm leaving this patch out of 'fixes'
until corrected and tested.

Joel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
