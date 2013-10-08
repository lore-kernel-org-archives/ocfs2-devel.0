From: Lars Marowsky-Bree <lmb@suse.de>
Date: Tue, 8 Oct 2013 22:02:39 +0200
Subject: [Ocfs2-devel] [PATCH 0/5] nocontrold: Eliminating
 ocfs2_controld v3
In-Reply-To: <20131008000608.GK5358@localhost>
References: <20131003054851.GA12878@shrek.lan> <20131003112528.GR20001@suse.de>
	<524ED84E.4040109@suse.de> <20131008000608.GK5358@localhost>
Message-ID: <20131008200239.GC31087@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013-10-07T17:06:09, Joel Becker <jlbec@evilplan.org> wrote:

> We already allow building of o2cb/user stacks via .config.  So on that
> note it isn't terribly different.
> 
> lmb, why do you want to enforce non-controld?  Shouldn't it be just fine
> to not install controld and let the filesystem detect a modern enough
> fs/dlm?

It's mostly an issue of what the distribution kernels wish to support.
One less variable to control for.

We either get that choice upstream or carry an out of tree patch, hence
my proposal to do it upstream ;-)



Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend?rffer, HRB 21284 (AG N?rnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
