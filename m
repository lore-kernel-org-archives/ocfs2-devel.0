From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Feb 10 20:26:06 2004
Subject: [Ocfs2-devel] Patch to add some error checking to super.c
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A568BD@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> When dealing with a code base, it's best to use the style the 
> rest of the
> file uses. So stuff like:
> 
> 	if (!OcfsGlobalCtxt.oin_cache)
> 		return -ENOMEM;
> 
> is preferred, or even OcfsGlobalCtxt.oin_cache == NULL

Sounds good.  I will fix it up and resubmit.  Probably on Wednesday.

John
