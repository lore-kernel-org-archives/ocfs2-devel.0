From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 7 Oct 2013 17:06:09 -0700
Subject: [Ocfs2-devel] [PATCH 0/5] nocontrold: Eliminating
 ocfs2_controld v3
In-Reply-To: <524ED84E.4040109@suse.de>
References: <20131003054851.GA12878@shrek.lan> <20131003112528.GR20001@suse.de>
	<524ED84E.4040109@suse.de>
Message-ID: <20131008000608.GK5358@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 04, 2013 at 10:01:34AM -0500, Goldwyn Rodrigues wrote:
> On 10/03/2013 06:25 AM, Lars Marowsky-Bree wrote:
> > On 2013-10-03T00:48:55, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> >
> > And, perhaps, a compile-time option to disable this earlier, so that
> > users can choose the stacks they want to build the kernel with.
> >
> 
> This would a be a couple of ifdef's in user_cluster_connect(). What do 
> other ocfs2 developers feel about this?

We already allow building of o2cb/user stacks via .config.  So on that
note it isn't terribly different.

lmb, why do you want to enforce non-controld?  Shouldn't it be just fine
to not install controld and let the filesystem detect a modern enough
fs/dlm?

Joel

> 
> 
> -- 
> Goldwyn
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #306

	"Take a nap on Sunday afternoons."

			http://www.jlbec.org/
			jlbec at evilplan.org
