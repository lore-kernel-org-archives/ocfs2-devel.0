From: Manish Singh <manish.singh@oracle.com>
Date: Fri Apr  2 17:04:40 2004
Subject: [Ocfs2-devel] [Patch] install module on 2.6
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8403D2C732@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8403D2C732@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040402230434.GA25583@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 02, 2004 at 11:56:50AM +0800, Ling, Xiaofeng wrote:
> It seems on 2.6 kernel, "make install" does not work.
> A simple patch to fix it

Committed a modifed version.
 
> 
> Index: src/Makefile
> ===================================================================
> --- src/Makefile	(revision 833)
> +++ src/Makefile	(working copy)
> @@ -239,7 +239,13 @@
>  
>  all:
>  	$(MAKE) -C $(KDIR) SUBDIRS=$(CURDIR) modules
> +install:install-ocfs

With makebo, use INSTALL_RULES to hook into the install rule, instead of
overriding it. Should've also done it for all, and now we do.
  
> +install-ocfs: ocfs2.ko
> +	$(TOPDIR)/mkinstalldirs $(DESTDIR)$(MODULEDIR)/ocfs
> +	$(INSTALL_DATA) ocfs2.ko $(DESTDIR)$(MODULEDIR)/ocfs/ocfs2.ko
> +	depmod -a
> +
>  endif # OCFS_KERNEL_2_6

I've made this shared with 2.4 now.

-Manish
