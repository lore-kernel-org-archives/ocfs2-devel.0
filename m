From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 May 2008 18:06:04 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Add cluster lock stats at
	the	fs level
In-Reply-To: <20080513004255.GF25156@wotan.suse.de>
References: <1210269421-10192-1-git-send-email-sunil.mushran@oracle.com>
	<1210269421-10192-2-git-send-email-sunil.mushran@oracle.com>
	<20080513004255.GF25156@wotan.suse.de>
Message-ID: <20080513010604.GH12100@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 12, 2008 at 05:42:55PM -0700, Mark Fasheh wrote:
> On Thu, May 08, 2008 at 10:57:01AM -0700, Sunil Mushran wrote:
> 
> > @@ -2461,7 +2531,11 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
> >  }
> >  
> >  /* So that debugfs.ocfs2 can determine which format is being used */
> > +#ifdef CONFIG_OCFS2_FS_STATS
> > +#define OCFS2_DLM_DEBUG_STR_VERSION 2
> > +#else
> >  #define OCFS2_DLM_DEBUG_STR_VERSION 1
> > +#endif
> 
> Why not just bump this and print zero's if CONFIG_OCFS2_FS_STATS isn't
> enabled?

	I second this.

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
