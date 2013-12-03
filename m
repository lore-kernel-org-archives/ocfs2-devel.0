From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 3 Dec 2013 07:38:52 +0000
Subject: [Ocfs2-devel] [PATCH] Remove versioning information
In-Reply-To: <20131203000635.GC16774@wotan.suse.de>
References: <20131126233722.GA20032@shrek.lan>
	<20131203000635.GC16774@wotan.suse.de>
Message-ID: <20131203073852.GB7047@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 02, 2013 at 04:06:35PM -0800, Mark Fasheh wrote:
> On Tue, Nov 26, 2013 at 05:37:27PM -0600, Goldwyn Rodrigues wrote:
> > The versioning information is confusing for end-users. The numbers
> > are stuck at 1.5.0 while the tools version have moved to 1.8.2.
> > 
> > I suggest removing the versioning system in the ocfs2 module and let
> > the kernel version be the guide to debug issues. However, if
> > you think versioning is still required, please state the reason and
> > modify the version string in the *ver.h files.
> 
> Thanks for this. Once upon a time the versioning helped us but these days
> it's just outdated info
> 
> I would keep the module description if you don't mind. Something short and
> straight forward:
> 
> MODULE_DESCRIPTION("Ocfs2 cluster file system");
> 
> I don't know that we really need a description for the other two modules.

I also agree we should remove the versions.  However, we should retain
descriptions for all of them.

Joel

> 	--Mark
> 
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 
